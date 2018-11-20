//
//  SearchViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class PDVViewController: SlideViewController {
    
    @IBOutlet weak var searchText: UITextField!
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Pesquisa por código PDV")
    }
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
        Rest.searchPDV(pdv: self.searchText.text!) { (pdv, accessDenied) in
            guard let pdv = pdv else {return}
            Rest.searchPDVOportunities(pdv: pdv.pdv!, onComplete: { (oportunities, accessDenied) in
                guard let oportunities = oportunities else {return}
                if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardPDVViewController") as? DashboardPDVViewController {
                    vc.pdv = pdv
                    vc.oportunities = oportunities
                    if let vl = self.vLoading{ vl.removeFromSuperview() }
                    self.present(vc, animated: true, completion: nil)
                }
            })
        }
    }
}
