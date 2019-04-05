//
//  LibraryModel.swift
//  RED360
//
//  Created by Argo Solucoes on 22/11/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct LibraryModel : Codable {
    let id : Int?
    let nome : String?
    let urlCapa : String?
    let urlArquivo : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nome = "nome"
        case urlCapa = "urlCapa"
        case urlArquivo = "urlArquivo"
    }
}
