//
//  ChannelCell.swift
//  RED360
//
//  Created by Pedro Albuquerque on 14/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import SCLAlertView

protocol ChannelDelegate: class {
    func selectedChannel(_ channel: NotaCanalType)
}

class ChannelCell: UITableViewCell {
    
    @IBOutlet weak var channelButton: UIButton!
    weak var delegate: ChannelDelegate?
    
    override func awakeFromNib() {
//        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
//        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    @IBAction func selectChannelAction(_ sender: Any) {
        self.showOptions()
    }
    
    func showOptions(){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false, showCircularIcon: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        let totalBtn = alertView.addButton("Total") {
            self.channelButton.setTitle("Total", for: .normal)
            self.delegate?.selectedChannel(.total)
        }
        let ativBtn = alertView.addButton("Ativação") {
            self.channelButton.setTitle("Ativação", for: .normal)
            self.delegate?.selectedChannel(.ativacao)
        }
        let dispBtn = alertView.addButton("Disponibilidade") {
            self.channelButton.setTitle("Disponibilidade", for: .normal)
            self.delegate?.selectedChannel(.disponibilidade)
        }
        let gdmBtn = alertView.addButton("GDM") {
            self.channelButton.setTitle("GDM", for: .normal)
            self.delegate?.selectedChannel(.gdm)
        }
        let precoBtn = alertView.addButton("Preço") {
            self.channelButton.setTitle("Preço", for: .normal)
            self.delegate?.selectedChannel(.preco)
        }
        let soviBtn = alertView.addButton("Sovi") {
            self.channelButton.setTitle("Sovi", for: .normal)
            self.delegate?.selectedChannel(.sovi)
        }
        let closeBtn = alertView.addButton("Fechar") {}
        
        alertView.showTitle("Selecione o Canal", subTitle: "", style: .error)
        totalBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
        ativBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
        dispBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
        gdmBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
        precoBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
        soviBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
        closeBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.368627451, blue: 0.3529411765, alpha: 1)
    }
    
    
}

class ChannelCellList: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var atual: UILabel!
    @IBOutlet weak var anterior: UILabel!
    @IBOutlet weak var variacao: UILabel!
    @IBOutlet weak var upDownArrow: UIImageView!
    
    
    override func awakeFromNib() {
        
    }
    
    var borders: Bool? = false {
        didSet{
            if borders! {
//                self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7959920805)
//                self.layer.borderWidth = 1
//                self.layer.cornerRadius = 5
                self.clipsToBounds = true
            }
        }
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
