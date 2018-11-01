//
//  Rest.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import Alamofire

enum NotaCanalType: String {
    case total = "api/dashboard/pontuacao/canal/total/"
    case ativacao = "api/dashboard/pontuacao/canal/ativacao/"
    case disponibilidade = "api/dashboard/pontuacao/canal/disponibilidade/"
    case gdm = "api/dashboard/pontuacao/canal/gdm/"
    case preco = "api/dashboard/pontuacao/canal/preco/"
    case sovi = "api/dashboard/pontuacao/canal/sovi/"
}

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
    
    class func loadNotaPilar(user: UserModel?, onComplete: @escaping ([NotaPilarModel]?, AccessDenied?) -> Void){
        let u = user == nil ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
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
                    let result = try JSONDecoder().decode([NotaPilarModel].self, from: data)
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
    
    class func loadNotaCanal(user: UserModel?, type: NotaCanalType, onComplete: @escaping ([NotaCanalModel]?, AccessDenied?) -> Void){
        let u = user == nil ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if nivel == 4 {
            cargo = user.diretoria != nil ? user.diretoria! : ""
            supervisao = user.supervisao != nil ? user.supervisao! : ""
        }
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : cargo , "supervisao" : supervisao] as [String : Any]
        
        let url = baseURL+"\(type.rawValue)\(nivel).json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([NotaCanalModel].self, from: data)
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
    
    class func loadPosicao(user: UserModel?, onComplete: @escaping (PosicaoModel?, AccessDenied?) -> Void){
        let u = user == nil ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
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
    
    class func loadHistorico(user: UserModel?, onComplete: @escaping ([HistoricoModel]?, AccessDenied?) -> Void){
        let u = user == nil ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if nivel == 4 {
            cargo = user.diretoria != nil ? user.diretoria! : ""
            supervisao = user.supervisao != nil ? user.supervisao! : ""
        }
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : cargo , "supervisao" : supervisao] as [String : Any]
        
        let url = baseURL+"api/dashboard/historico/\(nivel).json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([HistoricoModel].self, from: data)
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
    
    class func loadIndicator(channel: String, onComplete: @escaping ([String: NotaCanalModel]?, AccessDenied?) -> Void){
        
        guard let user = appDelegate.user, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if nivel == 4 {
            cargo = user.diretoria != nil ? user.diretoria! : ""
            supervisao = user.supervisao != nil ? user.supervisao! : ""
        }
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : cargo , "supervisao" : supervisao, "canal" : channel] as [String : Any]
        
        let url = baseURL+"api/dashboard/pontuacao/canal/indicadores/\(nivel).json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([String: NotaCanalModel].self, from: data)
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
    
    class func loadMeuTime(cargoTime: String, onComplete: @escaping ([MyTeamsModel]?, AccessDenied?) -> Void){
        
        guard let user = appDelegate.user, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if nivel == 4 {
            cargo = user.diretoria != nil ? user.diretoria! : ""
            supervisao = user.supervisao != nil ? user.supervisao! : ""
        }
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : cargo , "cargoTime" : cargoTime] as [String : Any]
        
        let url = baseURL+"api/meutime/\(nivel).json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([MyTeamsModel].self, from: data)
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
