//
//  MyTeamsViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class MyTeamsViewController: SlideViewController {
    
    let menuItens = [(title: "Regionais", nivel: [0, 13]), (title: "Diretores", nivel: [0, 13]), (title: "Gerentes", nivel: [0, 1, 13]), (title: "Supervisores", nivel: [0, 1, 2, 13]), (title: "Rotas Vendedores", nivel: [0, 1, 2, 3, 13])]
    
    var menuShow = [String]()
    
    var userNivel: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Meu Time")

        guard let nivel = appDelegate.user?.nivel else {return}
        menuItens.forEach{
            if $0.nivel.contains(nivel) {
                self.menuShow.append($0.title)
            }
        }
        
    }
}

extension MyTeamsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        cell.textLabel?.text = menuShow[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTeams2ViewController") as? MyTeams2ViewController {
            vc.selectedTime = menuShow[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
