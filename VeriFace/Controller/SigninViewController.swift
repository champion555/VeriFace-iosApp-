//
//  SigninViewController.swift
//  VeriFace
//
//  Created by Admin on 9/21/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import KVNProgress
class SigninViewController: UIViewController {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var email: String!
    var password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginVC = SigninViewController()
//        appDelegate.configureWindow(loginVC)
        Timer.scheduledTimer(withTimeInterval:30 * 60, repeats: true) { (t) in
            self.navigationController?.popToRootViewController(animated: true)
            print("time")
        }
        configureView()
        if UserDefaults.standard.bool(forKey: "isloggedin") == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func configureView(){
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor.gray.cgColor
        emailView.layer.cornerRadius = 5
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.gray.cgColor
        passwordView.layer.cornerRadius = 5
        btnSignin.layer.cornerRadius = 10
        btnCreate.layer.cornerRadius = 10
        
    }
    @IBAction func onSignin(_ sender: Any) {
        email = txtEmail.text
        password = txtPassword.text
        if email.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter email")
            return
        } else if !CommonManager.shared.isValidEmail(testStr: email) {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Invalid Email")
            return
        }
        if password.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Please enter password")
            return
        } else if password.count < 6 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Password should be minimum 6 characters")
            return
        }
        AuthenticationToServer()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onCreate(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "Signin...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrolled Checking Error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.signinToServer(token: api_access_token)
            }
            
        })
    }
    private func signinToServer(token : String){
        login(urlPart: Constants.URLPart.signin.rawValue, token: token,email: email,password: password, completion: { error, response in
        KVNProgress.dismiss()
        if error != nil {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Send Email error", msg: "Please try again")
        } else {
            let res = response as! [String: Any]
            let status = res["status"] as! String
            if status == "SUCCESS"{
                UserDefaults.standard.set(true, forKey: "isloggedin")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Sending Email is failed", msg: "Please try again")
            }
        }
        })
    }
    
}
