//
//  APIManager.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/10/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    let apiRunner = APIRunner.shared
    
    let baseUrl = ConfigurationManager.shared.getBaseUrl()
    
    let BOOK_QUERY_TEMPLATE = [
        URLQueryItem(name: "fields", value: "items(id,volumeInfo(title,authors, imageLinks))")
    ]
    
    func getBookDetails(_ text: String, _ completion: @escaping (Bool)->()) throws {
        // Generate the query for this text
        var query = BOOK_QUERY_TEMPLATE
        query.append(URLQueryItem(name: "q", value: text))
        
        guard let bookUrl = NSURLComponents(string: baseUrl + "/v1/volumes") else {
            throw JSONError.InvalidURL(baseUrl + "/v1/volumes")
        }
        
        bookUrl.queryItems = query
    
        apiRunner.processRequest(bookUrl.url!, completion)
    }
    
    func getImage(_ id: String, _ imageUrl: String, _ completion: @escaping (Int)->()) throws {
        guard let bookUrl = NSURLComponents(string: imageUrl) else {
            throw JSONError.InvalidURL(imageUrl)
        }
        
        try apiRunner.dispatchQueue(id, bookUrl.url!, completion)
    }
}
