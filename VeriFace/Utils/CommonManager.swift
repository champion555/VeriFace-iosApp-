//
//  CommonManager.swift
//  VeriFace
//
//  Created by Admin on 8/13/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
class CommonManager {
    static let shared = CommonManager()
    private init() {
        print("NavManager Initialized")
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func showAlert(viewCtrl: UIViewController, title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        viewCtrl.present(alert, animated: true, completion: nil)
    }
}
