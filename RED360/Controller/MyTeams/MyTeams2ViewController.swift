//
//  MyTeams2ViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class MyTeams2ViewController: SlideViewController {
    
    @IBOutlet weak var tableMenu: UITableView!
    var selectedTime = ""    
    var menuShow: [MyTeamsModel]?
    var userNivel: Int?
    
    var regionais = ["Regional 1", "Regional 2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Meu Time")
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        doneItem.tintColor = UIColor.white
        
        self.navItem?.leftBarButtonItem = doneItem;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        if !(self.selectedTime == "Regionais") {
            Rest.loadMeuTime(cargoTime: self.selectedTime) { (myTeams, accessDenied) in
                self.menuShow = myTeams
                self.tableMenu.reloadData()
            }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MyTeams2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedTime == "Regionais"{
            return self.regionais.count
        }
        
        guard let menuShow = self.menuShow else {return 0}
        return menuShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        switch self.selectedTime {
        case "Regionais":
            cell.textLabel?.text = self.regionais[indexPath.row]
        case "Diretores":
            guard let time = self.menuShow?[indexPath.row] else {return cell}
            cell.textLabel?.text = time.diretoria
        case "Gerentes":
            guard let time = self.menuShow?[indexPath.row] else {return cell}
            cell.textLabel?.text = time.gerencia
        case "Supervisores":
            guard let time = self.menuShow?[indexPath.row] else {return cell}
            cell.textLabel?.text = time.supervisao
        case "Rotas Vendedores":
            guard let time = self.menuShow?[indexPath.row] else {return cell}
            cell.textLabel?.text = time.rotaVendedor
        default:
            cell.textLabel?.text = "-"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            if !(self.selectedTime == "Regionais") {
                guard let time = self.menuShow?[indexPath.row], let cpf = time.cpf else {return}
                var user = UserModel(team: time)
                UserModel.getMetas(cpf: cpf, completion: { (metas) in
                    user.metas = metas
                    vc.user = user
                    self.present(vc, animated: true, completion: nil)
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}