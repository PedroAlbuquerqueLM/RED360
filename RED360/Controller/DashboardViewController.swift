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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankedCell", for: indexPath) as! RankedCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
            let arr = [(actual: 65.3, anterior: 74.7), (actual: 98.4, anterior: 93.5), (actual: 31.5, anterior: 51.2), (actual: 53.5, anterior: 59.3), (actual: 29.1, anterior: 32.1), (actual: 52.9, anterior: 57.9)]
            
            cell.values = arr
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 185
        default:
            return 400
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

class ChartValueFormatter: NSObject, IValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?
    
    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: value)!
    }
}

