//
//  PDVListCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 20/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class PDVListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pdvLabel: UILabel!
    @IBOutlet weak var notaRedLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}
