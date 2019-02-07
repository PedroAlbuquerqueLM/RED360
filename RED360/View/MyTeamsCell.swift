//
//  MyTeamsCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 07/02/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class MyTeamsCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var nota: UILabel!
    @IBOutlet weak var notaHead: UILabel!
    @IBOutlet weak var meta: UILabel!
    
    var myTeams: MyTeamsModel? {
        didSet{
            guard let myTeams = myTeams else {return}
            self.title.text = myTeams.cargo
            self.month.text = myTeams.mes
            self.meta.text = myTeams.meta
            self.nota.text = myTeams.notaRed

            if (Float(myTeams.notaRed ?? "0") ?? 0) >= (Float(myTeams.meta ?? "0") ?? 0) {
                self.nota.textColor = #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1)
                self.notaHead.backgroundColor = #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1)
            }else {
                self.nota.textColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0.2509803922, alpha: 1)
                self.notaHead.backgroundColor = #colorLiteral(red: 1, green: 0.8431372549, blue: 0.2509803922, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        
    }
}
