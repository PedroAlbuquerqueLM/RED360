//
//  REDSimuladoViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 27/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class REDSimuladoViewController: SlideViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dashTableView: UITableView!
    
    var pdv: PDVModel!
    var pdvComplete: [PDVCompleteModel]?
    
    @IBOutlet weak var tabBarTypes: UITabBar!
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("RED Simulado")
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        doneItem.tintColor = UIColor.white
        self.navItem?.leftBarButtonItem = doneItem;
        
//        if let vl = vLoading{
//            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//            vl.aiLoading.startAnimating()
//            view.addSubview(vl)
//        }
        self.tabBarTypes.selectedItem = tabBarTypes.items![0]

    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension REDSimuladoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let pdvComplete = self.pdvComplete else {return 0}
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "REDSimuladoCell", for: indexPath) as! REDSimuladoCell
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

extension REDSimuladoViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var isSelected = PDVCompleteType.ativacao
        switch item.tag {
        case 1: isSelected = .disponibilidade
        case 2: isSelected = .gdm
        case 3: isSelected = .preco
        case 4: isSelected = .sovi
        default: isSelected = .ativacao
        }
        
//        if let vl = vLoading{
//            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//            vl.aiLoading.startAnimating()
//            view.addSubview(vl)
//        }
//        Rest.searchPDVComplete(pdv: pdv.pdv!, type: isSelected) { (pdvComplete, accessDenied) in
//            if let vl = self.vLoading{ vl.removeFromSuperview() }
//            self.pdvComplete = pdvComplete
//            self.setTitle("\(item.title ?? "-") - \(pdvComplete?.first?.percentualMes ?? "-")%")
//            self.dashTableView.reloadData()
//        }
    }
}

