//
//  MyRouteViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/01/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Firebase

class MyRouteViewController: SlideViewController {
    
    @IBOutlet weak var areaTableView: UITableView!
    
    var routes: [ListRouteModel]?
    var gerentes: [ListGerentesModel]?
    var pdvs : [PDVModel]?
    
    var undoItem: UIBarButtonItem!
    var areaSelected = AreaType.route
    var routeIdSelected: Int?
    
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    enum AreaType: String {
        case route = "route", gerente = "gerente", pdv = "pdv"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Minha Rotina")
        
        self.undoItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backIcon"), style: .plain, target: nil, action: #selector(undoAction))
        undoItem.tintColor = UIColor.white
        
        self.loading()
        Rest.listRoutes(onComplete: { (routes, accessDenied) in
            self.routes = routes
            self.areaTableView.reloadData()
        })
    }
    
    @objc func undoAction() {
        switch self.areaSelected {
        case .gerente:
            self.loading()
            self.navItem?.leftBarButtonItem = self.menuItem;
            self.areaSelected = .route
            self.areaTableView.reloadData()
        case .pdv:
            self.loading()
            guard let user = appDelegate.user else {return}
            if user.cargoLideranca ?? false {
                Rest.listGerentes(rotinaId: self.routeIdSelected) { (gerentes, accessDenied) in
                    self.setTitle("Minha Rotina")
                    self.areaSelected = .gerente
                    self.gerentes = gerentes
                    self.areaTableView.reloadData()
                }
            }else{
                self.navItem?.leftBarButtonItem = self.menuItem;
                self.areaSelected = .route
                self.areaTableView.reloadData()
            }
        case .route: return
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
    
    func orderPDVs(){
        var pdvs = [PDVModel]()
        let actives = self.pdvs?.filter{$0.respondida == nil || $0.respondida == false}
        let inactives = self.pdvs?.filter{$0.respondida == true}
        actives?.forEach{pdvs.append($0)}
        inactives?.forEach{pdvs.append($0)}
        self.pdvs = pdvs
    }
    
    func orderRotines(_ rotines: [RotinesModel]?) -> [RotinesModel]?{
        guard let rotines = rotines else {return nil}
        var rotinesNew = [RotinesModel]()
        let actives = rotines.filter{$0.respondida == nil || $0.respondida == false}
        let inactives = rotines.filter{$0.respondida == true}
        actives.forEach{rotinesNew.append($0)}
        inactives.forEach{rotinesNew.append($0)}
        return rotinesNew
    }
}

extension MyRouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.stopLoading()
        switch self.areaSelected {
        case .route:
            guard let routes = routes else {return 0}
            return routes.count
        case .gerente:
            guard let gerentes = gerentes else {return 0}
            return gerentes.count
        default:
            guard let pdvs = pdvs else {return 0}
            return pdvs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.areaSelected == .pdv {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVListCell", for: indexPath) as! PDVListCell
            guard let pdvs = pdvs else {return cell}
            let pdv = pdvs[indexPath.row]
            cell.titleLabel.text = pdv.nome
            cell.addressLabel.text = "\(pdv.rua ?? "") \(pdv.bairro ?? "") - \(pdv.municipio ?? "") \(pdv.uf ?? "") - \(pdv.cep ?? "")"
            cell.pdvLabel.text = pdv.pdv
            
            if pdv.respondida == true {
                cell.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6864271567)
                cell.isUserInteractionEnabled = false
            }else{
                cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.isUserInteractionEnabled = true
            }
            
            return cell
        }else if self.areaSelected == .route {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RouteListCell", for: indexPath) as! RouteListCell
            guard let routes = routes else {return cell}
            cell.titleLabel.text = routes[indexPath.row].rotina?.uppercased()
            cell.dateLabel.text = "Até \(routes[indexPath.row].ate ?? " - ")"
            cell.pdvLabel.text = "\(routes[indexPath.row].qtdePdvPendente ?? 0) PDV"
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        guard let gerentes = gerentes else {return cell}
        switch self.areaSelected {
        case .gerente: cell.textLabel?.text = gerentes[indexPath.row].rota?.uppercased()
        default: return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.areaSelected {
        case .route:
            guard let user = appDelegate.user else {return}
            guard let routes = routes else {return}
            self.loading()
            let selectedRoute = routes[indexPath.row]
            if user.cargoLideranca ?? false {
                self.routeIdSelected = selectedRoute.id
                Rest.listGerentes(rotinaId: self.routeIdSelected) { (gerentes, accessDenied) in
                    self.navItem?.leftBarButtonItem = self.undoItem;
                    self.areaSelected = .gerente
                    self.gerentes = gerentes
                    self.areaTableView.reloadData()
                }
            }else{
                self.routeIdSelected = selectedRoute.id
                Rest.listRoutesPDV(rotinaId: self.routeIdSelected) { (pdvs, accessDenied) in
                    self.navItem?.leftBarButtonItem = self.undoItem;
                    self.areaSelected = .pdv
                    self.pdvs = pdvs
                    self.orderPDVs()
                    self.areaTableView.reloadData()
                }
            }
        case .gerente:
            guard let gerentes = gerentes else {return}
            self.loading()
            let gerente = gerentes[indexPath.row]
            self.setTitle(gerente.rota ?? "Minha Rotina")
            Rest.listRoutesStructPDV(rotinaId: self.routeIdSelected, rota: gerente.rota) { (pdvs, accessDenied) in
                self.navItem?.leftBarButtonItem = self.undoItem;
                self.areaSelected = .pdv
                self.pdvs = pdvs
                self.orderPDVs()
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
                            vc.titleTop = self.getTitle()
                            vc.pdv = pdv
                            vc.oportunities = oportunities
                            vc.rotines = self.orderRotines(rotines)
                            if let vl = self.vLoading{ vl.removeFromSuperview() }
                            self.present(vc, animated: true, completion: nil)
                        }
                    })
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.areaSelected == .pdv { return 97 }
        if self.areaSelected == .route { return UITableViewAutomaticDimension }
        return 50
    }
    
}

