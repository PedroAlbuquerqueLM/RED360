//
//  LoginViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import AKMaskField
import FirebaseAuth
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfLogin: AKMaskField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    private var count = 0
    
    var vLoading = Bundle.main.loadNibNamed("VLoading", owner: self, options: nil)?.first as? VLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfLogin.delegate = self
        tfPassword.delegate = self
        btnLogin.layer.cornerRadius = 3
        tfLogin.setMask("{ddd}.{ddd}.{ddd}-{dd}", withMaskTemplate: "___.___.___-__")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func login(_ sender: UIButton) {
        if NetworkReachabilityManager()!.isReachable {
            if let vl = vLoading{
                vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
                vl.aiLoading.startAnimating()
                view.addSubview(vl)
            }
            var login: String
            var password: String
            
            login = tfLogin.text!
            login = login.replacingOccurrences(of: ".", with: "")
            login = login.replacingOccurrences(of: "-", with: "")
            
            password = tfPassword.text!
            
            
            if login.isEmpty{
                if let vl = vLoading{ vl.removeFromSuperview() }
                createAlertWith(title: "Erro", andMessage: "Insira um login válido")
                return
            }
            if password.isEmpty{
                if let vl = vLoading{ vl.removeFromSuperview() }
                createAlertWith(title: "Erro", andMessage: "Insira uma senha válida")
                return
            }
            
            self.didSelectLogIn(with: login, and: password)
        }else{
            createAlertWith(title: "Erro", andMessage: "Sem acesso a internet!")
        }
    }

    func createAlertWith(title: String, andMessage message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func didSelectLogIn(with cpf: String, and password: String) {
        UserModel(cpf: cpf, password: password).signIn { (user) in
            guard let user = user else {
                if let vl = self.vLoading{ vl.removeFromSuperview() }
                self.createAlertWith(title: "Erro", andMessage: "Login/Senha Incorretos")
                return
            }
            UserModel.getUser(email: (user.email)!) { (u) in
                appDelegate.user = u
                UserModel.getToken(completion: { (token) in
                    appDelegate.user?.token = token
                    UserModel.getMetas(cpf: user.email!) { (metas) in
                        appDelegate.user?.metas = metas
                        if let vl = self.vLoading{ vl.removeFromSuperview() }
                        ControllerManager.toMenu()
                    }
                })
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

