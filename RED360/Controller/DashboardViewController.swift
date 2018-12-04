//
//  DashboardViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Charts
import Firebase

class DashboardViewController: SlideViewController {
    
    @IBOutlet weak var dashTableView: UITableView!
    
    @IBOutlet weak var emptyView: UIView!
    
    var notasPilar: [NotaPilarModel]?
    var notasCanal: [NotaCanalModel]?
    var historico: [HistoricoModel]?
    var metas: [String:Double?]?
    var rank: (nota: Double, vari: Double, meta: Double, rank: Int)?
    var date = ""
    var mes: Int?
    var user: UserModel?
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("Meu Resultado")
        
        if self.user != nil {
            self.setTitle(user!.nome ?? "Resultado")
            let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .done, target: nil, action: #selector(closeAction))
            doneItem.tintColor = UIColor.white
        
            self.navItem?.leftBarButtonItem = doneItem;
        }
    }
    
    @objc func closeAction() {
        self.user = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Rest.loadNotaPilar(user: self.user) { (notasPilar, accessDenied) in
            self.notasPilar = notasPilar
            if self.user != nil {
                self.metas = self.user?.metas?.getMetasDic()
            }else{
                self.metas = appDelegate.user?.metas?.getMetasDic()
            }
            self.mes = notasPilar?.first?.mesNome?.getMonth
            if let notasFirst = notasPilar?.first, let meta = self.metas?[notasPilar?.first?.mesNome ?? ""] {
                self.rank = ((nota: notasFirst.total!, vari: ((notasFirst.total)! - (notasFirst.total)!), meta: meta, rank: 0) as! (nota: Double, vari: Double, meta: Double, rank: Int))
            }
            self.date = "\(notasPilar?.first?.mesNome ?? "")/\(notasPilar?.first?.ano ?? "")"
            
            Rest.loadHistorico(user: self.user, onComplete: { (historico, accessDenied) in
                self.historico = historico
                
                Rest.loadPosicao(user: self.user) { (posicao, accessDenied) in
                    self.rank?.rank = (posicao?.posicao!)!
                    self.loadNotaCanal(type: .total)
                }
            })

        }
    }
    
    func loadNotaCanal(type: NotaCanalType, move: Bool = false){
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
        Rest.loadNotaCanal(user: self.user, type: type, onComplete: { (notasCanal, accessDenied) in
            if let vl = self.vLoading{ vl.removeFromSuperview() }
            self.notasCanal = notasCanal
            self.dashTableView.reloadData()
            if move {
                self.dashTableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: false)
            }
        })
    }
}
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            self.emptyView.isHidden = !(self.notasPilar == nil || self.notasPilar!.isEmpty)
            guard let notasCanal = self.notasCanal else {return 1}
            return notasCanal.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankedCell", for: indexPath) as! RankedCell
            cell.rankSet = self.rank
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
            
            cell.viewController = self
            cell.notaPilar = self.notasPilar
            cell.titleBarGreen.text = self.date
            cell.isCombinated = false
            
            return cell
        case 3:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
                
                cell.delegate = self
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCellList", for: indexPath) as! ChannelCellList
                
                guard let notasCanal = self.notasCanal else {return cell}
                cell.borders = true
                cell.notaCanal = notasCanal[indexPath.row]
                
                return cell
            }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
            let total = self.historico?.compactMap{Double($0.total ?? "0")}
            let metas = self.metas?.values.compactMap{$0}
            
            guard let bar = total, let line = metas, let mes = self.mes else {return cell}
            
            var barElements = [Double]()
            var lineElements = [Double]()
            var finishMonths = false
            if mes >= 6 {
                barElements = Array(bar.dropFirst(6))
                lineElements = Array(line.dropFirst(6))
                finishMonths = true
            }else{
                barElements = Array(bar.dropLast(6))
                lineElements = Array(line.dropLast(6))
            }
            
            cell.viewController = self
            cell.valuesComplete = (line: line, bar: bar)
            cell.isCombinated = true
            cell.values = (line: lineElements, bar: barElements, finishMonths: finishMonths)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
            if self.user != nil {
                cell.percentual.text = "\(user?.metas?.percentualOs ?? 0)%"
            }else{
                cell.percentual.text = "\(appDelegate.user?.metas?.percentualOs ?? 0)%"
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            cell.title.text = self.date
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            guard let rank = self.rank?.rank else { return 92 }
            if (rank > 0 && rank < 7) { return 185 }
            return 92
        case 2:
            return 400
        case 3:
            switch indexPath.row {
            case 0:
                return 134
            default:
                return 50
            }
        case 4:
            return 280
        case 5:
            return 0//65
        default:
            return 44
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

extension DashboardViewController: ChannelDelegate {
    func selectedChannel(_ channel: NotaCanalType) {
        self.loadNotaCanal(type: channel, move: true)
    }
}
