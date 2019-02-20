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
    @IBOutlet weak var tabBarTypes: UITabBar!
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Pesquisa por código PDV")
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        doneItem.tintColor = UIColor.white
        self.navItem?.leftBarButtonItem = doneItem;
        
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
        self.tabBarTypes.selectedItem = tabBarTypes.items![0]
        Rest.searchPDVComplete(pdv: pdv.pdv!, type: .ativacao) { (pdvComplete, accessDenied) in
            if let vl = self.vLoading{ vl.removeFromSuperview() }
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
            let ttcS = Double(pdv.ttcSugerido?.replacingOccurrences(of: ",", with: ".") ?? "0.0")
            let ttcP = Double(pdv.ttcPesquisado?.replacingOccurrences(of: ",", with: ".") ?? "0.0")
            cell.ttcSugeridoLabel.text = ttcS == 0 ? "-" : String(format: "%.2f", ttcS ?? 0).replacingOccurrences(of: ".", with: ",")
            cell.ttcPesquisadoLabel.text = ttcP == 0 ? "-" : String(format: "%.2f", ttcP ?? 0).replacingOccurrences(of: ".", with: ",")
            return cell
        }else if pdv.percentualSovi != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVCompleteSoviCell", for: indexPath) as! PDVCompleteSoviCell
            cell.title.text = pdv.pergunta
            cell.possiveisLabel.text = pdv.pontosPossiveis
            cell.realizadosLabel.text = pdv.pontosRealizados
            cell.percentualSovi.text = pdv.percentualSovi
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
        }else if pdv.percentualSovi != nil {
            return 117
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
        
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
        Rest.searchPDVComplete(pdv: pdv.pdv!, type: isSelected) { (pdvComplete, accessDenied) in
            if let vl = self.vLoading{ vl.removeFromSuperview() }
            self.pdvComplete = pdvComplete
            self.setTitle("\(item.title ?? "-") - \(pdvComplete?.first?.percentualMes ?? "-")%")
            self.dashTableView.reloadData()
        }
    }
}
