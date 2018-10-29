//
//  ChartsLandscapeView.swift
//  RED360
//
//  Created by Pedro Albuquerque on 28/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class ChartsLandscapeView: UIView {
    
    var chart: HorizontalBarChartView!
    
    override init(frame: CGRect) {
     
        super.init(frame: frame)
        
        self.chart = HorizontalBarChartView(frame: CGRect.zero)
        self.chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        self.backgroundColor = UIColor.white
        self.addSubview(self.chart)
        
        self.chart.snp.makeConstraints({ (make) in
            make.height.equalTo(self.frame.width)
            make.width.equalTo(self.frame.height-50)
            make.center.equalTo(CGPoint(x: self.center.x, y: self.center.y + 50))
            
        })
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var notaPilar: [NotaPilarModel]? {
        didSet{
            
            guard let notaPilarActual = notaPilar?.first else {return}
            guard let notaPilarAnterior = notaPilar?.last else {return}
            let sovi = (actual: notaPilarActual.sovi!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.sovi! : 0)
            let preco = (actual: notaPilarActual.preco!, anterior: (notaPilar?.count)! > 0 ?notaPilarAnterior.preco! : 0)
            let gdm = (actual: notaPilarActual.gdm!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.gdm! : 0)
            let disp = (actual: notaPilarActual.disponibilidade!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.disponibilidade! : 0)
            let ativ = (actual: notaPilarActual.ativacao!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.ativacao! : 0)
            let total = (actual: notaPilarActual.total!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.total! : 0)
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
