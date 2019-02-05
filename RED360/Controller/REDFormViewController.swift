//
//  REDFormViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import CoreLocation

protocol REDFormDelegate: class {
    func resignView()
}

class REDFormViewController: UIViewController {
    
    @IBOutlet weak var resumoLabel: UITextView!
    @IBOutlet weak var obsLabel: UITextView!
    @IBOutlet weak var titleBox: UILabel!
    @IBOutlet weak var obsTitle: UILabel!
    @IBOutlet weak var resumoTitle: UILabel!
    
    var pesquisaSimulada: PesquisaSimuladaModel?
    var perguntas: [PerguntaModel]?
    
    var quizz: [QuizzModel]?
    var location: CLLocationCoordinate2D?
    var obs: String?
    
    weak var delegate: REDFormDelegate?
    
    override func viewDidLoad() {
        if quizz == nil {
            self.titleBox.text = "Enviar o formulário do RED Simulado?"
            self.resumoLabel.text = "Ativação: \(pesquisaSimulada?.percentualAtivacao ?? "")%, Disponibilidade: \(pesquisaSimulada?.percentualDisponibilidade ?? "")%, Gdm: \(pesquisaSimulada?.percentualGdm ?? "")%, Preço: \(pesquisaSimulada?.percentualPreco ?? "")%, Sovi: \(pesquisaSimulada?.percentualSovi ?? "")%, Total: \(pesquisaSimulada?.percentualTotal ?? "")%"
            
            self.obsLabel.text = pesquisaSimulada?.ativacao
        }else{
            self.titleBox.text = "Enviar o formulário?"
            self.resumoTitle.text = "Observação"
            self.obsTitle.isHidden = true
            self.resumoLabel.text = "\(self.obs ?? "")"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if self.quizz == nil {
            guard let pesquisaSimulada = self.pesquisaSimulada, let perguntas = self.perguntas else {return}
            
            Rest.saveSaveREDSimulado(pesquisaSimulada: pesquisaSimulada, perguntas: perguntas) { _,_  in
                
                self.delegate?.resignView()
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            Rest.saveRotine(quizzes: self.quizz!, location: self.location!, obs: self.obs!) { (_,_) in
                
                self.delegate?.resignView()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

