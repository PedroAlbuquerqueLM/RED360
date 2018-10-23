//
//  DashboardViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: SlideViewController {
    
    @IBOutlet weak var dashTableView: UITableView!
    
    var notasPilar: [NotaPilar]?
    var rank: (nota: Double, vari: Double, meta: Double, rank: Int)?
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("DASHBOARD")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Rest.loadNotaPilar() { (notasPilar, accessDenied) in
            self.notasPilar = notasPilar
            self.rank = ((nota: notasPilar?.first?.total!, vari: ((notasPilar?.first?.total)! - (notasPilar?.last?.total)!), meta: 10.0, rank: 0) as! (nota: Double, vari: Double, meta: Double, rank: Int))
            self.date = "\(notasPilar?.first?.mesNome ?? "")/\(notasPilar?.first?.ano ?? "")"
            
            Rest.loadPosicao { (posicao, accessDenied) in
                self.rank?.rank = (posicao?.posicao!)!
                self.dashTableView.reloadData()
            }
        }
    }
}
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 4
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
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCellList", for: indexPath) as! ChannelCellList
                return cell
            }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinatedChartCell", for: indexPath) as! CombinatedChartCell
            let line = [51.6, 53.3, 53.1, 55.0, 56.8, 58.7]
            let bar = [51.6]
            
            cell.values = (line: line, bar: bar)
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
