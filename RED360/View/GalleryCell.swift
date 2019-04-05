//
//  GalleryCell.swift
//  RED360
//
//  Created by Argo Solucoes on 17/02/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class GalleryCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PhotoCellDelegate {
    
    @IBOutlet weak var images: UICollectionView!
    
    var superViewController: REDFormViewController?
    
    var listImages: [UIImage]? {
        didSet{
            self.images.reloadData()
        }
    }
    
    override func awakeFromNib() {
        
        self.selectionStyle = .none
        images.delegate = self
        images.dataSource = self
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let listImages = listImages else {return 0}
        return listImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {return PhotoCell()}
        
        cell.delegate = self
        cell.image.image = self.listImages?[indexPath.row]
        cell.index = indexPath.row
        return cell
    }
    
    func deleteImage(index: Int) {
        self.listImages?.remove(at: index)
        self.superViewController?.images.remove(at: index)
        self.images.reloadData()
    }
    
}

protocol PhotoCellDelegate: class {
    func deleteImage(index: Int)
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    var index: Int?
    
    weak var delegate: PhotoCellDelegate?
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func deleteImage() {
        delegate?.deleteImage(index: self.index!)
    }
    
}
