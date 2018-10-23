//
//  PosicaoModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 23/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct PosicaoModel : Codable {
    let id : Int?
    let dhpId : Int?
    let nivelEstrutura : String?
    let supervisao : String?
    let posicao : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case dhpId = "dhpId"
        case nivelEstrutura = "nivelEstrutura"
        case supervisao = "supervisao"
        case posicao = "posicao"
    }
    
}


