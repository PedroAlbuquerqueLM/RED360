//
//  notaPilar.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
struct NotaPilar : Codable {
    let dhpId : Int?
    let total : Double?
    let ativacao : Double?
    let disponibilidade : Double?
    let gdm : Double?
    let preco : Double?
    let sovi : Double?
    let mesNome : String?
    let ano : String?
    
    enum CodingKeys: String, CodingKey {
        
        case dhpId = "dhpId"
        case total = "total"
        case ativacao = "ativacao"
        case disponibilidade = "disponibilidade"
        case gdm = "gdm"
        case preco = "preco"
        case sovi = "sovi"
        case mesNome = "mesNome"
        case ano = "ano"
    }
    
}

