//
//  PDVDetailsCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Firebase

class PDVDetailsCell: UITableViewCell {
    
    @IBOutlet weak var pdvLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var canalLabel: UILabel!
    @IBOutlet weak var diretoriaLabel: UILabel!
    @IBOutlet weak var gerenciaLabel: UILabel!
    @IBOutlet weak var supervisaoLabel: UILabel!
    @IBOutlet weak var rotaLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    var superViewController: DashboardPDVViewController!
    
    override func awakeFromNib() {
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    @IBAction func mapButtonAction(_ sender: Any) {
        guard let pdv = pdv else{return}
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            let la = "\(pdv.latitude ?? 0)"
            let ln = "\(pdv.longitude ?? 0)"
            
            guard let latitude = Double(la), let longitude = Double(ln) else {return}
            let vLong = (longitude > -100 && longitude < 0) || (longitude < 100 && longitude > 0)
            let vLat = (latitude > -100 && latitude < 0) || (latitude < 100 && latitude > 0)
            vc.location = GeoPoint(latitude: vLat ? (latitude == 0 ? -3.7541127 : latitude) : -3.7541127, longitude: vLong ? (longitude == 0 ? -38.4906188 : longitude) : -38.4906188)
            superViewController.present(vc, animated: true, completion: nil)
        }
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
            self.enderecoLabel.text = "\(pdv.rua ?? "") \(pdv.bairro ?? "") - \(pdv.municipio ?? "") \(pdv.uf ?? "") - \(pdv.cep ?? "")"
        }
    }
    
}
