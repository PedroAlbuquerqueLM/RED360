//
//  OportunitiesModel.swift
//  RED360
//
//  Created by Argo Solucoes on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct OportunitiesModel : Codable {
    let id : Int?
    let pergunta : String?
    let dataPesquisa : String?
    let oportunidade : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case pergunta = "pergunta"
        case dataPesquisa = "dataPesquisa"
        case oportunidade = "oportunidade"
    }
    
}

