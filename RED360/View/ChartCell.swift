//
//  Chartself.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Charts

class ChartCell: UITableViewCell {
    
    @IBOutlet weak var chart: HorizontalBarChartView!
    
    override func awakeFromNib() {
        
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        self.chart.xAxis.labelPosition = .bottom
        self.chart.leftAxis.axisMinimum = 0.0
        self.chart.leftAxis.axisMaximum = 120.0
        self.chart.xAxis.axisMinimum = -0.5
        self.chart.chartDescription?.text = ""
        self.chart.legend.enabled = false
        self.chart.scaleYEnabled = false
        self.chart.scaleXEnabled = false
        self.chart.pinchZoomEnabled = false
        self.chart.doubleTapToZoomEnabled = false
        self.chart.highlighter = nil
        self.chart.rightAxis.enabled = false
        self.chart.leftAxis.enabled = false
        self.chart.xAxis.drawAxisLineEnabled = false
        self.chart.xAxis.centerAxisLabelsEnabled = false
        
        self.chart.leftAxis.drawGridLinesEnabled = false
        self.chart.rightAxis.drawGridLinesEnabled = false
        self.chart.xAxis.drawGridLinesEnabled = false
        self.chart.drawGridBackgroundEnabled = false
        
        let titles = ["Sovi", "", "", "Preço", "", "", "GDM", "", "", "Disp.", "", "", "Ativ.", "", "", "Total"]
        self.chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: titles)
        self.chart.leftAxis.valueFormatter = IndexAxisValueFormatter(values: [""])
        self.chart.xAxis.granularity = 3
        
        self.chart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuad)
    }
    
    var notaPilar: [NotaPilar]? {
        didSet{
            
            guard let notaPilarActual = notaPilar?.first else {return}
            guard let notaPilarAnterior = notaPilar?.last else {return}
            let sovi = (actual: notaPilarActual.sovi!, anterior: notaPilarAnterior.sovi!)
            let preco = (actual: notaPilarActual.preco!, anterior: notaPilarAnterior.preco!)
            let gdm = (actual: notaPilarActual.gdm!, anterior: notaPilarAnterior.gdm!)
            let disp = (actual: notaPilarActual.disponibilidade!, anterior: notaPilarAnterior.disponibilidade!)
            let ativ = (actual: notaPilarActual.ativacao!, anterior: notaPilarAnterior.ativacao!)
            let total = (actual: notaPilarActual.total!, anterior: notaPilarAnterior.total!)
            let values = [sovi, preco, gdm, disp, ativ, total]
            
            var dataSets = [BarChartDataSet]()
            
            values.enumerated().forEach {
                let dataSet = BarChartDataSet(values: [BarChartDataEntry(x: Double($0.offset + (dataSets.count * 2)), y: $0.element.anterior), BarChartDataEntry(x: Double($0.offset + 1 + (dataSets.count * 2)), y: $0.element.actual)], label: "")
                dataSet.colors = [#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1), #colorLiteral(red: 0.07754790038, green: 0.692034781, blue: 0.3123155236, alpha: 1)]
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.locale = Locale.current
                numberFormatter.negativeSuffix = "%"
                numberFormatter.positiveSuffix = "%"
                
                let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
                dataSet.valueFormatter = valuesNumberFormatter
                dataSet.valueFont = UIFont(name: "Helvetica Neue", size: 12)!
                dataSet.valueTextColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1)
                dataSets.append(dataSet)
            }
            self.chart.data = BarChartData(dataSets: dataSets)
        }
    }
    
}
