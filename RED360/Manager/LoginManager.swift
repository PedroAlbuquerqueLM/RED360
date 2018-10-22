//
//  LoginManager.swift
//  RED360
//
//  Created by Pedro Albuquerque on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import Foundation
import FirebaseAuth

enum LoginError: Error {
    case userError(reason: String)
    case credentialsExpired((String))
    
    
}


class Login{
    
    private static let uIDKey = "uID"
    private static let idTokenKey = "idToken"
    private static let idKey = "idKey"
    private static let defaults = UserDefaults.standard
    
    class func validateSession(email: String?, password: String?, onError: @escaping (Error?) -> Void) {
        var user: User?
        if let email = email, let password = password{
            print("Valores não nil")
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if let error = error{
                    print("On error")
                    print(error)
                    onError(error)
                }else{
                    print("Sem On error")
                    user = result?.user
                }
                if let user = user{
                    print(user)
                    user.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                        if let error = error{
                            onError(error)
                        }else{
                            if let idToken = idToken{
                                print("Vem pra ca 1")
                                updateCredentials(uID: user.uid, idToken: idToken)
                                onError(nil)
                            }
                        }
                    })
                }else{
                    print("Necas de user...")
                    let error = LoginError.userError(reason: "Usuário não encontrado")
                    print(error.localizedDescription)
                    onError(error)
                    
                }
                
                
            }
        }else{
            print("Chega e vem pra ca")
            user = Auth.auth().currentUser
            
            if let user = user{
                print(user)
                user.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                    if let error = error{
                        onError(error)
                    }else{
                        if let idToken = idToken{
                            print("Vem pra ca 2")
                            updateCredentials(uID: user.uid, idToken: idToken)
                            onError(nil)
                        }
                    }
                })
            }else{
                print("Necas de user...")
                let error = LoginError.userError(reason: "Usuário não encontrado")
                print(error.localizedDescription)
                onError(error)
                
            }
            
        }
    }
    
    
    class func removeCredentials(){
        defaults.removeObject(forKey: uIDKey)
        defaults.removeObject(forKey: idTokenKey)
        defaults.removeObject(forKey: idKey)
    }
    
    class func signOut(onError: @escaping (Error?) -> Void){
        do{
            try Auth.auth().signOut()
            removeCredentials()
            onError(nil)
        }catch{
            onError(error)
        }
    }
    
    class func hasSession() -> Bool{
        return defaults.object(forKey: uIDKey) != nil
    }
    
    private class func updateCredentials(uID: String, idToken: String){
        defaults.set(uID, forKey: uIDKey)
        defaults.set(idToken, forKey: idTokenKey)
    }
    
    class func saveUserId(_ id: Int){
        defaults.set(id, forKey: idKey)
    }
    
}

