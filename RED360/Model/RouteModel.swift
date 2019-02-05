//
//  RouteModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 30/01/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct ListRouteModel : Codable {
    var id : Int?
    var ate : String?
    var rotina : String?
    var qtdePdvPendente : Int?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ate = "ate"
        case rotina = "rotina"
        case qtdePdvPendente = "qtdePdvPendente"
    }
}

struct ListGerentesModel : Codable {
    var rota : String?
    var qtdePdvs : Int?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case rota = "rota"
        case qtdePdvs = "qtdePdvs"
    }
}

class RotinesModel : Codable {
    var id : Int?
    var rotinaUsuarioId : Int?
    var pdv : String?
    var ate : String?
    var rotina : String?
    var respondida : Bool?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case rotinaUsuarioId = "rotinaUsuarioId"
        case pdv = "pdv"
        case ate = "ate"
        case rotina = "rotina"
        case respondida = "respondida"
        
    }
}
