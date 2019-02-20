//
//  REDFormViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import CoreLocation
import ImagePicker

protocol REDFormDelegate: class {
    func resignView()
}

class REDFormViewController: UIViewController {
    
    @IBOutlet weak var infoTable: UITableView!
    @IBOutlet weak var titleBox: UILabel!
    
    var pesquisaSimulada: PesquisaSimuladaModel?
    var perguntas: [PerguntaModel]?
    
    var quizz: [QuizzModel]?
    var rotine: RotinesModel?
    var pdv: String?
    var location: CLLocationCoordinate2D?
    var obs: String?
    
    var info = [(title: String, info: String)]()
    var images = [UIImage]()
    
    weak var delegate: REDFormDelegate?
    
    override func viewDidLoad() {
        if quizz == nil {
            self.titleBox.text = "Enviar o formulário do RED Simulado?"
            info.append((title: "Resumo", info: "Ativação: \(pesquisaSimulada?.percentualAtivacao ?? "")%, Disponibilidade: \(pesquisaSimulada?.percentualDisponibilidade ?? "")%, Gdm: \(pesquisaSimulada?.percentualGdm ?? "")%, Preço: \(pesquisaSimulada?.percentualPreco ?? "")%, Sovi: \(pesquisaSimulada?.percentualSovi ?? "")%, Total: \(pesquisaSimulada?.percentualTotal ?? "")%"))
            if pesquisaSimulada?.ativacao != ""{
                info.append((title: "Observação", info: pesquisaSimulada?.ativacao ?? "-"))
            }
            
        }else{
            self.titleBox.text = "Enviar o formulário?"
            info.append((title: "Observação", info: "\(self.obs ?? "")"))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if self.quizz == nil {
//            Rest.uploadImagesREDSimulado(images: self.images) {}
            guard let pesquisaSimulada = self.pesquisaSimulada, let perguntas = self.perguntas else {return}
            
            Rest.saveSaveREDSimulado(pesquisaSimulada: pesquisaSimulada, perguntas: perguntas) { _,_  in
                
                self.delegate?.resignView()
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            guard let rotine = self.rotine, let pdv = self.pdv else {return}
            Rest.saveRotine(pdv: pdv, quizzes: self.quizz!, location: self.location!, obs: self.obs!, rotine: rotine) { (_,_) in
                
                self.delegate?.resignView()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imagesAction(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension REDFormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.info.count + (self.images.count > 0 ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.info.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as? GalleryCell else { return GalleryCell() }
            cell.listImages = self.images
            cell.superViewController = self
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath) as? ResponseCell else { return ResponseCell() }
            cell.titleLabel.text = self.info[indexPath.row].title
            cell.detailLabel.text = self.info[indexPath.row].info
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.info.count { return 170 }
        return UITableViewAutomaticDimension
    }
}

extension REDFormViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print(images)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print(images)
        self.images = images
        self.infoTable.reloadData()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
