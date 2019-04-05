//
//  LibraryCell.swift
//  RED360
//
//  Created by Argo Solucoes on 22/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

protocol LibraryCellDelegate:class {
    func favorite()
}

enum LibraryCellType {
    case areas, acervos, bibliotecas, favorited, none
}

class LibraryCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    private var id: Int?
    weak var delegate: LibraryCellDelegate?
    
    override func awakeFromNib() {
        
    }
    
}

