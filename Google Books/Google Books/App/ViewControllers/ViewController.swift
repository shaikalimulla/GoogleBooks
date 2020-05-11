//
//  ViewController.swift
//  Google Books
//
//  Created by Alimulla Shaik on 5/8/20.
//  Copyright © 2020 Alimulla Shaik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BookView {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    fileprivate let bookPresenter = BookPresenter(bookService: BookService())
    
    private let reuseIdentifier = "cellReusableId"
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 20.0,
                                             right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIndicator(true)
        setErrorLabel(true)
        setCollectionView(false)
        searchBar.delegate = self
        bookPresenter.attachView(true, view: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.bookPresenter.detachView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        setIndicator(false)
        setErrorLabel(true)
        setCollectionView(true)
        
        if let searchText = self.searchBar.text {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
            do {
                try self.bookPresenter.searchBookDetails(searchText)
            } catch {
                showError()
            }
        }
    }
    
    // MARK: - Implemented BookView protocol
    
    func reloadData() {
        self.searchBar.resignFirstResponder()
        self.collectionView.reloadData()
        setIndicator(true)
        setErrorLabel(true)
        setCollectionView(false)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func showError() {
        errorLabel.text = "No Results Found"
        setIndicator(true)
        setErrorLabel(false)
        setCollectionView(true)
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections: Int) -> Int {
        return 1
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookPresenter.getNumberOfItemsInSection()
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.lightGray
        if let titleLabel = cell.titleLabel, let detailLabel = cell.authorLabel, let imageView = cell.imageView {
            if (self.bookPresenter.isImageAvailable(indexPath.row)) {
                if let imageData = self.bookPresenter.getImageData(indexPath.row) {
                    if let data = imageData.Data {
                        imageView.image = UIImage(data: data)
                        imageView.isHidden = false
                        detailLabel.isHidden = true
                        titleLabel.isHidden = true
                        return cell
                    }
                }
            }
            
            let book = self.bookPresenter.getBookDetails(indexPath.row)
            
            detailLabel.text = book.author
            titleLabel.text = book.title
            imageView.isHidden = true
            detailLabel.isHidden = false
            titleLabel.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    private func setIndicator(_ isHidden : Bool) {
        activityIndicator.isHidden = isHidden
    }
    
    private func setErrorLabel(_ isHidden : Bool) {
        errorLabel.isHidden = isHidden
    }
    
    private func setCollectionView(_ isHidden : Bool) {
        collectionView.isHidden = isHidden
    }
}



