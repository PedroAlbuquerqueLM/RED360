//
//  AppDelegate.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Firebase
import Alamofire

let appDelegate = UIApplication.shared.delegate as! AppDelegate

// Screen width.
var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var slideMenuController: SlideMenuController?
    var user: UserModel?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        initiliazeSetup(application, launchOptions)
        
        return true
    }
    
    public func initiliazeSetup(_ application: UIApplication, _ launchOptions: [UIApplicationLaunchOptionsKey : Any]?) {
        
        if !NetworkReachabilityManager()!.isReachable {
            ControllerManager.toLogin()
        }
        
        guard let user = Auth.auth().currentUser else {
            
            ControllerManager.toLogin()
            
            return
        }
        
        UserModel.getUser(email: user.email!) { (u) in
            self.user = u
            UserModel.getToken(completion: { (token) in
                self.user?.token = token
                UserModel.getMetas(cpf: user.email!) { (metas) in
                    guard let metas = metas else { self.logout(); return; }
                    self.user?.metas = metas
                    ControllerManager.toMenu()
                }
            })
        }
    }
    
    func loadMenu(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
        let menu = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        
        slideMenuController = SlideMenuController(mainViewController: main, leftMenuViewController: menu)
        
        slideMenuController?.addLeftGestures()
        SlideMenuOptions.contentViewScale = 1
    }
    
    func logout(){
        UserModel.signOut()
        appDelegate.user = nil
        ControllerManager.toLogin()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

