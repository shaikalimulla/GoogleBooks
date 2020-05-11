//
//  APIRunner.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/10/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

class APIRunner {
    
    static let shared = APIRunner()
    
    let session = ConfigurationManager.shared.getUrlSession()
    let bookModel = BookModel.shared
    
    var isError = false
    
    func processRequest(_ url : URL, _ completion: @escaping (Bool)->()) {
        session.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            do {
                if data != nil {
                    let json = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                    guard let items = json["items"] as! [[String: Any]]? else {
                        self.isError = true
                        throw JSONError.InvalidArray("items")
                    }
                    
                    for item in items {
                        guard let id = item["id"] as! String? else {
                            self.isError = true
                            throw JSONError.InvalidKey("id")
                        }
                        
                        guard let volumeInfo = item["volumeInfo"] as! [String: AnyObject]? else {
                            self.isError = true
                            throw JSONError.InvalidKey("volumeInfo")
                        }
                        
                        let title = volumeInfo["title"] as? String ?? "Title not available"
                        
                        var authors = "No author information"
                        
                        if let authorsArray = volumeInfo["authors"] as! [String]? {
                            authors = authorsArray.joined(separator: ", ")
                        }
                        
                        guard let imageLinks = volumeInfo["imageLinks"] as! [String: AnyObject]? else {
                            self.bookModel.resultData.append(Book(id: id, title: title, author: authors, thumbnail: nil))
                            continue
                        }
                        
                        let thumbnail = imageLinks["thumbnail"] as? String
                        
                        let book = Book(id: id, title: title, author: authors, thumbnail: thumbnail)
                        
                        self.bookModel.resultData.append(book)
                    }
                }
                
                print("Book details count: \(self.bookModel.getBooksCount())")
                
            } catch  {
                print("Error thrown: \(error)")
                self.isError = true
            }
            
            completion(self.isError)
        }).resume()
    }
    
    func dispatchQueue(_ id: String, _ url : URL, _ completion: @escaping (Int)->()) throws {
        DispatchQueue.global(qos: .background).async {
            let data = try? Data(contentsOf: url)
            
            if (data != nil) {
                self.bookModel.imagesData.append(ImageData(id: id, Data: data!))
            }
            
            self.bookModel.downloadedImagesCount = self.bookModel.downloadedImagesCount + 1
            
            completion(self.bookModel.downloadedImagesCount)
        }
    }
}
