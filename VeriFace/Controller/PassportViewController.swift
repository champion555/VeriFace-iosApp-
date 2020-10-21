//
//  PassportViewController.swift
//  VeriFace
//
//  Created by Admin on 9/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import KVNProgress
class PassportViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgPassport: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnVerification: UIButton!
    var target: String!
    var passportUri:URL!
    var passportPath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if target == "FaceMatchToID" {
            lblTitle.text = "Face Match Passport"
            btnVerification.isHidden = true
        }else if target == "IDDocVerification"{
            lblTitle.text = "Passport Verificaton"
            btnContinue.isHidden = true
        }
        passportPath = Constants.passportPath
        if passportPath == "" {
            imgPassport.image = UIImage(named: "ic_passport-1")
            lblText.text = "Capture the Passport"
        }else {
            let url = URL(string: passportPath)
            if url != nil {
                if let imgData = try? Data(contentsOf: url!) {
                    let image = UIImage(data: imgData)
                    imgPassport.image = image
                    lblText.text = "Edit Passport"
                }
            }
        }
    }
    func configureView(){
        btnContinue.layer.cornerRadius = 10
        btnVerification.layer.cornerRadius = 10
    }
    @IBAction func onBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocMainViewController") as! IDDocMainViewController
        vc.target = self.target
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onPassportCapture(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.IdType = "Passport"
        vc.target = self.target
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onContinue(_ sender: Any) {
        passportUri = NSURL(string: passportPath) as URL?
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
        vc.faceMatchToID = true
        vc.IDDocUri = passportUri
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onVerification(_ sender: Any) {
        AuthenticationToServer()
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "Verify passport...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrolled Checking Error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.verifyIDDocToServer(token: api_access_token)
            }
            
        })
    }
    private func verifyIDDocToServer(token : String){
        passportUri = NSURL(string: passportPath) as URL?
        IDDocVerification(urlPart: Constants.URLPart.IDVerify.rawValue, token: token, IDDocPath: passportUri, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "Passport verification is failed. please try again")
            }else{
                let res = response as! [String: Any]
                let status = res["status"] as! String
                if status == "SUCCESS"{
                    let IDDocRes = IDDocVeriResponse(dict: res)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocVeriResultViewController") as! IDDocVeriResultViewController
                    vc.IDDocType = "Passport"
                    vc.response = IDDocRes
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "Bad input MRZ image!")
                }
                
            }
        })
    }
    
}
