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
    var pdvs : [ListPDVSModel]?
    
    var undoItem: UIBarButtonItem!
    var areaSelected = AreaType.route
    var gerenteSelectedId: Int?
    
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    enum AreaType: String {
        case route = "route", gerente = "gerente", pdv = "pdv"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Minha Rota")
        
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
            Rest.listGerentes(rotinaId: self.gerenteSelectedId) { (gerentes, accessDenied) in
                self.areaSelected = .gerente
                self.gerentes = gerentes
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
            cell.titleLabel.text = pdvs[indexPath.row].nome
            cell.addressLabel.text = pdvs[indexPath.row].endereco
            cell.pdvLabel.text = pdvs[indexPath.row].pdv
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
            guard let routes = routes else {return}
            self.loading()
            let selectedRoute = routes[indexPath.row]
            self.gerenteSelectedId = selectedRoute.id
            Rest.listGerentes(rotinaId: self.gerenteSelectedId) { (gerentes, accessDenied) in
                self.navItem?.leftBarButtonItem = self.undoItem;
                self.areaSelected = .gerente
                self.gerentes = gerentes
                self.areaTableView.reloadData()
            }
        case .gerente:
            guard let gerente = gerentes else {return}
            self.loading()
//            Rest.listPDVS(city: itens[indexPath.row].municipio!, bairro: itens[indexPath.row].bairro!) { (pdvs) in
//                self.navItem?.leftBarButtonItem = self.undoItem;
//                self.areaSelected = .pdv
//                self.setTitle("Selecione um \(self.areaSelected.rawValue)")
//                self.pdvs = pdvs
//                self.areaTableView.reloadData()
//            }
        case .pdv:
            guard let pdv = self.pdvs?[indexPath.row].pdv else {return}
            self.loading()
            Rest.searchPDV(pdv: pdv) { (pdv, accessDenied) in
                guard let pdv = pdv else {
                    [Int]().emptyAlert("PDV não cadastrado.", self);
                    if let vl = self.vLoading{ vl.removeFromSuperview() }
                    return
                }
                Rest.searchPDVOportunities(pdv: pdv.pdv!, onComplete: { (oportunities, accessDenied) in
                    guard let oportunities = oportunities else {return}
                    if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardPDVViewController") as? DashboardPDVViewController {
                        vc.titleTop = "Pesquisa por Área"
                        vc.pdv = pdv
                        vc.oportunities = oportunities
                        if let vl = self.vLoading{ vl.removeFromSuperview() }
                        self.present(vc, animated: true, completion: nil)
                    }
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

