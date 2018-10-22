//
//  notaPilar.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
struct NotaPilar : Codable {
    let id : Int?
    let dhd : String?
    let nome : String?
    let capa : String?
    let cargaHoraria : String?
    let sobreCurso : String?
    let qtdeModulos : Int?
    let qtdeModulosConcluidos : Int?
    let percentualConclusao : String?
    let percentualAproveitamento : String?
    let concluido : Bool?
    let percentualMinimo : String?
    let motivis : Int?
    let uuid : String?
    let atual : Bool?
    let validade : String?
    let excluirAposValidade : Bool?
    let refeito : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case dhd = "dhd"
        case nome = "nome"
        case capa = "capa"
        case cargaHoraria = "cargaHoraria"
        case sobreCurso = "sobreCurso"
        case qtdeModulos = "qtdeModulos"
        case qtdeModulosConcluidos = "qtdeModulosConcluidos"
        case percentualConclusao = "percentualConclusao"
        case percentualAproveitamento = "percentualAproveitamento"
        case concluido = "concluido"
        case percentualMinimo = "percentualMinimo"
        case motivis = "motivis"
        case uuid = "uuid"
        case atual = "atual"
        case validade = "validade"
        case excluirAposValidade = "excluirAposValidade"
        case refeito = "refeito"
    }
    
    
    
}

