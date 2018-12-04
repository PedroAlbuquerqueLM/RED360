//
//  FirebaseAuth.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthenticable: Authenticable {
    func reauthenticate(withCredential credential: AuthCredential, completion: @escaping (_ error: Error?) -> Void)
}

extension FirebaseAuthenticable {
    
    func signIn(onComplete: @escaping (User?) -> Void) {
        guard let email = self.email else {
            return print("The email property does not exist");
        }
        guard let password = self.password else {
            return print("The password property does not exist for the user")
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let user = user {
                onComplete(user.user)
            }else{
                onComplete(nil)
                
            }
        })
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
    }

    func reauthenticate(withCredential credential: AuthCredential, completion: @escaping (_ error: Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential, completion: { (error) in
            completion(error)
        })
    }
}
