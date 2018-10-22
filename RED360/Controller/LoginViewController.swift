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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let vl = vLoading{
            vl.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            vl.aiLoading.startAnimating()
            view.addSubview(vl)
        }
        Login.validateSession(email: nil, password: nil) { (error) in
            
            if error != nil{
                if let vl = self.vLoading{
                    vl.removeFromSuperview()
                }
            }else{
                self.goToMenu()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func goToMenu(){
        appDelegate.loadMenu()
        self.navigationController?.navigationBar.isHidden = false
        guard let slideMenu = appDelegate.slideMenuController else {return}
        present(slideMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func login(_ sender: UIButton) {
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
        
        login = "\(login)@red360.app"
        password = tfPassword.text!
        
        
        if login.isEmpty{
            createAlertWith(title: "Erro", andMessage: "Insira um login válido")
            return
        }
        if password.isEmpty{
            createAlertWith(title: "Erro", andMessage: "Insira uma senha válida")
            return
        }
        
        Login.validateSession(email: login, password: password) { (error) in
            
            
            
            if let error = error {
                
                self.createAlertWith(title: "Erro", andMessage: error.localizedDescription)
                if let vl = self.vLoading{
                    vl.removeFromSuperview()
                }
            }else{
                self.goToMenu()
            }
        }
    }

    func createAlertWith(title: String, andMessage message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

