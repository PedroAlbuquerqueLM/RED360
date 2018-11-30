//
//  REDSimuladoViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 27/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import CoreLocation

class REDSimuladoViewController: SlideViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dashTableView: UITableView!
    
    var pdv: PDVModel!
    var redSimulado: [REDSimuladoModel]?
    var redSimuladoFiltered: [REDSimuladoModel]?
    var selectedPDVType = PDVType.ativacao
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var observacao = ""
    
    enum PDVType: String {
        case ativacao = "ATIVAÇÃO"
        case disponibilidade = "DISPONIBILIDADE"
        case gdm = "GDM"
        case preco = "PREÇO"
        case sovi = "SOVI"
    }
    
    @IBOutlet weak var tabBarTypes: UITabBar!
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("RED Simulado")
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        let checkItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkIcon"), style: .done, target: nil, action: #selector(checkAction))
        let observationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "observationIcon"), style: .done, target: nil, action: #selector(observationAction))
        doneItem.tintColor = UIColor.white
        checkItem.tintColor = UIColor.white
        observationItem.tintColor = UIColor.white
        self.navItem?.leftBarButtonItem = doneItem;
        self.navItem?.rightBarButtonItems = [checkItem, observationItem]
        
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
        self.tabBarTypes.selectedItem = tabBarTypes.items![0]
        
        guard let pdv = pdv else {return}
        Rest.getREDSimulado(uf: pdv.uf!, canal: pdv.canal!, curva: pdv.curva!) { (redSimulado, accessDenied) in
            if let vl = self.vLoading{ vl.removeFromSuperview() }
            self.redSimulado = redSimulado
            self.changePDVType(pdvType: .ativacao)
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    func changePDVType(pdvType: PDVType) {
        self.selectedPDVType = pdvType
        self.redSimuladoFiltered = self.redSimulado?.filter{$0.kpi! == pdvType.rawValue}
        self.loadValues()
        self.dashTableView.reloadData()
    }
    
    func loadValues(){
        let pdvType = self.selectedPDVType
        let values = getValues(pdvType: pdvType)
        
        self.totalLabel.text = "Total: \(String(format: "%.1f", values.pontuaTotal!*100/values.pontosTotais!))%"
        
        self.subtitleLabel.text = "\(pdvType.rawValue): \(String(format: "%.1f", values.pontua!*100/values.pontos!))%"
    }
    
    func getValues(pdvType: PDVType) -> (pontosTotais: Double?, pontos: Double?, pontuaTotal: Double?, pontua: Double?) {
        let pontosTotais = self.redSimulado?.compactMap{Double($0.pontosPossiveis!)}.reduce(0, +)
        let pontos = self.redSimulado?.filter{$0.kpi! == pdvType.rawValue}.compactMap{Double($0.pontosPossiveis!)}.reduce(0, +)
        let pontuaTotal = self.redSimulado?.filter{$0.pontua! == true}.compactMap{Double($0.pontosPossiveis!)}.reduce(0, +)
        let pontua = self.redSimulado?.filter{$0.kpi! == pdvType.rawValue}.filter{$0.pontua! == true}.compactMap{Double($0.pontosPossiveis!)}.reduce(0, +)
        
        return (pontosTotais: pontosTotais, pontos: pontos, pontuaTotal: pontuaTotal, pontua: pontua)
    }
    
    @objc func checkAction() {
        let pesquisaSimulada = PesquisaSimuladaModel(
                        pdv: self.pdv.pdv,
                        location: self.location,
                        ativacao: observacao,
                        percentualAtivacao: String(format: "%.1f", getValues(pdvType: .ativacao).pontua!*100/getValues(pdvType: .ativacao).pontos!),
                        percentualDisponibilidade: String(format: "%.1f", getValues(pdvType: .disponibilidade).pontua!*100/getValues(pdvType: .disponibilidade).pontos!),
                        percentualGdm: String(format: "%.1f", getValues(pdvType: .gdm).pontua!*100/getValues(pdvType: .gdm).pontos!),
                        percentualPreco: String(format: "%.1f", getValues(pdvType: .preco).pontua!*100/getValues(pdvType: .preco).pontos!),
                        percentualSovi: String(format: "%.1f", getValues(pdvType: .sovi).pontua!*100/getValues(pdvType: .sovi).pontos!),
                        percentualTotal: String(format: "%.1f", getValues(pdvType: .ativacao).pontuaTotal!*100/getValues(pdvType: .ativacao).pontosTotais!)
        )
        
        let p = redSimulado?.compactMap{$0.pergunta}
        
        let perguntas = [PerguntaModel]()
        
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "REDFormViewController") as? REDFormViewController {
            vc.pesquisaSimulada = pesquisaSimulada
            vc.perguntas = perguntas
            vc.modalPresentationStyle = .overCurrentContext
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

    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension REDSimuladoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let redSimuladoFiltered = self.redSimuladoFiltered else {return 0}
        return redSimuladoFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "REDSimuladoCell", for: indexPath) as! REDSimuladoCell
        if let redS = self.redSimuladoFiltered?[indexPath.row] {
            cell.pdv = redS
            cell.superViewController = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension REDSimuladoViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var isSelected = PDVType.ativacao
        switch item.tag {
        case 1: isSelected = .disponibilidade
        case 2: isSelected = .gdm
        case 3: isSelected = .preco
        case 4: isSelected = .sovi
        default: isSelected = .ativacao
        }
        
        self.changePDVType(pdvType: isSelected)

    }
}

extension REDSimuladoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location!.coordinate
    }
}

