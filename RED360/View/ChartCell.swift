//
//  Chartself.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class ChartCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBarGreen: UILabel!
    @IBOutlet weak var titleBarGray: UILabel!
    @IBOutlet weak var viewBarGreen: UIView!
    @IBOutlet weak var expandButton: UIButton!
    let emptyView = UILabel(frame: CGRect.zero)
    
    @IBOutlet weak var chart: HorizontalBarChartView!
    var chartsLandscapeView: ChartsLandscapeView?
    var viewController: UIViewController!
    var valuesComplete: (line: [Double], bar: [Double])?
    var isCombinated = false
    
    override func awakeFromNib() {
        
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        self.emptyView.isHidden = true
        self.emptyView.backgroundColor = UIColor.white
        emptyView.text = "Nenhuma informação disponível."
        emptyView.textAlignment = .center
        emptyView.textColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1)
        
        self.addSubview(emptyView)
        
        emptyView.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(self).offset(40)
            make.bottom.equalTo(self)
        }
        
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
        
        self.chart.leftAxis.valueFormatter = IndexAxisValueFormatter(values: [""])
        self.chart.xAxis.granularity = 3
        
        self.chart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuad)
    }
    
    @IBAction func expandChartAction(_ sender: Any) {
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowImageViewController") as? ShowImageViewController {
            vc.notasPilar = self.notaPilar
            vc.values = self.valuesComplete
            vc.isCombinated = self.isCombinated
            vc.date = self.titleBarGreen.text
            self.viewController.present(vc, animated: true, completion: nil)
        }
    }
    
    var values: (line: [Double], bar: [Double], finishMonths: Bool)? {
        didSet{
            self.chart.isHidden = true
            self.titleLabel.text = "Histórico".uppercased()
            self.titleBarGreen.text = "Nota RED"
            self.titleBarGray.text = "Meta"
            self.viewBarGreen.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
            self.chartsLandscapeView?.removeFromSuperview()
            self.chartsLandscapeView = ChartsLandscapeView(frame: CGRect(x: 0, y: 50, width: Int(self.frame.width), height: Int(self.frame.height) - 100), qnt: 3, isLand: false)
            self.chartsLandscapeView!.values = self.valuesComplete
            self.insertSubview(self.chartsLandscapeView!, at: 1)
        }
//            self.titleLabel.text = "Histórico"
//            self.titleBarGreen.text = "Nota RED"
//            self.titleBarGray.text = "Meta"
//            self.viewBarGreen.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
//
//            guard let values = values else {return}
//            var months = ["Jan","","", "Fev","","", "Mar","","", "Abr","","", "Mai","","", "Jun","","", "Jul","","", "Ago","","", "Set","","", "Out","","", "Nov","","","Dez"]
//            if values.finishMonths {
//                months = Array(months.dropFirst(18))
//            }
//
//            self.chart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
//
//            chart.noDataText = "Please provide data for the chart."
//
//            var dataSets = [BarChartDataSet]()
//
//            values.bar.enumerated().forEach {
//                let dataSet = BarChartDataSet(values: [BarChartDataEntry(x: Double($0.offset + (dataSets.count * 2)), y: values.line[$0.offset]), BarChartDataEntry(x: Double($0.offset + 1 + (dataSets.count * 2)), y: $0.element)], label: "")
//                dataSet.colors = [#colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)]
//
//                let numberFormatter = NumberFormatter()
//                numberFormatter.numberStyle = .decimal
//                numberFormatter.locale = Locale.current
//                numberFormatter.negativeSuffix = "%"
//                numberFormatter.positiveSuffix = "%"
//
//                let valuesNumberFormatter = ChartValueFormatter(numberFormatter: numberFormatter)
//                dataSet.valueFormatter = valuesNumberFormatter
//                dataSet.valueFont = UIFont(name: "Helvetica Neue", size: 12)!
//                dataSet.valueTextColor = #colorLiteral(red: 0.5529411765, green: 0.5882352941, blue: 0.631372549, alpha: 1)
//                dataSets.append(dataSet)
//            }
//            self.chart.data = BarChartData(dataSets: dataSets)
//        }
    }
    
    var pdv: PDVModel? {
        didSet{
            self.chart.isHidden = true
            self.titleLabel.text = "NOTA POR PILAR".uppercased()
            self.chartsLandscapeView?.removeFromSuperview()
            self.chartsLandscapeView = ChartsLandscapeView(frame: CGRect(x: 0, y: 50, width: Int(self.frame.width), height: Int(self.frame.height) - 70), qnt: 1, isLand: false)
            self.chartsLandscapeView!.pdv = self.pdv
            self.insertSubview(self.chartsLandscapeView!, at: 1)
        }
    }
    
    var notaPilar: [NotaPilarModel]? {
        didSet{
            self.chart.isHidden = false
            self.chartsLandscapeView?.removeFromSuperview()
            self.titleLabel.text = "Nota por pilar".uppercased()
            self.titleBarGreen.text = "Mês Atual"
            self.titleBarGray.text = "Mês Anterior"
            self.viewBarGreen.backgroundColor = #colorLiteral(red: 0.07754790038, green: 0.692034781, blue: 0.3123155236, alpha: 1)
            
            let titles = ["Sovi", "", "", "Preço", "", "", "GDM", "", "", "Disp.", "", "", "Ativ.", "", "", "Total"]
            self.chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: titles)
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
