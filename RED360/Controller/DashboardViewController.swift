//
//  DashboardViewController.swift
//  RED360
//
//  Created by Argo Solucoes on 10/10/18.
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
//    var metas: [String:Double?]?
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

        self.initLoad()
        
        if self.user == nil { self.user = appDelegate.user}
        guard (self.user != nil && self.user?.nivel != nil) else {
            self.createAlertWith(title: "Erro", andMessage: "Você não foi cadastrado no app")
            appDelegate.logout()
            return
        }
        
        
        Rest.loadNotaPilar(user: self.user) { (notasPilar, accessDenied) in
            self.notasPilar = notasPilar
//            if self.user != nil {
//                self.metas = self.user?.metas?.getMetasDic()
//            }else{
//                self.metas = appDelegate.user?.metas?.getMetasDic()
//            }
            self.mes = notasPilar?.first?.mesNome?.getMonth
            if let notasFirst = notasPilar?.first, let notasLast = notasPilar?.last {
                self.rank = ((nota: notasFirst.total!, vari: ((notasFirst.total)! - (notasLast.total)!), meta: 0.0, rank: 0))
            }
            
            self.date = "\(notasPilar?.first?.mesNome ?? "")/\(notasPilar?.first?.ano ?? "")"
            
            Rest.loadHistorico(user: self.user, onComplete: { (historico, accessDenied) in
                self.historico = historico
                
                Rest.loadPosicao(user: self.user) { (posicao, accessDenied) in
                    self.rank?.rank = (posicao?.posicao!)!
                    self.rank?.meta = Double(historico?.first?.meta ?? "0.0") ?? 0.0
//                    self.date = historico?.first?.mes ?? "-"
                    self.loadNotaCanal(type: .total)
                }
            })

        }
    }
    
    func loadNotaCanal(type: NotaCanalType, move: Bool = false){
        self.initLoad()
        Rest.loadNotaCanal(user: self.user, type: type, onComplete: { (notasCanal, accessDenied) in
            if let vl = self.vLoading{ vl.removeFromSuperview() }
            self.notasCanal = notasCanal
            self.dashTableView.reloadData()
            if move {
                self.dashTableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: false)
            }
        })
    }
    
    func initLoad(){
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
    }
    
    func createAlertWith(title: String, andMessage message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true)
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
            return notasCanal.count + 1
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
            
            guard self.notasPilar != nil else {
                cell.emptyView.isHidden = false
                cell.expandButton.isHidden = true
                return cell
            }
            
            cell.expandButton.isHidden = false
            cell.emptyView.isHidden = true
            
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
                cell.notaCanal = notasCanal[indexPath.row-1]
                
                return cell
            }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartCell
            cell.titleLabel.text = "Histórico".uppercased()
            
            guard self.historico != nil else {
                cell.emptyView.isHidden = false
                cell.expandButton.isHidden = true
                return cell
            }
            
            cell.expandButton.isHidden = false
            cell.emptyView.isHidden = true
            let total = self.historico?.compactMap{Double($0.notaRed ?? "0")}
            let metas = self.historico?.compactMap{Double($0.meta ?? "0")}
            let titlesM = self.historico?.compactMap{$0.mes}
            guard let bar = metas, let line = total, let titles = titlesM, let mes = self.mes else {return cell}
            
            cell.viewController = self
            cell.valuesComplete = (line: line, bar: bar, titles: titles)
            cell.isCombinated = true
            cell.loadValues()
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
