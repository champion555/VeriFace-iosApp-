//
//  MainViewController.swift
//  VeriFace
//
//  Created by Admin on 7/28/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import KVNProgress
class MainViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btSetting: UIButton!
     @IBOutlet var uiButtons:[UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    func configureView(){
        mainView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        topBarView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        backView.backgroundColor = UIColor(red: 204/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1)
        for itembt in uiButtons{
            itembt.layer.cornerRadius = 10
            itembt.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        }
    }
    func showEnrollCheckedAlert(viewCtrl: UIViewController, title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Default action"), style: .`default`, handler: { _ in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
                vc.userEnrollment = true
                vc.isEnrolled = "true"
                self.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        viewCtrl.present(alert, animated: true, completion: nil)
    }
    @IBAction func onSetting(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onLogout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onPhotoFaceLiveness(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
        vc.photoFaceLiveness = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onUserEnrollment(_ sender: Any) {
        AuthenticationToServer()
    }
    @IBAction func onUserAuthentication(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
        vc.userAuthentication = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onFaceMatchToID(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocMainViewController") as! IDDocMainViewController
        vc.target = "FaceMatchToID"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onSanction(_ sender: Any) {
        
    }
    @IBAction func onIDVerificatioin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocMainViewController") as! IDDocMainViewController
        vc.target = "IDDocVerification"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "User Enrolled Checking...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrolled Checking Error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.faceEnrolledCheck(token: api_access_token)
            }
            
        })
    }
    private func faceEnrolledCheck(token : String){
        userEnrollCheck(urlPart: Constants.URLPart.userEnrolledCheck.rawValue, token: token, completion: { error, response in
        KVNProgress.dismiss()
        if error != nil {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Enrolled Check Error", msg: "Please try again")
        } else {
            let res = response as! [String: Any]
//            let statusCode = res["statusCode"] as! String
            let isEnrolled = res["isEnrolled"] as! Bool
            if isEnrolled == true {
                self.showEnrollCheckedAlert(viewCtrl: self, title: "User Enrollment Checked", msg: "Enrolled user is already exist. if you want to reenroll, please click OK else NO ")
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
                vc.userEnrollment = true
                vc.isEnrolled = "false"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        })
    }
    
}
