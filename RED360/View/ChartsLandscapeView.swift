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
    
    var charts = [BarChartView]()
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var isLand = true
    
    init(frame: CGRect, qnt: Int, isLand: Bool = true) {
     
        super.init(frame: frame)
        self.isLand = isLand
        self.scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:frame.width, height:frame.height))
        self.scrollView.isPagingEnabled = true
        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        
        for _ in 0..<qnt {
            let chart = BarChartView(frame: CGRect.zero)
            if isLand{
                chart.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            }
            backgroundColor = UIColor.white
            self.charts.append(chart)
            self.scrollView.addSubview(chart)
        }
        if isLand{
            self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width, height:self.scrollView.frame.height * CGFloat(scrollView.subviews.count))
        }else{
            self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(scrollView.subviews.count), height:self.scrollView.frame.height)
        }
        self.scrollView.delegate = self
        
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.height - 35, width: frame.width, height: 35))
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = scrollView.subviews.count
        self.pageControl.isHidden = true
        
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        
        self.charts.enumerated().forEach{
            if isLand{
                let i = CGFloat($0.offset) * (self.center.y * 2)
                $0.element.snp.makeConstraints({ (make) in
                    make.height.equalTo(self.frame.width)
                    make.width.equalTo(self.frame.height-10)
                    make.center.equalTo(CGPoint(x: self.center.x + 10, y: (self.center.y + i) + 10))
                })
            }else{
                let i = CGFloat($0.offset) * (self.center.x * 2)
                $0.element.snp.makeConstraints({ (make) in
                    make.height.equalTo(self.frame.height)
                    make.width.equalTo(self.frame.width - 20)
                    make.center.equalTo(CGPoint(x: self.center.y + 50 + i, y: self.center.y - 50))
                })
            }
            
            $0.element.xAxis.labelPosition = .bottom
            $0.element.leftAxis.axisMinimum = 0.0
            $0.element.leftAxis.axisMaximum = 120.0
            $0.element.xAxis.axisMinimum = -0.5
            $0.element.chartDescription?.text = ""
            $0.element.legend.enabled = false
            $0.element.scaleYEnabled = false
            $0.element.scaleXEnabled = false
            $0.element.pinchZoomEnabled = false
            $0.element.doubleTapToZoomEnabled = false
            $0.element.highlighter = nil
            $0.element.rightAxis.enabled = false
            $0.element.leftAxis.enabled = false
            $0.element.xAxis.drawAxisLineEnabled = false
            $0.element.xAxis.centerAxisLabelsEnabled = false
            
            $0.element.leftAxis.drawGridLinesEnabled = false
            $0.element.rightAxis.drawGridLinesEnabled = false
            $0.element.xAxis.drawGridLinesEnabled = false
            $0.element.drawGridBackgroundEnabled = false
            
            $0.element.leftAxis.valueFormatter = IndexAxisValueFormatter(values: [""])
            $0.element.xAxis.granularity = 3
            
            $0.element.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuad)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var values: (line: [Double], bar: [Double])? {
        didSet{
            
            guard let values = values else {return}
            let months1 = ["Jan","","", "Fev","","", "Mar","","", "Abr","","", "Mai","","", "Jun"]
            let months2 =  ["Jul","","", "Ago","","", "Set","","", "Out","","", "Nov","","","Dez"]
            
            self.charts.first!.xAxis.valueFormatter = IndexAxisValueFormatter(values:months1)
            self.charts.first!.noDataText = "Please provide data for the chart."
            self.charts.last!.xAxis.valueFormatter = IndexAxisValueFormatter(values:months2)
            self.charts.last!.noDataText = "Please provide data for the chart."
            
            var dataSets = [[BarChartDataSet]() ,[BarChartDataSet]()]
            
            var index = 0
            var offset = 0
            values.bar.enumerated().forEach {
                if $0.offset == 6 {
                    index = 1
                    offset = 0
                }
                let dataSet = BarChartDataSet(values: [BarChartDataEntry(x: Double(offset + (dataSets[index].count * 2)), y: values.line[$0.offset]), BarChartDataEntry(x: Double(offset + 1 + (dataSets[index].count * 2)), y: $0.element)], label: "")
                dataSet.colors = [#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)]
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.locale = Locale.current
                numberFormatter.negativeSuffix = "%"
                numberFormatter.positiveSuffix = "%"
                
                let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
                dataSet.valueFormatter = valuesNumberFormatter
                if isLand {
                    dataSet.valueFont = UIFont(name: "Helvetica Neue", size: 12)!
                }else{
                    dataSet.valueFont = UIFont(name: "Helvetica Neue", size: 8)!
                }
                dataSet.valueTextColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1)
                dataSets[index].append(dataSet)
                offset += 1
            }
            self.charts.first!.data = BarChartData(dataSets: dataSets.first)
            self.charts.last!.data = BarChartData(dataSets: dataSets.last)
        }
    }
    
    var notaPilar: [NotaPilarModel]? {
        didSet{
            
            let titles = ["Total", "", "", "Ativ.", "", "", "Disp.", "", "", "GDM", "", "", "Preço.", "", "", "Sovi"]
            self.charts.first!.xAxis.valueFormatter = IndexAxisValueFormatter(values: titles)
            
            guard let notaPilarActual = notaPilar?.first else {return}
            guard let notaPilarAnterior = notaPilar?.last else {return}
            let sovi = (actual: notaPilarActual.sovi!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.sovi! : 0)
            let preco = (actual: notaPilarActual.preco!, anterior: (notaPilar?.count)! > 0 ?notaPilarAnterior.preco! : 0)
            let gdm = (actual: notaPilarActual.gdm!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.gdm! : 0)
            let disp = (actual: notaPilarActual.disponibilidade!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.disponibilidade! : 0)
            let ativ = (actual: notaPilarActual.ativacao!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.ativacao! : 0)
            let total = (actual: notaPilarActual.total!, anterior: (notaPilar?.count)! > 0 ? notaPilarAnterior.total! : 0)
            let values = [total, ativ, disp, gdm, preco, sovi]
            
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
                dataSet.valueFont = UIFont(name: "Helvetica Neue", size: 10)!
                dataSet.valueTextColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1)
                dataSets.append(dataSet)
            }
            self.charts.first!.data = BarChartData(dataSets: dataSets)
        }
    }
}

extension ChartsLandscapeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        return
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        
        var pageWidth:CGFloat = scrollView.frame.height
        if !isLand{
            pageWidth = scrollView.frame.width
        }
        let currentPage:CGFloat = floor((scrollView.contentOffset.y-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        print(currentPage)
    }
}
