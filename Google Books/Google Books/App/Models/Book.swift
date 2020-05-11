//
//  Book.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/9/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

struct Book {
    var id: String
    var title: String?
    var author: String?
    var thumbnail: String?
}

struct ImageData {
    var id: String
    var Data: Data?
}

enum JSONError: Error {
    case InvalidURL(String)
    case InvalidKey(String)
    case InvalidArray(String)
    case InvalidData
    case InvalidImage
    case indexOutOfRange
    
}
