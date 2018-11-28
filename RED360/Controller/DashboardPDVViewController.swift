//
//  DashboardPDVViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class DashboardPDVViewController: SlideViewController {
    
    @IBOutlet weak var dashTableView: UITableView!
    
    var titleTop = "Pesquisa por código PDV"
    var pdv: PDVModel!
    var oportunities: [String:[OportunitiesModel]]!
    var titles = ["ATIVAÇÃO", "DISPONIBILIDADE", "GDM", "PREÇO", "SOVI"]
    var titlesOut = ["ativacao", "disponibilidade", "gdm", "preco", "sovi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle(titleTop)
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
        doneItem.tintColor = UIColor.white
        
        self.navItem?.leftBarButtonItem = doneItem;
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DashboardPDVViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section < 4) || (section > 8) { return 1 }
        return (self.oportunities[titlesOut[section-4]]?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVDetailsCell", for: indexPath) as! PDVDetailsCell
            cell.pdv = self.pdv
            cell.superViewController = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVNotaRedCell", for: indexPath) as! PDVNotaRedCell
            cell.pdv = self.pdv
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
            cell.pdv = self.pdv
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OportunitiesCell", for: indexPath)
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PDVButtonsCell", for: indexPath) as! PDVButtonsCell
            cell.superViewController = self
            return cell
        default:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PDVOpTitleCell", for: indexPath) as! PDVOpTitleCell
                cell.title.text = self.titles[indexPath.section-4]
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "PDVOpDetailsCell", for: indexPath) as! PDVOpDetailsCell
                let value = self.oportunities[titlesOut[indexPath.section-4]]?[indexPath.row-1]
                cell.detail.text = value?.pergunta
                cell.pontuacao.text = value?.oportunidade
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0: return 296
            case 1: return 150
            case 2: return 280
            case 3: return 100
            case 9: return 120 //120 liberar quando tiver o RED SIMULADO
            default:
                if indexPath.row > 0 { return 60}
                if self.oportunities[titlesOut[indexPath.section-4]]?.count == 0 { return 80 }
                return 45;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                return
            default:
                guard let cell = tableView.cellForRow(at: indexPath) as? ChannelCellList else {return}
                if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IndicatorViewController") as? IndicatorViewController {
                    vc.channel = cell.notaCanal?.canal ?? ""
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                }
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
