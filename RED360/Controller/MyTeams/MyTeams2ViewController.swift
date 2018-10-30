//
//  MyTeams2ViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class MyTeams2ViewController: UIViewController {
    
    let menuItens = [(title: "Regionais", nivel: [0, 13], subItens: ["Regional 1", "Regional 2"]), (title: "Diretores", nivel: [0, 13], subItens: ["Dir. AL/SE", "Dir. BA", "Dir. CE", "Dir. MA", "Dir. MT", "Dir. PE", "Dir. PI", "Dir. RN/PB"]), (title: "Gerentes", nivel: [0, 1, 13], subItens: ["GER AS - CE", "GER AS - MA", "GER AS - MT", "GER AS - PE", "GER AS - PI", "GER AS - SE", "GER AS - SSA", "Dir. RN/PB"]), (title: "Supervisores", nivel: [0, 1, 2, 13], subItens: ["Regional 1", "Regional 2"]), (title: "Rotas Vendedores", nivel: [0, 1, 2, 3, 13], subItens: ["Regional 1", "Regional 2"])]
    
    var menuShow = [String]()
    
    var userNivel: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "Meu Time"
        
        guard let nivel = appDelegate.user?.nivel else {return}
        menuItens.forEach{
            if $0.nivel.contains(nivel) {
                self.menuShow.append($0.title)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MyTeams2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        cell.textLabel?.text = menuShow[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
