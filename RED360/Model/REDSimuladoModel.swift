//
//  REDSimuladoModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 28/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

class REDSimuladoModel : Codable {
    let kpi : String?
    let pergunta : String?
    let pontosPossiveis : String?
    var pontua : Bool?
    
    enum CodingKeys: String, CodingKey {
        case kpi = "kpi"
        case pergunta = "pergunta"
        case pontosPossiveis = "pontosPossiveis"
        case pontua = "pontua"
    }
}
