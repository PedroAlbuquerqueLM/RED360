//
//  MyTeamsModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 31/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct MyTeamsModel : Codable {
    let cargoId : Int?
    let cargo : String?
    let cargoSuperior : String?
    let cpf : String?
    
    enum CodingKeys: String, CodingKey {
        
        case cargoId = "cargoId"
        case cargo = "cargo"
        case cargoSuperior = "cargoSuperior"
        case cpf = "cpf"
        
    }
    
}
