//
//  StringExtension.swift
//  RED360
//
//  Created by Pedro Albuquerque on 26/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import UIKit

fileprivate let months = ["Janeiro" : 1, "Fevereiro" : 2, "Março" : 3, "Abril" : 4, "Maio" : 5, "Junho" : 6, "Julho" : 7, "Agosto" : 8, "Setembro" : 9, "Outubro" : 10, "Novembro" : 11, "Dezembro" : 12]

extension String {
    var getMonth: Int? {
        return months[self]
    }
    
    var getNextMonth: String {
        let month = months[self]! == 12 ? 1 : months[self]!+1
        if let asult = months.someKey(forValue: month) {
            return asult
        }
        return ""
    }
    
    var toDouble: Double? {
        return Double(self.replacingOccurrences(of: ",", with: "."))
    }
    
    var toVirgula: String? {
        return self.replacingOccurrences(of: ".", with: ",")
    }
    
    var qntHeight: Int {
        let sizeWidth = screenWidth - 30
        let sizePergunta = CGFloat(self.count) * 9
        let qntHeight = sizePergunta.truncatingRemainder(dividingBy: sizeWidth) > 0 ? (sizePergunta/sizeWidth) + 2 : (sizePergunta/sizeWidth)
        return Int(qntHeight)
    }
}

extension Array {
    func emptyAlert(_ message: String, _ superViewController: UIViewController){
        if self.isEmpty {
            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(cancelAction)
            
            // Present the controller
            superViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
