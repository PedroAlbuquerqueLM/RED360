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
    
    var notasPilar: [NotaPilarModel]?
    var notasCanal: [NotaCanalModel]?
    var historico: [HistoricoModel]?
    var metas: [String:Double?]?
    var rank: (nota: Double, vari: Double, meta: Double, rank: Int)?
    var date = ""
    var mes: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("DASHBOARD")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Rest.loadNotaPilar() { (notasPilar, accessDenied) in
            self.notasPilar = notasPilar
            self.metas = appDelegate.user?.metas?.getMetasDic()
            self.mes = notasPilar?.first?.mesNome?.getMonth
            let meta = self.metas?[notasPilar?.first?.mesNome ?? ""]
            self.rank = ((nota: notasPilar?.first?.total!, vari: ((notasPilar?.first?.total)! - (notasPilar?.last?.total)!), meta: meta, rank: 0) as! (nota: Double, vari: Double, meta: Double, rank: Int))
            self.date = "\(notasPilar?.first?.mesNome ?? "")/\(notasPilar?.first?.ano ?? "")"
            
            Rest.loadHistorico(onComplete: { (historico, accessDenied) in
                self.historico = historico
                
                Rest.loadPosicao { (posicao, accessDenied) in
                    self.rank?.rank = (posicao?.posicao!)!
                    self.loadNotaCanal(type: .total)
                }
            })

        }
    }
    
    func loadNotaCanal(type: NotaCanalType, move: Bool = false){
        Rest.loadNotaCanal(type: type, onComplete: { (notasCanal, accessDenied) in
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
            
            cell.notaPilar = self.notasPilar
            
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
                cell.notaCanal = notasCanal[indexPath.row]
                
                return cell
            }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinatedChartCell", for: indexPath) as! CombinatedChartCell
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
            
            cell.values = (line: lineElements, bar: barElements, finishMonths: finishMonths)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
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
            return 250
        case 5:
            return 65
        default:
            return 44
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
