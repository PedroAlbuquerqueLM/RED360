//
//  MyTeams2ViewController.swift
//  RED360
//
//  Created by Argo Solucoes on 29/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class MyTeams2ViewController: SlideViewController {
    
    @IBOutlet weak var tableMenu: UITableView!
    var selectedTime = ""    
    var menuShow: [MyTeamsModel]?
    var userNivel: Int?
    
    var regionais = ["Regional 1", "Regional 2"]
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Meu Time")
        guard let nivel = appDelegate.user?.nivel else {return}
//        if nivel != 0 && nivel != 13 {
            let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
            doneItem.tintColor = UIColor.white
        
            self.navItem?.leftBarButtonItem = doneItem;
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent

            if let vl = vLoading{
                vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                vl.aiLoading.startAnimating()
                view.addSubview(vl)
            }
            Rest.loadMeuTime(cargoTime: self.selectedTime) { (myTeams, accessDenied) in
                if let vl = self.vLoading{ vl.removeFromSuperview() }
                self.menuShow = myTeams
                myTeams?.emptyAlert("Nenhum time encontrado", self)
                self.tableMenu.reloadData()
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
        
        guard let menuShow = self.menuShow else {return 0}
        return menuShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTeamsCell", for: indexPath) as! MyTeamsCell
        guard let time = self.menuShow?[indexPath.row] else {return cell}
        cell.myTeams = time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            if !(self.selectedTime == "Regionais") {
                guard let time = self.menuShow?[indexPath.row], let cpf = time.cpf else {return}
                var user = UserModel(team: time)
//                UserModel.getMetas(cpf: cpf, completion: { (metas) in
//                    user.metas = metas
                    user.cpf = cpf
                    user.nome = user.cargo
                    vc.user = user
                    self.present(vc, animated: true, completion: nil)
//                })
            }else{
                let regional = self.regionais[indexPath.row]
                var user = UserModel(cpf: "11111111111", nivel: 11, nome: "Regional 1")
                if regional == "Regional 2" {
                    user = UserModel(cpf: "22222222222", nivel: 12, nome: "Regional 2")
                }
                
//                UserModel.getMetas(cpf: user.cpf!, completion: { (metas) in
//                    user.metas = metas
                    vc.user = user
                    self.present(vc, animated: true, completion: nil)
//                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
