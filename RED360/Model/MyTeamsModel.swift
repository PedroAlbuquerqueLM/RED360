//
//  MyTeamsModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 31/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct MyTeamsModel : Codable {
    let id : Int?
    let regional : String?
    let diretoria : String?
    let gerencia : String?
    let supervisao : String?
    let rotaVendedor : String?
    let cpf : String?
    let nome : String?
    let email : String?
    let nivel : Int?
    let uid: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case regional = "regional"
        case diretoria = "diretoria"
        case gerencia = "gerencia"
        case supervisao = "supervisao"
        case rotaVendedor = "rotaVendedor"
        case cpf = "cpf"
        case nome = "nome"
        case email = "email"
        case nivel = "nivel"
        case uid = "uid"
        
    }
    
}
