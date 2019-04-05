//
//  QuizzModel.swift
//  RED360
//
//  Created by Argo Solucoes on 31/01/19.
//  Copyright © 2019 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

class QuizzModel : Codable {
    var kpi : String?
    var perguntas : [AnswerModel]?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case kpi = "kpi"
        case perguntas = "perguntas"
    }
}

class AnswerModel : Codable {
    var id : Int?
    var tipo : String?
    var curva : String?
    var uf : String?
    var canal : String?
    var kpi : String?
    var pergunta : String?
    var pontosPossiveis : String?
    var pontua : Bool?
    var respostaId: Int = -1
    var respostas : [ResponseModel]?
    var respostaIndex: Int = -1
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tipo = "tipo"
        case curva = "curva"
        case uf = "uf"
        case canal = "canal"
        case kpi = "kpi"
        case pergunta = "pergunta"
        case pontosPossiveis = "pontosPossiveis"
        case pontua = "pontua"
        case respostas = "respostas"
    }
}

class ResponseModel : Codable {
    var id : Int?
    var resposta : String?
    var pontuacao : String?
    var perguntaId : Int?
    
    init() {}
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case resposta = "resposta"
        case pontuacao = "pontuacao"
        case perguntaId = "perguntaId"
    }
}
