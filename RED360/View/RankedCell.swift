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
    
    var rankSet: (nota: Double, vari: Double, meta: Double, rank: Int)? {
        didSet{
            guard let rankSet = rankSet else {return}
            self.notaRed.text = "\(String(format: "%.01f", rankSet.nota).replacingOccurrences(of: ".", with: ","))%"
            self.variable.text = "\(String(format: "%.01f", rankSet.vari).replacingOccurrences(of: ".", with: ","))%"
            self.meta.text = "\(String(format: "%.01f", rankSet.meta).replacingOccurrences(of: ".", with: ","))%"
            self.rank.text = "\(rankSet.rank)º"
        }
    }
    
}
