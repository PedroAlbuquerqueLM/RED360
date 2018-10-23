//
//  UserModel.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import Firebase
import HandyJSON
import CoreLocation
import PromiseKit

class ProfileImageViewManager {
    static var profileImageView: UIImageView?
    static var changeProfileImageView: UIImageView?
    static var photoURL: String?
}

struct UserModel: ModelType, HandyJSON, FirebaseAuthenticable {
    
    typealias Model = User
    
    var email: String?
    var password: String?
    var cpf: String?
    var diretoria: String?
    var gerencia: String?
    var id: Int?
    var nivel: Int?
    var nome: String?
    var regional: UIImage?
    var rotaVendedor: String?
    var supervisao: String?
    var uid: String?
    var token: String?
    
    init(cpf: String?, password: String?) {
        guard let cpf = cpf else {return}
        self.email = "\(cpf)@red360.app"
        self.password = password
    }
    
    init(cpf: String?) {
        self.cpf = cpf
    }
    
    init() {}
    
    func validateProperties() -> Bool {
        
        return true
    }
    mutating func mapping(mapper: HelpingMapper) {
        
    }
    
    static func getUser(email: String, completion: @escaping (_ user: UserModel) -> Void){
        let cpf = email.replacingOccurrences(of: "@red360.app", with: "")
        let reference = Firestore.firestore().collection("users").document(cpf)
        reference.addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            if snapshot.exists {
                if let error = error {
                    print(error.localizedDescription)
                }
                let json = snapshot.data()
                completion(UserModel.deserialize(from: json)!)
            }
        }
    }
    
    static func getToken(completion: @escaping (_ token: String) -> Void) {
        if let user = Auth.auth().currentUser {
            user.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                guard let token = idToken else {return}
                completion(token)
            })
        }
    }
}

public protocol ModelType {
    var entityName: Self.Type { get }
    static var modelName: String { get }
    var uid: String? { get set }
}
public protocol SubCollectionType {
    var subCollectionName: SubCollectionType.Type  { get }
    var key: String? { get set }
    
}
extension SubCollectionType {
    var subCollectionName: SubCollectionType.Type {
        return type(of: self)
    }
    static var entitySubCollectionName: String{
        return String(describing: self)
    }
    
    
}

extension ModelType {
    var entityName: Self.Type {
        return type(of: self)
    }
    static var modelName: String {
        return String(describing: self)
    }
}


