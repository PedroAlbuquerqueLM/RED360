//
//  HistoricoModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 26/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct HistoricoModel : Codable {
    let dhpId : Int?
    let mes : String?
    let notaRed : String?
    let meta : String?
    
    enum CodingKeys: String, CodingKey {
        case dhpId = "dhpId"
        case mes = "mes"
        case notaRed = "notaRed"
        case meta = "meta"
    }
    
}
