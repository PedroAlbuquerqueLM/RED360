//
//  Rest.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import Alamofire

class Rest{
    
    //Api de produção
    static private let baseURL = "http://kpi.dimensiva.io/"
    class private func getHash() -> String{
        
        let hash = Date().description
        
        return hash
    }
    
    class private func getHeaders() -> HTTPHeaders{
        
        guard let idToken = appDelegate.user?.token, let uID = appDelegate.user?.uid else{
            fatalError("Erro ao tentar pegar as credenciais")
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : idToken,
            "Uid" : uID
        ]
        return headers
    }
    
    class func loadNotaPilar(onComplete: @escaping ([NotaPilar]?, AccessDenied?) -> Void){
        
        guard let user = appDelegate.user, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if nivel == 4 {
            cargo = user.diretoria != nil ? user.diretoria! : ""
            supervisao = user.supervisao != nil ? user.supervisao! : ""
        }
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : cargo , "supervisao" : supervisao] as [String : Any]
        
        let url = baseURL+"api/dashboard/nota_pilar/\(nivel).json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([NotaPilar].self, from: data)
                    print(result)
                    onComplete(result, nil)
                    
                }catch{
                    do{
                        let error = try JSONDecoder().decode(AccessDenied.self, from: data)
                        onComplete(nil, error)
                    }catch{
                        print(error.localizedDescription)
                        onComplete(nil, nil)
                    }
                }
            }
            
        }
        
    }
    
    class func loadPosicao(onComplete: @escaping (PosicaoModel?, AccessDenied?) -> Void){
        
        guard let user = appDelegate.user, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if nivel == 4 {
            cargo = user.diretoria != nil ? user.diretoria! : ""
            supervisao = user.supervisao != nil ? user.supervisao! : ""
        }
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : cargo , "supervisao" : supervisao] as [String : Any]
        
        let url = baseURL+"api/dashboard/posicao_ranking/\(nivel).json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode(PosicaoModel.self, from: data)
                    print(result)
                    onComplete(result, nil)
                    
                }catch{
                    do{
                        let error = try JSONDecoder().decode(AccessDenied.self, from: data)
                        onComplete(nil, error)
                    }catch{
                        print(error.localizedDescription)
                        onComplete(nil, nil)
                    }
                }
            }
            
        }
    }
}

