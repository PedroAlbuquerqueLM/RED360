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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitle("DASHBOARD")
    }
    
}
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankedCell", for: indexPath) as! RankedCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
            let arr = [(actual: 65.3, anterior: 74.7), (actual: 98.4, anterior: 93.5), (actual: 31.5, anterior: 51.2), (actual: 53.5, anterior: 59.3), (actual: 29.1, anterior: 32.1), (actual: 52.9, anterior: 57.9)]
            
            cell.values = arr
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCellList", for: indexPath) as! ChannelCellList
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CombinatedChartCell", for: indexPath) as! CombinatedChartCell
            let line = [51.6, 53.3, 53.1, 55.0, 56.8, 58.7]
            let bar = [51.6]
            
            cell.values = (line: line, bar: bar)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 185
        case 1:
            return 400
        case 2:
            switch indexPath.row {
            case 0:
                return 134
            default:
                return 50
            }
        case 3:
            return 250
        default:
            return 65
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
