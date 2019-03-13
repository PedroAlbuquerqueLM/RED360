//
//  RedSimuladoCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 28/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class REDSimuladoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pontos: UILabel!
    @IBOutlet weak var pontua: UISwitch!
    var superViewController: REDSimuladoViewController!
    
    var pdv: REDSimuladoModel? {
        didSet{
            guard let redS = pdv else {return}
            self.titleLabel.text = redS.pergunta
            self.pontos.text = "Pontos: \(redS.pontosPossiveis ?? "-")"
            self.pontua.setOn((redS.pontua ?? false), animated: false)
        }
    }
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func pontuaSwitchAction(_ sender: Any) {
        self.pdv?.pontua = self.pontua.isOn
        superViewController.loadValues()
    }
}
