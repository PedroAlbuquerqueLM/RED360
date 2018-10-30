//
//  MenuViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    let menuItens = [(title: "Meu Resultado", key: "DashboardViewController"), (title: "Meu Time", key: "MyTeamsViewController"), (title: "Pesquisar", key: "SearchViewController"), (title: "Sair", key: "LoginViewController")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = appDelegate.user?.nome
        self.subtitleLabel.text = appDelegate.user?.diretoria
        
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.title.text = menuItens[indexPath.row].title
        cell.icon.image = UIImage(named: "\(menuItens[indexPath.row].key)Icon")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.visibleCells[indexPath.row].isSelected = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: menuItens[indexPath.row].key)
        
        if menuItens[indexPath.row].key == "LoginViewController" {
            self.logout()
        }else{
            appDelegate.slideMenuController?.changeMainViewController(viewController, close: true)
        }
    }
    
    private func logout(){
        UserModel.signOut()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withClass: LoginViewController.self)
        ControllerManager.sharedInstance.setupRootViewController(withClass: LoginViewController.self, viewController: viewController, typeTransition: .showHideTransitionViews)
    }
    
    
}
