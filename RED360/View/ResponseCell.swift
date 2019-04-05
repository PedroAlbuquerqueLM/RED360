//
//  ResponseCell.swift
//  RED360
//
//  Created by Argo Solucoes on 17/02/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class ResponseCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}
