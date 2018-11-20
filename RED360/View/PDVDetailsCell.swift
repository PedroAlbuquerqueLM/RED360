//
//  PDVDetailsCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class PDVDetailsCell: UITableViewCell {
    
    @IBOutlet weak var pdvLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var canalLabel: UILabel!
    @IBOutlet weak var diretoriaLabel: UILabel!
    @IBOutlet weak var gerenciaLabel: UILabel!
    @IBOutlet weak var supervisaoLabel: UILabel!
    @IBOutlet weak var rotaLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        
    }
    
    var pdv: PDVModel? {
        didSet{
            guard let pdv = self.pdv else {return}
            self.pdvLabel.text = pdv.pdv
            self.nameLabel.text = pdv.nome
            self.canalLabel.text = pdv.canal
            self.diretoriaLabel.text = pdv.diretoria
            self.gerenciaLabel.text = pdv.gerencia
            self.supervisaoLabel.text = pdv.supervisao
            self.rotaLabel.text = pdv.rotaVendedor
            self.enderecoLabel.text = "\(pdv.rua ?? "")"
        }
    }
    
}
