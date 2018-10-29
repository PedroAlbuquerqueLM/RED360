//
//  CombinatedChartsLandscapeView.swift
//  RED360
//
//  Created by Pedro Albuquerque on 28/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class CombinatedChartsLandscapeView: UIView{
    
    var chart: CombinedChartView!
    
    let months = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"]
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.chart = CombinedChartView(frame: CGRect.zero)
        self.chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        self.backgroundColor = UIColor.white
        self.addSubview(self.chart)
        
        self.chart.snp.makeConstraints({ (make) in
            make.height.equalTo(self.frame.width-20)
            make.width.equalTo(self.frame.height-70)
            make.center.equalTo(CGPoint(x: self.center.x, y: self.center.y + 50))
            
        })
        
        self.chart.xAxis.labelPosition = .bottom
        self.chart.leftAxis.axisMinimum = 0.0
        self.chart.leftAxis.axisMaximum = 100.0
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
        self.chart.xAxis.granularity = 1
        
        self.chart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuad)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var values: (line: [Double], bar: [Double])? {
        didSet{
            guard let values = values else {return}
            let months = self.months
            
            self.chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
            
            chart.noDataText = "Please provide data for the chart."
            
            self.chart.xAxis.axisMaximum = Double(values.bar.count > values.line.count ? values.bar.count : values.line.count) - 0.5
            
            var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
            var yVals2 : [BarChartDataEntry] = [BarChartDataEntry]()
            
            values.line.enumerated().forEach{
                yVals1.append(ChartDataEntry(x: Double($0.offset), y: $0.element))
            }
            values.bar.enumerated().forEach{
                yVals2.append(BarChartDataEntry(x: Double($0.offset), y: $0.element))
            }
            
            let lineChartSet = LineChartDataSet(values: yVals1, label: "Line Data")
            
            lineChartSet.colors = [#colorLiteral(red: 0.07754790038, green: 0.692034781, blue: 0.3123155236, alpha: 1)]
            lineChartSet.lineWidth = 2
            lineChartSet.circleColors = [#colorLiteral(red: 0.982096374, green: 0.9647918344, blue: 0.0243586842, alpha: 1)]
            let barChartSet: BarChartDataSet = BarChartDataSet(values: yVals2, label: "Bar Data")
            barChartSet.colors = [#colorLiteral(red: 0.9625330567, green: 0.3677152991, blue: 0.353512764, alpha: 1)]
            
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale.current
            numberFormatter.negativeSuffix = "%"
            numberFormatter.positiveSuffix = "%"
            
            let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
            barChartSet.valueFormatter = valuesNumberFormatter
            barChartSet.valueFont = UIFont(name: "Helvetica Neue", size: 7)!
            lineChartSet.valueFormatter = valuesNumberFormatter
            lineChartSet.valueFont = UIFont(name: "Helvetica Neue", size: 7)!
            
            
            let data: CombinedChartData = CombinedChartData()
            data.barData = BarChartData(dataSet: barChartSet)
            data.lineData = LineChartData(dataSet: lineChartSet)
            
            chart.data = data
        }
    }
}

