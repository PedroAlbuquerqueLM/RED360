//
//  PesquisaSimuladaModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import CoreLocation

class PesquisaSimuladaModel : Codable {
    var pesquisador: String?
    var pdv: String?
    var latitude: Double?
    var longitude: Double?
    var nivel: Int?
    var cargo: String?
    var supervisao: String?
    var ativacao: String?
    var percentualAtivacao: String?
    var percentualDisponibilidade: String?
    var percentualGdm: String?
    var percentualPreco: String?
    var percentualSovi: String?
    var percentualTotal: String?
    
    init(pdv: String?, location: CLLocationCoordinate2D?, ativacao: String?, percentualAtivacao: String?, percentualDisponibilidade: String?, percentualGdm: String?, percentualPreco: String?, percentualSovi: String?, percentualTotal: String?){
        self.pesquisador = appDelegate.user?.nome
        self.nivel = appDelegate.user?.nivel
        self.cargo = appDelegate.user?.cargo
        self.supervisao = appDelegate.user?.cargoSuperior
        if let location = location {
            self.latitude = location.latitude
            self.longitude = location.longitude
        }
        self.pdv = pdv
        
        self.ativacao = ativacao
        self.percentualAtivacao = percentualAtivacao
        self.percentualDisponibilidade = percentualDisponibilidade
        self.percentualGdm = percentualGdm
        self.percentualPreco = percentualPreco
        self.percentualSovi = percentualSovi
        self.percentualTotal = percentualTotal
        
    }
    
    enum CodingKeys: String, CodingKey {
        case pesquisador = "pesquisador"
        case pdv = "pdv"
        case latitude = "latitude"
        case longitude = "longitude"
        case nivel = "nivel"
        case cargo = "cargo"
        case supervisao = "supervisao"
        case ativacao = "ativacao"
        case percentualAtivacao = "percentualAtivacao"
        case percentualDisponibilidade = "percentualDisponibilidade"
        case percentualGdm = "percentualGdm"
        case percentualPreco = "percentualPreco"
        case percentualSovi = "percentualSovi"
        case percentualTotal = "percentualTotal"
    }
}


