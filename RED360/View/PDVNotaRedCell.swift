//
//  PDVNotaRedCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class PDVNotaRedCell: UITableViewCell {
    
    @IBOutlet weak var notaRedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    var pdv: PDVModel? {
        didSet{
            guard let pdv = self.pdv else {return}
            self.notaRedLabel.text = "\(pdv.notaRed?.replacingOccurrences(of: ".", with: ",") ?? "-")%"
            self.dateLabel.text = "Pesquisa realizada em \(pdv.dhp ?? "-")"
        }
    }
}
