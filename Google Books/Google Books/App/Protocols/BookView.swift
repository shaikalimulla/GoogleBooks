//
//  BookView.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/9/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

protocol BookView : NSObjectProtocol {
    func reloadData()
    
    func showError()
}
