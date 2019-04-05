//
//  PDVCompleteModel.swift
//  RED360
//
//  Created by Argo Solucoes on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct PDVCompleteModel : Codable {
    let id : Int?
    let dataPesquisa : String?
    let pergunta : String?
    let pontosPossiveis : String?
    let pontosRealizados : String?
    let percentualMes : String?
    let ttcPesquisado : String?
    let ttcSugerido : String?
    let percentualSovi : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case dataPesquisa = "dataPesquisa"
        case pergunta = "pergunta"
        case pontosPossiveis = "pontosPossiveis"
        case pontosRealizados = "pontosRealizados"
        case percentualMes = "percentualMes"
        case ttcPesquisado = "ttcPesquisado"
        case ttcSugerido = "ttcSugerido"
        case percentualSovi = "percentualSovi"
    }
    
}
