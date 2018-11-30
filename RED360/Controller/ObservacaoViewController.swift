//
//  ObservacaoViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class ObservacaoViewController: UIViewController {
    
    @IBOutlet weak var obsText: UITextView!
    
    var observacao = ""
    
    override func viewDidLoad() {
        self.obsText.text = observacao
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obsText.becomeFirstResponder()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if let presenter = presentingViewController as? REDSimuladoViewController {
            presenter.observacao = obsText.text
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
