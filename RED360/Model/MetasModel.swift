//
//  MetasModel.swift
//  RED360
//
//  Created by Argo Solucoes on 25/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import Firebase
import HandyJSON
import CoreLocation
import PromiseKit

struct MetasModel: ModelType, HandyJSON {
    var uid: String?
    var janeiro: Double?
    var fevereiro: Double?
    var marco: Double?
    var abril: Double?
    var maio: Double?
    var junho: Double?
    var julho: Double?
    var agosto: Double?
    var setembro: Double?
    var outubro: Double?
    var novembro: Double?
    var dezembro: Double?
    var percentualOs: Double?
    var cpf: String?

    init() {}
    
    func getMetasDic() -> [String : Double?] {
        return ["Janeiro" : janeiro, "Fevereiro" : fevereiro, "Março" : marco, "Abril" : abril, "Maio" : maio, "Junho" : junho, "Julho" : julho, "Agosto" : agosto, "Setembro" : setembro, "Outubro" : outubro, "Novembro" : novembro, "Dezembro" : dezembro]
    }
    
    func validateProperties() -> Bool {
        
        return true
    }
    
    mutating func mapping(mapper: HelpingMapper) {
        
    }
}
