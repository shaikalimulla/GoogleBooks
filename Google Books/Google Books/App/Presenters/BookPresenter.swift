//
//  BookPresenter.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/9/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import Foundation

class BookPresenter {

    // MARK: - Private
    let bookService: BookService
    weak fileprivate var bookView: BookView?
    
    public init(bookService: BookService){
        self.bookService = bookService
    }
    
    func attachView(_ attach: Bool, view: BookView?) {
        if let view = view { bookView = view }
    }
    
    func detachView() {
        bookView = nil
    }
    
    func searchBookDetails(_ text: String) throws {
        do {
            try self.bookService.search(text, { (isError) in
                DispatchQueue.main.async {
                    if (isError) {
                        self.bookView?.showError()
                        return
                    }
                    
                    do {
                        try self.bookService.getImages({ () in
                            DispatchQueue.main.async {
                                self.bookView?.reloadData()
                            }
                        })
                    } catch {
                        self.bookView?.showError()
                    }
                }
            })
        } catch {
            self.bookView?.showError()
        }
    }
    
    func getBookDetails(_ index: Int) -> Book {
        return self.bookService.getBookDetails(index)
    }
    
    func getNumberOfItemsInSection() -> Int {
        return self.bookService.getBooksCount()
    }
    
    func isImageAvailable(_ index: Int) -> Bool {
        return self.bookService.isImageAvailable(index)
    }
    
    func getImageData(_ index: Int) -> ImageData? {
        return self.bookService.getImageData(index)
    }
}
