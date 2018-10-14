//
//  RankedCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class RankedCell: UITableViewCell {
    
    @IBOutlet weak var notaRed: UILabel!
    @IBOutlet weak var variable: UILabel!
    @IBOutlet weak var meta: UILabel!
    @IBOutlet weak var rank: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
}
