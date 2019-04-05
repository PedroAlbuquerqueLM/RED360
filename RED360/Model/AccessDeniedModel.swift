//
//  AccessDenied.swift
//  RED360
//
//  Created by Argo Solucoes on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation

struct AccessDenied: Codable {
    
    let timestamp : String?
    let status : Int?
    let error : String?
    let message : String?
    let path : String?
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "timestamp"
        case status = "status"
        case error = "error"
        case message = "message"
        case path = "path"
    }
}
