//
//  BairroModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 20/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct ListPDVModel : Codable {
    var uf : String?
    var municipio : String?
    var bairro : String?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case uf = "uf"
        case municipio = "municipio"
        case bairro = "bairro"
    }
}
