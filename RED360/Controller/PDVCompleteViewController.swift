//
//  PDVCompleteViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class PDVCompleteViewController: SlideViewController {
    
    @IBOutlet weak var dashTableView: UITableView!
    var pdv: PDVModel!
    var pdvComplete: [PDVCompleteModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Pesquisa por código PDV")
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        doneItem.tintColor = UIColor.white
        
        self.navItem?.leftBarButtonItem = doneItem;
        
        Rest.searchPDVComplete(pdv: pdv.pdv!, type: .ativacao) { (pdvComplete, accessDenied) in
            self.pdvComplete = pdvComplete
            self.setTitle("Ativação - \(pdvComplete?.first?.percentualMes ?? "-")%")

            self.dashTableView.reloadData()
        }
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PDVCompleteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pdvComplete = self.pdvComplete else {return 0}
        return pdvComplete.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pdv = self.pdvComplete![indexPath.row]
        if pdv.ttcPesquisado != nil || pdv.ttcSugerido != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVCompletePrecoCell", for: indexPath) as! PDVCompletePrecoCell
            cell.title.text = pdv.pergunta
            cell.possiveisLabel.text = pdv.pontosPossiveis
            cell.realizadosLabel.text = pdv.pontosRealizados
            cell.ttcSugeridoLabel.text = pdv.ttcSugerido
            cell.ttcPesquisadoLabel.text = pdv.ttcPesquisado
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVCompleteCell", for: indexPath) as! PDVCompleteCell
            cell.title.text = pdv.pergunta
            cell.possiveisLabel.text = pdv.pontosPossiveis
            cell.realizadosLabel.text = pdv.pontosRealizados
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let pdv = self.pdvComplete![indexPath.row]
        if pdv.ttcPesquisado != nil || pdv.ttcSugerido != nil {
            return 147
        }
        
        return 93
    }
    
}

extension PDVCompleteViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var isSelected = PDVCompleteType.ativacao
        switch item.tag {
            case 1: isSelected = .disponibilidade
            case 2: isSelected = .gdm
            case 3: isSelected = .preco
            case 4: isSelected = .sovi
            default: isSelected = .ativacao
        }
        
        Rest.searchPDVComplete(pdv: pdv.pdv!, type: isSelected) { (pdvComplete, accessDenied) in
            self.pdvComplete = pdvComplete
            self.setTitle("\(item.title ?? "-") - \(pdvComplete?.first?.percentualMes ?? "-")%")
            self.dashTableView.reloadData()
        }
    }
}
