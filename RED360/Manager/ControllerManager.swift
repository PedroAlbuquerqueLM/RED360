//
//  ControllerManager.swift
//  RED360
//
//  Created by Argo Solucoes on 22/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit

struct ControllerManager {
    
    static let sharedInstance = ControllerManager()
    static weak var root: UIViewController?
    static var values: [String : Any]?
    
    static func toLogin(){
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withClass: LoginViewController.self)
        ControllerManager.sharedInstance.setupRootViewController(withClass: LoginViewController.self, viewController: viewController, typeTransition: .showHideTransitionViews)
    }
    
    static func toMenu(){
        appDelegate.loadMenu()
        ControllerManager.sharedInstance.setupRootViewController(withClass: UITabBarController.self, viewController: appDelegate.slideMenuController, typeTransition: .showHideTransitionViews)
    }
    
    func setupRootViewController<T: UIViewController>(withClass class: T.Type , viewController: UIViewController?, typeTransition: UIViewAnimationOptions, values: [String : Any]? = nil) {
        ControllerManager.values = values
        
        guard let window = appDelegate.window else { print("Window does not exist"); return}
        
        UIView.transition(with: window, duration: 0.5, options: typeTransition, animations: {
            if let vc = viewController {
                appDelegate.window?.rootViewController = vc
            }
        })
    }
    
    func getInstanceAppDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate ?? AppDelegate()
    }
    
    func getController(_ identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return viewController
    }
}
extension UIStoryboard {
    public func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> UIViewController? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
}
