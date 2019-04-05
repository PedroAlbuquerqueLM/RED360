//
//  RouteListCell.swift
//  RED360
//
//  Created by Argo Solucoes on 29/01/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class RouteListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pdvLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

class RoutinesListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}
