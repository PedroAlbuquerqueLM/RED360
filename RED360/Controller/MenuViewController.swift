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
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading

    let menu = [
        (title: "", itens:[(title: "Meu Resultado", key: "DashboardViewController"), (title: "Meu Time", key: "MyTeamsViewController"), (title: "FDS", key: "LibraryViewController")]),
        
        (title: "Pesquisas PDV", itens:[(title: "Por código PDV", key: "PDVViewController"), (title: "Por Área", key: "AreaViewController"), (title: "10 Maiores notas", key: "ListNotaViewController"), (title: "10 Maiores oportunidades", key: "ListOportunitiesViewController")]),
        
        (title: "", itens:[(title: "Sair", key: "LoginViewController")])
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = appDelegate.user?.nome
        self.subtitleLabel.text = appDelegate.user?.diretoria
        
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].itens.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let line = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        line.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9176470588, blue: 0.9254901961, alpha: 1)
        
        let title = UILabel(frame: CGRect(x: 15, y: 10, width: tableView.frame.width, height: 30))
        title.text = self.menu[section].title
        title.textColor = #colorLiteral(red: 0.5333333333, green: 0.5294117647, blue: 0.5333333333, alpha: 1)
        title.font = UIFont(name: "Avenir Black", size: 15)
        view.addSubview(line)
        view.addSubview(title)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1: return 40
        case 2: return 2
        default: return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.title.text = menu[indexPath.section].itens[indexPath.row].title
        cell.icon.image = UIImage(named: "\(menu[indexPath.section].itens[indexPath.row].key)Icon")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.visibleCells[indexPath.row].isSelected = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let key = menu[indexPath.section].itens[indexPath.row].key
        if key == "LoginViewController" {
            self.logout()
        
        }else if key == "ListNotaViewController" || key == "ListOportunitiesViewController" {
            guard let vc = storyboard.instantiateViewController(withIdentifier: "AreaViewController") as? AreaViewController else {return}
            vc.areaSelected = .pdv
            if key == "ListNotaViewController" {vc.isListNota = true}
            else{vc.isListOport = true}
            appDelegate.slideMenuController?.changeMainViewController(vc, close: true)
        }else if key == "MyTeamsViewController" {
            guard let nivel = appDelegate.user?.nivel else {return}
            if nivel == 0 || nivel == 13 {
                if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTeams2ViewController") as? MyTeams2ViewController {
                    vc.selectedTime = "Regionais"
                    appDelegate.slideMenuController?.changeMainViewController(vc, close: true)
                }
            }else{
                let viewController = storyboard.instantiateViewController(withIdentifier: menu[indexPath.section].itens[indexPath.row].key)
                appDelegate.slideMenuController?.changeMainViewController(viewController, close: true)
            }
        }else{
            let viewController = storyboard.instantiateViewController(withIdentifier: menu[indexPath.section].itens[indexPath.row].key)
            appDelegate.slideMenuController?.changeMainViewController(viewController, close: true)
        }
    }
    
    private func logout(){
        UserModel.signOut()
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withClass: LoginViewController.self)
        ControllerManager.sharedInstance.setupRootViewController(withClass: LoginViewController.self, viewController: viewController, typeTransition: .showHideTransitionViews)
    }
    
    
}
