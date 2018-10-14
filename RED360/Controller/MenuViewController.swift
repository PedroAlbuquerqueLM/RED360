//
//  MenuViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    let menuItens = [(title: "Dashboard", key: "DashboardViewController"), (title: "Pesquisar", key: "SearchViewController"), (title: "Sair", key: "LoginViewController")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuItens[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.visibleCells[indexPath.row].isSelected = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: menuItens[indexPath.row].key)
        
        appDelegate.slideMenuController?.changeMainViewController(viewController, close: true)
    }
    
    
}
