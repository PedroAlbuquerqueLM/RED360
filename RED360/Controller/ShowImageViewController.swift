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
    var date: String?
    var values: (line: [Double], bar: [Double])?
    var isCombinated: Bool = false
    @IBOutlet weak var subtitleGreenView: UIView!
    @IBOutlet weak var subtitleGreenLabel: UILabel!
    @IBOutlet weak var subtitleGrayLabel: UILabel!
    
    
    @IBOutlet weak var viewSubTitle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isCombinated {
            let view = ChartsLandscapeView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)), qnt: 1)
            view.notaPilar = notasPilar
            self.subtitleGreenView.backgroundColor = #colorLiteral(red: 0.07754790038, green: 0.692034781, blue: 0.3123155236, alpha: 1)
            self.subtitleGreenLabel.text = self.date
            self.subtitleGrayLabel.text = "Mês Anterior"
            self.view.insertSubview(view, at: 0)
        }else{
            let view = ChartsLandscapeView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)), qnt: 2)
            view.values = self.values
            self.subtitleGreenView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
            self.subtitleGreenLabel.text = "Nota RED"
            self.subtitleGrayLabel.text = "Meta"
            self.view.insertSubview(view, at: 0)
        }
        viewSubTitle.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        viewSubTitle.snp.makeConstraints { (make) in
            make.trailing.equalTo(120)
            make.top.equalTo(230)
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
