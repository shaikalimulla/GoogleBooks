//
//  BookModel.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/10/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

class BookModel {
    static let shared = BookModel()
    
    var resultData: [Book]
    var imagesData: [ImageData]
    
    public var downloadedImagesCount: Int
    
    init() {
        resultData = []
        imagesData = []
        downloadedImagesCount = 0
    }
    
    func clear() {
        resultData.removeAll()
        imagesData.removeAll()
        downloadedImagesCount = 0
    }
    
    func getBook(_ index: Int) -> Book {
        return self.resultData[index]
    }
    
    func getBooksCount() -> Int {
        return resultData.count;
    }
    
    func getBooks() -> [Book] {
        return resultData
    }
    
    func getImageData(_ index: Int) -> ImageData? {
        if (index < imagesData.count) {
            return self.imagesData[index]
        }
        
        return nil;
    }
    
    func getImagesCount() -> Int {
        return imagesData.count;
    }
}
