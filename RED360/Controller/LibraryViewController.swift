//
//  LibraryViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import AlamofireImage
import ImageSlideshow
import PDFReader

class LibraryViewController: SlideViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var heightBackButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var booksCollect: UICollectionView!
    var books: [LibraryModel]?
    var actualBibliotecaId: Int?
    
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Fotografia de sucesso")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
            self.vLoading?.isHidden = true
            
            Rest.getLibrary { (libraries, accessDenied) in
                self.books = libraries
                self.heightBackButtonConstraint.constant = 0
                self.backButton.isHidden = true
                self.booksCollect.reloadData()
            }
        }
        
    }
    
    func getSize(value: Int) -> Int {
        var x = value
        while !verifyComplete(value: x) {
            x += 1
        }
        return x
    }
    
    func verifyComplete(value: Int) -> Bool {
        if (value/3) * 3 == value {
            return true
        }
        return false
    }
}
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let heightCell = screenWidth/3 + 15
        var n = Int(screenHeight*3/heightCell)
        n = getSize(value: n)
        
        guard let books = self.books else{return n}
        let n2 = books.count > n ? getSize(value: books.count) : n
        return n2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCell", for: indexPath) as! LibraryCell
        guard let books = self.books else {return cell}
        cell.bookImage.image = nil
        cell.delegate = self
        if indexPath.row < books.count {
            guard let capa = self.books?[indexPath.row].urlCapa else {return cell}
            AlamofireSource(urlString: capa)?.load(to: cell.bookImage, with: { (image) in
                if let image = image {
                    cell.bookImage.image = image
                }
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/3, height: screenWidth/3 + 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let books = books else {return}
        if let urlString = books[indexPath.row].urlArquivo {
//            self.vLoading?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                let remotePDFDocumentURL = URL(string: urlString)!
                let document = PDFDocument(url: remotePDFDocumentURL)!
                let readerController = PDFViewController.createNew(with: document)
                self.navigationController?.pushViewController(readerController, animated: true)
            })
        }
    }
    
}
extension LibraryViewController: LibraryCellDelegate {
    func favorite() {
        self.booksCollect.reloadData()
    }
}

