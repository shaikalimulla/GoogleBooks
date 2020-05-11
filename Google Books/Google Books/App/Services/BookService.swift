//
//  BookService.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/9/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

class BookService {
    let apiManager = APIManager.shared
    let bookModel = BookModel.shared
    
    public func search(_ text: String, _ completion: @escaping (Bool)->()) throws {
        self.clearData()
        try apiManager.getBookDetails(text, completion)
    }
    
    func getImages(_ completion: @escaping ()->()) throws {
        var availableImagesCount = 0
        for book in self.bookModel.resultData {
            if (book.thumbnail != nil) {
                availableImagesCount = availableImagesCount + 1
            }
        }
        
        if (availableImagesCount == 0) {
            completion()
            return
        }
        
        for book in self.bookModel.resultData {
            if (book.thumbnail != nil) {
                try apiManager.getImage(book.id, book.thumbnail!, { (data) in
                    DispatchQueue.main.async {
                        if (data == availableImagesCount) {
                            print("Book image details: \(data)")
                            completion()
                        }
                    }
                })
            }
        }
    }
    
    func isImageAvailable(_ index: Int) -> Bool {
        let book = self.bookModel.getBook(index)
        let imageData = self.bookModel.getImageData(index)
        
        if (book.thumbnail != nil && imageData != nil) {
            return true
        }
        
        return false;
    }
    
    func getBookDetails(_ index: Int) -> Book {
        return self.bookModel.getBook(index)
    }
    
    func getBooksCount() -> Int {
        return self.bookModel.getBooksCount()
    }
    
    func getImageData(_ index: Int) -> ImageData? {
        return self.bookModel.getImageData(index)
    }
    
    func clearData() {
        self.bookModel.clear()
    }
}
