//
//  Rest.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

enum NotaCanalType: String {
    case total = "api/dashboard/pontuacao/canal/total/"
    case ativacao = "api/dashboard/pontuacao/canal/ativacao/"
    case disponibilidade = "api/dashboard/pontuacao/canal/disponibilidade/"
    case gdm = "api/dashboard/pontuacao/canal/gdm/"
    case preco = "api/dashboard/pontuacao/canal/preco/"
    case sovi = "api/dashboard/pontuacao/canal/sovi/"
}

enum PDVCompleteType: String {
    case ativacao = "api/pdv/pesquisa_ativacao.json"
    case disponibilidade = "api/pdv/pesquisa_disponibilidade.json"
    case gdm = "api/pdv/pesquisa_gdm.json"
    case preco = "api/pdv/pesquisa_preco.json"
    case sovi = "api/pdv/pesquisa_sovi.json"
}

class Rest{
    
    //Api de produção
    static private let baseURL = "https://api.red360.app/"
    class private func getHash() -> String{
        
        let hash = Date().description
        
        return hash
    }
    
    class private func getHeaders() -> HTTPHeaders{
        
        guard let idToken = appDelegate.user?.token, let uID = appDelegate.user?.uid else{
//            fatalError("Erro ao tentar pegar as credenciais")
            let headers: HTTPHeaders = [
                "Authorization" : "0",
                "Uid" : "0"
            ]
            return headers
        }
        
        let headers: HTTPHeaders = [
            "Authorization" : idToken,
            "Uid" : uID
        ]
        return headers
    }
    
    class func loadNotaPilar(user: UserModel?, onComplete: @escaping ([NotaPilarModel]?, AccessDenied?) -> Void){
        let my = (user == nil)
        let u = my ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if my {
            if nivel == 4 {
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
                supervisao = user.supervisao != nil ? user.supervisao! : ""
            }
        }else{
            switch nivel {
            case 1:
                cargo = user.diretoria != nil ? user.diretoria! : ""
            case 2:
                cargo = user.gerencia != nil ? user.gerencia! : ""
            case 3:
                cargo = user.supervisao != nil ? user.supervisao! : ""
            case 4:
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
            default:
                cargo = ""
            }
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
        let my = (user == nil)
        let u = my ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if my {
            if nivel == 4 {
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
                supervisao = user.supervisao != nil ? user.supervisao! : ""
            }
        }else{
            switch nivel {
            case 1:
                cargo = user.diretoria != nil ? user.diretoria! : ""
            case 2:
                cargo = user.gerencia != nil ? user.gerencia! : ""
            case 3:
                cargo = user.supervisao != nil ? user.supervisao! : ""
            case 4:
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
            default:
                cargo = ""
            }
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
        let my = (user == nil)
        let u = my ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if my {
            if nivel == 4 {
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
                supervisao = user.supervisao != nil ? user.supervisao! : ""
            }
        }else{
            switch nivel {
            case 1:
                cargo = user.diretoria != nil ? user.diretoria! : ""
            case 2:
                cargo = user.gerencia != nil ? user.gerencia! : ""
            case 3:
                cargo = user.supervisao != nil ? user.supervisao! : ""
            case 4:
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
            default:
                cargo = ""
            }
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
        let my = (user == nil)
        let u = my ? appDelegate.user : user
        guard let user = u, let nivel = user.nivel else {return}
        var cargo = ""
        var supervisao = ""
        if my {
            if nivel == 4 {
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
                supervisao = user.supervisao != nil ? user.supervisao! : ""
            }
        }else{
            switch nivel {
            case 1:
                cargo = user.diretoria != nil ? user.diretoria! : ""
            case 2:
                cargo = user.gerencia != nil ? user.gerencia! : ""
            case 3:
                cargo = user.supervisao != nil ? user.supervisao! : ""
            case 4:
                cargo = user.rotaVendedor != nil ? user.rotaVendedor! : ""
            default:
                cargo = ""
            }
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
    
    class func loadIndicator(channel: String, onComplete: @escaping ([String: NotaCanalModel?]?, AccessDenied?) -> Void){
        
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
                    let result = try JSONDecoder().decode([String: NotaCanalModel?].self, from: data)
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
    
    class func searchPDV(pdv: String, onComplete: @escaping (PDVModel?, AccessDenied?) -> Void){
        
        guard let user = appDelegate.user, let nivel = user.nivel else {return}
        let cargo = UserModel.getCargo()
        var supervisao = ""
        if nivel == 4 {
            supervisao = user.supervisao != nil ? user.supervisao! : ""
        }
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["pdv" : pdv, "cargo" : cargo, "supervisao" : supervisao] as [String : Any]
        
        let url = baseURL+"api/pdv/resumo/\(nivel).json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode(PDVModel.self, from: data)
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
    
    class func searchPDVOportunities(pdv: String, onComplete: @escaping ([String:[OportunitiesModel]]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["pdv" : pdv] as [String : Any]
        
        let url = baseURL+"api/pdv/oportunidades.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([String:[OportunitiesModel]].self, from: data)
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
    
    class func searchPDVComplete(pdv: String, type: PDVCompleteType, onComplete: @escaping ([PDVCompleteModel]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["pdv" : pdv] as [String : Any]
        
        let url = baseURL+type.rawValue
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any] , encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([PDVCompleteModel].self, from: data)
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
    
    class func listUF(onComplete: @escaping ([ListPDVModel]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        
        let url = baseURL+"api/uf/index.json"
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([String].self, from: data)
                    var listPDV = [ListPDVModel]()
                    result.forEach{
                        var listModel = ListPDVModel()
                        listModel.uf = $0
                        listPDV.append(listModel)
                    }
                    onComplete(listPDV, nil)
                    
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
    
    class func listCity(uf: String, onComplete: @escaping ([ListPDVModel]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["uf" : uf] as [String : Any]
        
        let url = baseURL+"api/uf/cidades.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([ListPDVModel].self, from: data)
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
    
    class func listBairro(uf: String, cidade: String, onComplete: @escaping ([ListPDVModel]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["uf" : uf, "cidade" : cidade] as [String : Any]
        
        let url = baseURL+"api/uf/bairros.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([ListPDVModel].self, from: data)
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
    
    class func listPDVS(city: String, bairro: String, completion: @escaping (_ pdvs: [ListPDVSModel]) -> Void){
        let reference = Firestore.firestore().collection("view_pdv_map").whereField("municipio", isEqualTo: city).whereField("bairro", isEqualTo: bairro)
        reference.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else { return }
            let docs = snapshot.documents
            if let error = error {
                print(error.localizedDescription)
            }
            var pdvs = [ListPDVSModel]()
            docs.forEach{
                if let pdv = ListPDVSModel.deserialize(from: $0.data()) {
                    pdvs.append(pdv)
                }
            }
            completion(pdvs)
        }
    }
    
    class func listTop(isNota: Bool, onComplete: @escaping ([ListPDVSModel]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        
        var url = baseURL+"api/pdv/melhores-notas.json"
        if !isNota { url = baseURL+"api/pdv/maiores-oportunidades.json" }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    var result = try JSONDecoder().decode([ListPDVSModel].self, from: data)
                    result.enumerated().forEach{
                        result[$0.offset].endereco = "\($0.element.rua ?? "") - \($0.element.bairro ?? "") \($0.element.municipio ?? "") \($0.element.uf ?? "")"
                    }
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
    
    class func getLibrary(onComplete: @escaping ([LibraryModel]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        
        let url = baseURL+"api/biblioteca/index.json"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([LibraryModel].self, from: data)
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
    
    class func getREDSimulado(uf: String, canal: String, curva: String, tipo: String? = "RED", onComplete: @escaping ([REDSimuladoModel]?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        
        let url = baseURL+"api/pergunta/\(uf)/\(canal.replacingOccurrences(of: " ", with: "%20"))/\(curva)/\(tipo!).json"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([REDSimuladoModel].self, from: data)
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
    
    class func saveSaveREDSimulado(pesquisaSimulada: PesquisaSimuladaModel, perguntas: [PerguntaModel], onComplete: @escaping (Bool?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        
        let url = baseURL+"api/red_simulado/cadastro.json"
        
        do{
            var perguntasDic = [[String:Any]]()
            for pergunta in perguntas {
                perguntasDic.append(try pergunta.asDictionary())
            }
            let pesquisaDic = try pesquisaSimulada.asDictionary()
            let parameters = ["pesquisaSimulada" : pesquisaDic, "perguntas" : perguntasDic] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: Alamofire.JSONEncoding.default, headers: headers).responseJSON { (response) in
                onComplete(true, nil)
            }
        }catch{
            print(error.localizedDescription)
            onComplete(false, nil)
        }
    }
}
