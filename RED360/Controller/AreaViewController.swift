//
//  AreaViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 20/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Firebase

class AreaViewController: SlideViewController {
    
    @IBOutlet weak var areaTableView: UITableView!
    
    var itens: [ListPDVModel]?
    var pdvs : [ListPDVSModel]?
    
    var undoItem: UIBarButtonItem!
    var areaSelected = AreaType.uf
    var isListNota = false
    var isListOport = false
    
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    enum AreaType: String {
        case uf = "estado", city = "municipio", bairro = "bairro", pdv = "pdv"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isListNota{
            self.setTitle("10 maiores notas")
        }else if isListOport{
            self.setTitle("10 maiores oportunidades")
        }else{
            self.setTitle("Selecione um \(self.areaSelected.rawValue)")
        }
        
        self.undoItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backIcon"), style: .plain, target: nil, action: #selector(undoAction))
        undoItem.tintColor = UIColor.white
        
        self.loading()
        if isListNota {
            Rest.listTop(isNota: true) { (pdvs, accessDenied) in
                self.pdvs = pdvs
                self.areaTableView.reloadData()
            }
        }else if isListOport {
            Rest.listTop(isNota: false) { (pdvs, accessDenied) in
                self.pdvs = pdvs
                self.areaTableView.reloadData()
            }
        }else{
            Rest.listUF { (uf, accessDenied) in
                self.itens = uf
                self.areaTableView.reloadData()
            }
        }
    }
    
    @objc func undoAction() {
        guard let itens = itens else {return}
        switch self.areaSelected {
        case .city:
            self.loading()
            self.navItem?.leftBarButtonItem = self.menuItem;
            Rest.listUF { (uf, accessDenied) in
                self.areaSelected = .uf
                self.setTitle("Selecione um \(self.areaSelected.rawValue)")
                self.itens = uf
                self.areaTableView.reloadData()
            }
        case .bairro:
            self.loading()
            Rest.listCity(uf: itens.first!.uf!) { (cities, accessDenied) in
                self.areaSelected = .city
                self.setTitle("Selecione um \(self.areaSelected.rawValue)")
                self.itens = cities
                self.areaTableView.reloadData()
            }
        case .pdv:
            self.loading()
            Rest.listBairro(uf: itens.first!.uf!, cidade: itens.first!.municipio!) { (bairros, accessDenied) in
                self.areaSelected = .bairro
                self.setTitle("Selecione um \(self.areaSelected.rawValue)")
                self.itens = bairros
                self.areaTableView.reloadData()
            }
        case .uf: return
        }
    }
    
    func loading(){
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
    }
    
    func stopLoading(){
        if let vl = self.vLoading{ vl.removeFromSuperview() }
    }
}

extension AreaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.stopLoading()
        if self.areaSelected != .pdv {
            guard let itens = itens else {return 0}
            return itens.count
        }
        
        guard let pdvs = pdvs else {return 0}
        return pdvs.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.areaSelected == .pdv {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVListCell", for: indexPath) as! PDVListCell
            guard let pdvs = pdvs else {return cell}
            cell.titleLabel.text = pdvs[indexPath.row].nome
            cell.addressLabel.text = pdvs[indexPath.row].endereco
            cell.pdvLabel.text = pdvs[indexPath.row].pdv
            cell.notaRedLabel.text = "\(pdvs[indexPath.row].notaRed?.toVirgula ?? "-")%"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            guard let itens = itens else {return cell}
            switch self.areaSelected {
            case .uf: cell.textLabel?.text = itens[indexPath.row].uf
            case .city: cell.textLabel?.text = itens[indexPath.row].municipio
            case .bairro: cell.textLabel?.text = itens[indexPath.row].bairro
            default: return cell
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.areaSelected {
        case .uf:
            guard let itens = itens else {return}
            self.loading()
            Rest.listCity(uf: itens[indexPath.row].uf!) { (cities, accessDenied) in
                self.navItem?.leftBarButtonItem = self.undoItem;
                self.areaSelected = .city
                self.setTitle("Selecione um \(self.areaSelected.rawValue)")
                self.itens = cities
                self.areaTableView.reloadData()
            }
        case .city:
            guard let itens = itens else {return}
            self.loading()
            Rest.listBairro(uf: itens[indexPath.row].uf!, cidade: itens[indexPath.row].municipio!) { (bairros, accessDenied) in
                self.navItem?.leftBarButtonItem = self.undoItem;
                self.areaSelected = .bairro
                self.setTitle("Selecione um \(self.areaSelected.rawValue)")
                self.itens = bairros
                self.areaTableView.reloadData()
            }
        case .bairro:
            guard let itens = itens else {return}
            self.loading()
            Rest.listPDVS(city: itens[indexPath.row].municipio!, bairro: itens[indexPath.row].bairro!) { (pdvs) in
                self.navItem?.leftBarButtonItem = self.undoItem;
                self.areaSelected = .pdv
                self.setTitle("Selecione um \(self.areaSelected.rawValue)")
                self.pdvs = pdvs
                self.areaTableView.reloadData()
            }
        case .pdv:
            guard let pdv = self.pdvs?[indexPath.row] else {return}
            self.loading()
            Rest.searchPDV(pdv: pdv.pdv ?? "") { (pdv, accessDenied) in
                guard let pdv = pdv else {
                    [Int]().emptyAlert("PDV não cadastrado.", self);
                    if let vl = self.vLoading{ vl.removeFromSuperview() }
                    return
                }
                Rest.searchPDVOportunities(pdv: pdv.pdv!, onComplete: { (oportunities, accessDenied) in
                    guard let oportunities = oportunities else {return}
                    Rest.listRotines(pdv: pdv.pdv!, onComplete: { (rotines, accessDenied) in
                        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardPDVViewController") as? DashboardPDVViewController {
                            vc.titleTop = "Pesquisa por Área"
                            vc.pdv = pdv
                            vc.oportunities = oportunities
                            vc.rotines = rotines
                            if let vl = self.vLoading{ vl.removeFromSuperview() }
                            self.present(vc, animated: true, completion: nil)
                        }
                    })
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.areaSelected == .pdv {
            return 130
        }
        return 50
    }
    
}

