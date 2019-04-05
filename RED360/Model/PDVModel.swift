//
//  PDVModel.swift
//  RED360
//
//  Created by Argo Solucoes on 19/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct PDVModel : Codable {
    
    let id: Int?
    let de: String?
    let ate: String?
    let rotinaUsuarioId: Int?
    let respondida: Bool?
    let pdv : String?
    let nome : String?
    let canal : String?
    let notaRed : String?
    let ativacao : String?
    let disponibilidade : String?
    let gdm : String?
    let preco : String?
    let sovi : String?
    let mes : Int?
    let ano : Int?
    let dhp : String?
    let mesNome : String?
    let diretoria : String?
    let gerencia : String?
    let supervisao : String?
    let rotaVendedor : String?
    let curva : String?
    let uf : String?
    let municipio : String?
    let bairro : String?
    let rua : String?
    let cep : String?
    let numero : String?
    let complemento : String?
    let latitude : Double?
    let longitude : Double?

    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case de = "de"
        case ate = "ate"
        case rotinaUsuarioId = "rotinaUsuarioId"
        case respondida = "respondida"
        case pdv = "pdv"
        case nome = "nome"
        case canal = "canal"
        case notaRed = "notaRed"
        case ativacao = "ativacao"
        case disponibilidade = "disponibilidade"
        case gdm = "gdm"
        case preco = "preco"
        case sovi = "sovi"
        case mes = "mes"
        case ano = "ano"
        case dhp = "dhp"
        case mesNome = "mesNome"
        case diretoria = "diretoria"
        case gerencia = "gerencia"
        case supervisao = "supervisao"
        case rotaVendedor = "rotaVendedor"
        case curva = "curva"
        case uf = "uf"
        case municipio = "municipio"
        case bairro = "bairro"
        case rua = "rua"
        case cep = "cep"
        case numero = "numero"
        case complemento = "complemento"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
}
