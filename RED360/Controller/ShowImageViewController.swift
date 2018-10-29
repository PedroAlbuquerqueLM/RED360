//
//  ShowImageViewController.swift
//  Motivi
//
//  Created by Pedro Albuquerque on 16/10/18.
//  Copyright © 2018 Argo Soluções. All rights reserved.
//

import UIKit
import SnapKit

class ShowImageViewController: UIViewController {
    
    var notasPilar: [NotaPilarModel]?
    var values: (line: [Double], bar: [Double])?
    var isCombinated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isCombinated {
            let view = ChartsLandscapeView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
            view.notaPilar = notasPilar
            self.view.insertSubview(view, at: 0)
        }else{
            let view = CombinatedChartsLandscapeView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
            
            view.values = self.values
            
            self.view.insertSubview(view, at: 0)
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
