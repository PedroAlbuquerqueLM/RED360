//
//  StringExtension.swift
//  RED360
//
//  Created by Pedro Albuquerque on 26/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

fileprivate let months = ["Janeiro" : 1, "Fevereiro" : 2, "Março" : 3, "Abril" : 4, "Maio" : 5, "Junho" : 6, "Julho" : 7, "Agosto" : 8, "Setembro" : 9, "Outubro" : 10, "Novembro" : 11, "Dezembro" : 12]

extension String {
    var getMonth: Int? {
        return months[self]
    }
    
    var toDouble: Double? {
        return Double(self.replacingOccurrences(of: ",", with: "."))
    }
}
