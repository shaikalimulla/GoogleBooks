//
//  ConfigurationManager.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/10/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

class ConfigurationManager {
    static let shared = ConfigurationManager()
    
    // MARK: - Constant properties
    private let baseURL = "https://www.googleapis.com/books"
    
    func getBaseUrl() -> String {
        return baseURL;
    }
    
    func getUrlSession() -> URLSession {
        return URLSession.shared
    }
}
