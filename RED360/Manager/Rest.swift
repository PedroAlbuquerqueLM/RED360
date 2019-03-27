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
import CoreLocation

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
    
    class private func getHeaders(isMultipart: Bool? = false) -> HTTPHeaders{
        
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
        
        let headersMultipart: HTTPHeaders = [
            "Authorization" : idToken,
            "Uid" : uID,
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data"
        ]
        
        return (isMultipart ?? false) ?  headersMultipart : headers
    }
    
    class func loadNotaPilar(user: UserModel?, onComplete: @escaping ([NotaPilarModel]?, AccessDenied?) -> Void){
        let u = (user == nil) ? appDelegate.user : user
        guard let user = u, let nivel = user.cargoId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : user.cargo ?? "" , "supervisao" : user.cargoSuperior ?? ""] as [String : Any]
        
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
        let u = (user == nil) ? appDelegate.user : user
        guard let user = u, let nivel = user.cargoId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : user.cargo ?? "" , "supervisao" : user.cargoSuperior ?? ""] as [String : Any]
        
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
        let u = (user == nil) ? appDelegate.user : user
        guard let user = u, let nivel = user.cargoId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : user.cargo ?? "" , "supervisao" : user.cargoSuperior ?? ""] as [String : Any]
        
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
        let u = (user == nil) ? appDelegate.user : user
        guard let user = u else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : u?.cargo ?? "" , "supervisao" : u?.cargoSuperior ?? "", "cpf" : user.cpf!] as [String : Any]
        
        let url = baseURL+"api/dashboard/v4/historico/\(u?.cargoId ?? 0).json"
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
        
        guard let user = appDelegate.user, let nivel = user.cargoId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : user.cargo ?? "" , "supervisao" : user.cargoSuperior ?? "", "canal" : channel] as [String : Any]
        
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
        
        guard let user = appDelegate.user else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cargo" : user.cargo ?? "", "cargoTime" : cargoTime] as [String : Any]
        
        let url = baseURL+"api/meutime/v2/\(user.cargoId ?? 0).json"
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
        
        guard let user = appDelegate.user, let nivel = user.cargoId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["pdv" : pdv, "cargo" : user.cargo ?? "", "supervisao" : user.cargoSuperior ?? ""] as [String : Any]
        
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
        
        guard let user = appDelegate.user else {return}
        let headers: HTTPHeaders = getHeaders()
        
        var url = baseURL+"api/pdv/v2/melhores-notas.json"
        if !isNota { url = baseURL+"api/pdv/v2/maiores-oportunidades.json" }
        
        let parameters = ["cargoId" : user.cargoId ?? "", "cargo" : user.cargo ?? "", "cargoSuperior" : user.cargoSuperior ?? ""] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters as [String : Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
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
        
        let url = baseURL+"api/red_simulado/v2/cadastro.json"
        
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
    
    class func uploadImages(isRedSimulado: Bool? = true, token: String, images: [UIImage], onComplete: @escaping () -> Void){
        
        let headers: HTTPHeaders = getHeaders(isMultipart: true)
        var url = baseURL+"api/red_simulado/\(token)/upload-fotos.json"
        if (isRedSimulado ?? true) == false {
            url = baseURL+"api/rotina/\(token)/upload-fotos.json"
        }

        var imgData = [Data]()
        images.forEach{
            if let imageData = UIImageJPEGRepresentation($0, 0.5) {
                imgData.append(imageData)
            }
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index, value) in imgData.enumerated()
            {
                multipartFormData.append(value, withName: "\(token)\(index)", fileName: "\(token)\(index).jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold:UInt64.init(),
           to: url, //URL Here
            method: .post,
            headers: headers, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    print("the status code is :")
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("something")
                    })
                    
                    upload.responseString { response in
                        print("the resopnse code is : \(response.response?.statusCode)")
                        print("the response is : \(response)")
                        onComplete()
                    }
                    break
                case .failure(let encodingError):
                    print("the error is  : \(encodingError.localizedDescription)")
                    onComplete()
                    break
                }
        })
    }
    
    
    
    class func listRoutes(onComplete: @escaping ([ListRouteModel]?, AccessDenied?) -> Void){
        guard let cpf = appDelegate.user?.cpf else {return}
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["cpf" : cpf] as [String : Any]
        
        let url = baseURL+"api/pdv/minha-rota-usuario.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([ListRouteModel].self, from: data)
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
    
    class func listGerentes(rotinaId: Int?, onComplete: @escaping ([ListGerentesModel]?, AccessDenied?) -> Void){
        guard let user = appDelegate.user, let cargoId = user.cargoId, let rotinaId = rotinaId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["rotinaId" : rotinaId, "cargoId" : cargoId] as [String : Any]
        
        let url = baseURL+"api/pdv/estrutura-rotina.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([ListGerentesModel].self, from: data)
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
    
    
    class func listRoutesPDV(rotinaId: Int?, onComplete: @escaping ([PDVModel]?, AccessDenied?) -> Void){
        guard let user = appDelegate.user, let cpf = user.cpf, let rotinaId = rotinaId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["rotinaId" : rotinaId, "cpf" : cpf] as [String : Any]
        
        let url = baseURL+"api/pdv/minha-rota/rotinas.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([PDVModel].self, from: data)
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
    
    class func listRoutesStructPDV(rotinaId: Int?, rota: String?, onComplete: @escaping ([PDVModel]?, AccessDenied?) -> Void){
        guard let user = appDelegate.user, let cpf = user.cpf, let rotinaId = rotinaId, let rota = rota, let cargoId = user.cargoId else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["rotinaId" : rotinaId, "cpf" : cpf, "rota" : rota, "cargoId" : cargoId] as [String : Any]
        
        let url = baseURL+"api/pdv/estrutura-rotina/pdvs.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([PDVModel].self, from: data)
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
    
    class func listRotines(pdv: String?, onComplete: @escaping ([RotinesModel]?, AccessDenied?) -> Void){
        guard let pdv = pdv else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["pdv" : pdv] as [String : Any]
        
        let url = baseURL+"api/pdv/rotinas.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([RotinesModel].self, from: data)
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
    
    class func listQuizz(rotine: RotinesModel?, onComplete: @escaping ([QuizzModel]?, AccessDenied?) -> Void){
        guard let tipo = rotine?.rotina else {return}
        
        let headers: HTTPHeaders = getHeaders()
        let parameters = ["tipo" : tipo] as [String : Any]
        
        let url = baseURL+"api/rotina/perguntas.json"
        Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let data = response.data{
                do{
                    let result = try JSONDecoder().decode([QuizzModel].self, from: data)
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
    
    class func saveRotine(pdv: String, quizzes: [QuizzModel], location: CLLocationCoordinate2D, obs: String, rotine: RotinesModel, onComplete: @escaping (Bool?, AccessDenied?) -> Void){
        
        let headers: HTTPHeaders = getHeaders()
        let url = baseURL+"api/rotina/v2/cadastrar.json"
        
        guard let rotineId = rotine.id, let rotineUserId = rotine.rotinaUsuarioId else {return}
        
        do{
            let quizzDic = ["pdv" : pdv, "id" : rotineId, "rotinaUsuarioId" : rotineUserId, "pesquisador" : appDelegate.user?.nome ?? "", "dhi" : Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"), "latitude" : location.latitude, "longitude" : location.longitude, "obs" : obs] as [String : Any]
            
            var answerArray = [[String : Any]]()
            for quizz in quizzes {
                for answer in quizz.perguntas! {
                    var answerDic = try answer.asDictionary()
                    answerDic["respostaId"] = answer.respostaId
                    answerDic.removeValue(forKey: "respostas")
                    answerArray.append(answerDic)
                }
            }
            
            let parameters = ["rotinaPdv" : quizzDic, "perguntas" : answerArray] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: parameters as [String: Any], encoding: Alamofire.JSONEncoding.default, headers: headers).responseJSON { (response) in
                onComplete(true, nil)
            }
        }catch{
            print(error.localizedDescription)
            onComplete(false, nil)
        }
    }
}
