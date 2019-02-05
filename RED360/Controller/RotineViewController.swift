//
//  RotineViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 31/01/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import CoreLocation

class RotineViewController: SlideViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dashTableView: UITableView!
    
    var titleQuizz: String?
    var quizz: [QuizzModel]!
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var observacao = ""
    
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle(titleQuizz ?? "")
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
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "REDFormViewController") as? REDFormViewController {
            vc.quizz = self.quizz
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
    
    func alertEmpty(){
        let alertController = UIAlertController(title: "Sem dados para simular.", message: "", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.dismiss(animated: true, completion: nil)
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
        return CGFloat((pergunta.qntHeight * 20) + 16) + CGFloat((resps.count * strResps.qntHeight * 20 + 12))
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
            self.dismiss(animated: true, completion: nil)
        }
    }
}
