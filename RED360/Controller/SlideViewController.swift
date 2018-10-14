//
//  SlideViewController.swift
//  RED360
//
//  Created by Pedro Albuquerque on 10/10/18.
//  Copyright © 2018 com.dimensiva.tecnologia.red360.app. All rights reserved.
//

import UIKit
import SnapKit

class SlideViewController: UIViewController {
    
    private var navItem: UINavigationItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 20))
        topView.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.2196078431, blue: 0.2274509804, alpha: 1)
        
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let topPadding = window?.safeAreaInsets.top
                make.height.equalTo(20)
            }
        }
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: 375, height: 44))
        navBar.barTintColor = #colorLiteral(red: 0.8549019608, green: 0.2196078431, blue: 0.2274509804, alpha: 1)
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        self.view.addSubview(navBar)
        
        navBar.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let topPadding = window?.safeAreaInsets.top
                make.top.equalTo(20)
            }
        }
        
        self.navItem = UINavigationItem(title: "");
        
        let doneItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"), style: .done, target: nil, action: #selector(menuAction))
        doneItem.tintColor = UIColor.white

        self.navItem?.leftBarButtonItem = doneItem;
        
        navBar.setItems([navItem!], animated: false);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func menuAction() {
        self.slideMenuController()?.openLeft()
    }
    
    func setTitle(_ title: String){
        self.navItem?.title = title
    }
    
}
