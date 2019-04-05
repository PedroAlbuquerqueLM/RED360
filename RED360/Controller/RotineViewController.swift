//
//  RotineViewController.swift
//  RED360
//
//  Created by Argo Solucoes on 31/01/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import CoreLocation

protocol RotineViewControllerDelegate:class {
    func resignView()
}

class RotineViewController: SlideViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dashTableView: UITableView!
    
    weak var delegate: RotineViewControllerDelegate?
    
    var titleQuizz: String?
    var rotine: RotinesModel?
    var pdv: String?
    var quizz: [QuizzModel]!
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var observacao = ""
    
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Rotina")
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        let checkItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkIcon"), style: .done, target: nil, action: #selector(checkAction))
        let observationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "observationIcon"), style: .done, target: nil, action: #selector(observationAction))
        doneItem.tintColor = UIColor.white
        checkItem.tintColor = UIColor.white
        observationItem.tintColor = UIColor.white
        self.navItem?.leftBarButtonItem = doneItem;
        self.navItem?.rightBarButtonItems = [checkItem, observationItem]
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.titleLabel.text = titleQuizz
    }
    
    @objc func checkAction() {
        guard let quizz = self.quizz else {return}
        quizz.forEach{
            $0.perguntas?.forEach{
                if $0.respostaId < 0{
                    alertEmpty(message: "Por gentileza, marque todas as respostas", dismiss: false)
                    return
                }
            }
        }
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "REDFormViewController") as? REDFormViewController {
            vc.quizz = self.quizz
            vc.rotine = self.rotine
            vc.pdv = self.pdv
            vc.obs = self.observacao
            vc.location = self.location
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func observationAction() {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ObservacaoViewController") as? ObservacaoViewController {
            vc.observacao = self.observacao
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func alertEmpty(message: String = "Sem dados para simular.", dismiss: Bool = true){
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            if dismiss{
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func closeAction() {
        // Create the alert controller
        let alertController = UIAlertController(title: "Todos os Registros serão perdidos, você deseja realmente sair?", message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Sair", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension RotineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizz[section].perguntas?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.quizz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RotineQuestionCell", for: indexPath) as! RotineQuestionCell
        cell.superViewController = self
        cell.alternativesTableView.isScrollEnabled = false
        cell.answer = self.quizz[indexPath.section].perguntas?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let quizz = self.quizz[indexPath.section].perguntas?[indexPath.row], let pergunta = quizz.pergunta, let resps = quizz.respostas else {return 0}
        var strResps = ""
        resps.forEach{ strResps += ($0.resposta ?? "") }
        var height: CGFloat = 0
        if strResps.qntHeight > resps.count {
            height = CGFloat((strResps.qntHeight + 2) * 20) + CGFloat((resps.count + 2) * 14)
        }else{
            height = CGFloat((resps.count + 2) * 30)
        }
        return CGFloat((pergunta.qntHeightTitle * 18) + 16) + height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        headerView.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9411764706, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.width, height: 50))
        label.text = self.quizz[section].kpi?.uppercased()
        label.textColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        headerView.addSubview(label)
        return headerView
    }
    
}

extension RotineViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location!.coordinate
    }
}

extension RotineViewController: REDFormDelegate {
    func resignView() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) {
            self.rotine?.respondida = true
            self.delegate?.resignView()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
