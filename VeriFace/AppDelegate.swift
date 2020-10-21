//
//  AppDelegate.swift
//  VeriFace
//
//  Created by Admin on 7/28/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
//    public let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if UserDefaults.standard.string(forKey: Constants.AppPrefrenace.AppUrl.rawValue) == nil{
            AppUtils.savetoUserDefaults(value: Constants.Domain.BASEURL, key: Constants.AppPrefrenace.AppUrl.rawValue)
            AppUtils.savetoUserDefaults(value: "6000", key: Constants.AppPrefrenace.RecordTime.rawValue)
            AppUtils.savetoUserDefaults(value: Constants.Domain.api_key, key: Constants.AppPrefrenace.APIKey.rawValue)
            AppUtils.savetoUserDefaults(value: Constants.Domain.secret_key, key: Constants.AppPrefrenace.SecretKey.rawValue)
            AppUtils.savetoUserDefaults(value: Constants.Domain.user_name, key: Constants.AppPrefrenace.UserName.rawValue)
        }
        return true
    }
//    func configureWindow(_ viewController: UIViewController) {
//            if let window = window {
//                window.rootViewController = viewController
//                window.makeKeyAndVisible()
//            }
//    }
}

