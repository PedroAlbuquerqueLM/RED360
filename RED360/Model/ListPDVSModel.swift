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

struct ListPDVSModel: ModelType, HandyJSON {
    var uid: String?
    var bairro: String?
    var endereco: String?
    var id: Int?
    var municipio: String?
    var nome: String?
    var pdv: String?
    var token: String?
    
    init() {}
    
    func validateProperties() -> Bool {
        
        return true
    }
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}

