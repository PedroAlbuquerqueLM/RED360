//
//  NotaCanalModel.swift
//  RED360
//
//  Created by Argo Solucoes on 25/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct NotaCanalModel : Codable {
    let canal : String?
    let pontuacao : String?
    let pontuacaoAnterior : String?
    let mes : Int?
    let ano : Int?
    let diretoria : String?
    let gerencia : String?
    let supervisao : String?
    let rotaVendedor : String?
    let variacao : String?
    
    enum CodingKeys: String, CodingKey {
        
        case canal = "canal"
        case pontuacao = "pontuacao"
        case pontuacaoAnterior = "pontuacaoAnterior"
        case mes = "mes"
        case ano = "ano"
        case diretoria = "diretoria"
        case gerencia = "gerencia"
        case supervisao = "supervisao"
        case rotaVendedor = "rotaVendedor"
        case variacao = "variacao"
    }
    
}
