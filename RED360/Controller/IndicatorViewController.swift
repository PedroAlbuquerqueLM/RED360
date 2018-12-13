//
//  IndicatorViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class IndicatorViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataTable: UITableView!
    
    var channel = ""
    var dicNota: [String: NotaCanalModel?]?
    
    var titles = ["total", "ativacao", "disponibilidade", "gdm", "preco", "sovi"]
    var titlesNames = ["Total", "Ativacao", "Disponibilidade", "GDM", "Preço", "Sovi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = channel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Rest.loadIndicator(channel: channel) { (dicNota, accessDenied) in
            self.dicNota = dicNota
            self.dataTable.reloadData()
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension IndicatorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCellList", for: indexPath) as! ChannelCellList
        
        guard let notaCanal = self.dicNota?[titles[indexPath.row]] else {return cell}
        cell.notaCanal = notaCanal
        cell.title.text = titlesNames[indexPath.row]
        
        return cell
    }
    
    
}
