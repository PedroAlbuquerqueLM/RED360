//
//  PerguntasModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 29/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

class PerguntaModel : Codable {
    
    var id: Int?
    var tipo: String?
    var curva: String?
    var uf: String?
    var canal: String?
    var kpi: String?
    var pergunta: String?
    var pontosPossiveis: String?
    var pontua: Bool?
    
    init(pdv: PDVModel, redSimulado: REDSimuladoModel){
        self.id = redSimulado.id
        self.tipo = redSimulado.tipo
        self.curva = pdv.curva
        self.uf = pdv.uf
        self.canal = pdv.canal
        self.kpi = redSimulado.kpi
        self.pergunta = redSimulado.pergunta
        self.pontosPossiveis = redSimulado.pontosPossiveis
        self.pontua = redSimulado.pontua
        
    }
    
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
    }
}
