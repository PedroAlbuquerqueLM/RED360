//
//  ChannelCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 14/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    
    
    override func awakeFromNib() {
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    @IBAction func selectChannelAction(_ sender: Any) {
    }
    
    
}

class ChannelCellList: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var atual: UILabel!
    @IBOutlet weak var anterior: UILabel!
    @IBOutlet weak var variacao: UILabel!
    @IBOutlet weak var upDownArrow: UIImageView!
    
    
    override func awakeFromNib() {
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    var notaCanal: NotaCanalModel? {
        didSet{
            guard let notaCanal = notaCanal else {return}
            self.title.text = notaCanal.canal
            self.atual.text = "\(notaCanal.pontuacao ?? "")%"
            self.anterior.text = "\(notaCanal.pontuacaoAnterior ?? "")%"
            self.variacao.text = "\(notaCanal.variacao ?? "")%"
            guard let variacao = notaCanal.variacao?.replacingOccurrences(of: ",", with: "."), let variacaoN = Float(variacao) else {return}
            if variacaoN < 0 {
                self.upDownArrow.image = #imageLiteral(resourceName: "downIcon")
            }else if variacaoN > 0 {
                self.upDownArrow.image = #imageLiteral(resourceName: "upIcon")
            }else{
                self.upDownArrow.image = nil
            }
        }
    }
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}
