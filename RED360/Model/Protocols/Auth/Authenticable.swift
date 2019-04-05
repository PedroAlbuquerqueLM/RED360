//
//  Authenticable.swift
//  Bookinder
//
//  Created by Argo Solucoes on 06/06/18.
//  Copyright © 2018 Argo Solucoes. All rights reserved.
//

import PromiseKit
import FirebaseAuth
import Foundation

protocol AuthType {}

protocol Authenticable: AuthType {
    
    var email: String? { get }
    var password: String? { get }
    
    associatedtype Model: User
    
    static func signOut()
}
extension Authenticable {
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Could not signOut")
        }
    }
    func reauthenticate(withCredential credential: AuthCredential, completion: @escaping (_ error: Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential, completion: { (error) in
            completion(error)
        })
    }
}
