//
//  ListPDVSModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 21/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import Firebase
import HandyJSON
import CoreLocation
import PromiseKit

struct ListPDVSModel: ModelType, HandyJSON, Codable {
    var uid: String?
    var bairro: String?
    var endereco: String?
    var id: Int?
    var municipio: String?
    var nome: String?
    var pdv: String?
    var token: String?
    var notaRed: String?
    
    var rua: String?
    var numero: String?
    var uf: String?
    
    init() {}
    
    func validateProperties() -> Bool {
        
        return true
    }
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case bairro = "bairro"
        case endereco = "endereco"
        case id = "id"
        case municipio = "municipio"
        case nome = "nome"
        case pdv = "pdv"
        case token = "token"
        case rua = "rua"
        case numero = "numero"
        case uf = "uf"
        case notaRed = "total"
    }
}

