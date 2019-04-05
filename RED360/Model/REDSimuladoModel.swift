//
//  REDSimuladoModel.swift
//  RED360
//
//  Created by Argo Solucoes on 28/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

class REDSimuladoModel : Codable {
    var id: Int?
    var tipo: String?
    var curva: String?
    var uf: String?
    var canal: String?
    let kpi : String?
    let pergunta : String?
    let pontosPossiveis : String?
    var pontua : Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tipo = "tipo"
        case curva = "curva"
        case uf = "uf"
        case canal = "canal"
        case kpi = "kpi"
        case pergunta = "pergunta"
        case pontosPossiveis = "pontosPossiveis"
        case pontua = "pontua"
    }
}
