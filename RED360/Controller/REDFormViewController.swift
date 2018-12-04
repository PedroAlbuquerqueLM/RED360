//
//  REDFormViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

protocol REDFormDelegate: class {
    func resignView()
}

class REDFormViewController: UIViewController {
    
    @IBOutlet weak var resumoLabel: UITextView!
    @IBOutlet weak var obsLabel: UITextView!
    
    var pesquisaSimulada: PesquisaSimuladaModel?
    var perguntas: [PerguntaModel]?
    
    weak var delegate: REDFormDelegate?
    
    override func viewDidLoad() {
        self.resumoLabel.text = "Ativação: \(pesquisaSimulada?.percentualAtivacao ?? "")%, Disponibilidade: \(pesquisaSimulada?.percentualDisponibilidade ?? "")%, Gdm: \(pesquisaSimulada?.percentualGdm ?? "")%, Preço: \(pesquisaSimulada?.percentualPreco ?? "")%, Sovi: \(pesquisaSimulada?.percentualSovi ?? "")%, Total: \(pesquisaSimulada?.percentualTotal ?? "")%"
        
        self.obsLabel.text = pesquisaSimulada?.ativacao
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let pesquisaSimulada = self.pesquisaSimulada, let perguntas = self.perguntas else {return}
        
        Rest.saveSaveREDSimulado(pesquisaSimulada: pesquisaSimulada, perguntas: perguntas) { _,_  in
            
            self.delegate?.resignView()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

