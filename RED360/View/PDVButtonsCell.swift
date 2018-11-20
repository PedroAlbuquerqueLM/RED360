//
//  PDVButtonsCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class PDVButtonsCell: UITableViewCell {
    
    var superViewController: DashboardPDVViewController!
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func pesqCompleteAction(_ sender: UIButton) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDVCompleteViewController") as? PDVCompleteViewController {
            vc.pdv = superViewController.pdv
            superViewController.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func redSimuladoAction(_ sender: UIButton) {
        
    }
    
}
