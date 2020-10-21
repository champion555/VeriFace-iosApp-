//
//  DrivingLicenseViewController.swift
//  VeriFace
//
//  Created by Admin on 9/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import KVNProgress
class DrivingLicenseViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFrontDriving: UIImageView!
    @IBOutlet weak var lblFrontText: UILabel!
    @IBOutlet weak var imgBackDriving: UIImageView!
    @IBOutlet weak var lblBackText: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnVerification: UIButton!
    var target: String!
    var mergedDrivingUri: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if target == "FaceMatchToID" {
            lblTitle.text = "Face Match Driving"
            btnVerification.isHidden = true
        }else if target == "IDDocVerification"{
            lblTitle.text = "Driving Verificaton"
            btnContinue.isHidden = true
        }
        
        let frontDrivingPath = Constants.FrontDrivingPath
        let backDrivingPath = Constants.BackDrivingPath
        if frontDrivingPath == "" {
            imgFrontDriving.image = UIImage(named: "ic_license_front")
            lblFrontText.text = "Capture Front of Driving License"
        }else {
            let url = URL(string: frontDrivingPath)
            if url != nil {
                if let imgData = try? Data(contentsOf: url!) {
                    let frontDrivingimage = UIImage(data: imgData)
                    imgFrontDriving.image = frontDrivingimage
                    lblFrontText.text = "Edit Front of Driving License"
                }
            }
            
        }
        if backDrivingPath == "" {
            imgBackDriving.image = UIImage(named: "ic_license_back")
            lblBackText.text = "Capture Back of Driving License"
        }else {
            let url = URL(string: backDrivingPath)
            if url != nil {
                if let imgData = try? Data(contentsOf: url!) {
                    let backDrivingimage = UIImage(data: imgData)
                    imgBackDriving.image = backDrivingimage
                    lblBackText.text = "Edit Back of Driving License"
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
    
    @IBAction func onFrontCapture(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.IdType = "FrontDriving"
        vc.target = self.target
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onBackCapture(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.IdType = "BackDriving"
        vc.target = self.target
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onContinue(_ sender: Any) {
        mergeImage()
    }
    @IBAction func onVerification(_ sender: Any) {
        mergeImage()
    }
    private func mergeImage(){
        let topImage = imgFrontDriving.image
        let bottomImage = imgBackDriving.image
        let size = CGSize(width: topImage!.size.width, height: topImage!.size.height + bottomImage!.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        topImage?.draw(in: CGRect(x: 0, y: 0, width:size.width, height: size.height/2))
        bottomImage?.draw(in: CGRect(x:0, y: size.height/2, width:size.width, height: size.height/2))
        let mergedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "mergedDrivingIamge.jpg"
        mergedDrivingUri = documentsDirectory.appendingPathComponent(fileName)
        let data = mergedImage.jpegData(compressionQuality:  1.0)
        if !FileManager.default.fileExists(atPath: mergedDrivingUri.path) {
            do {
                try data!.write(to: mergedDrivingUri)
                print("file saved")
                if target == "FaceMatchToID" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
                    vc.faceMatchToID = true
                    vc.IDDocUri = mergedDrivingUri
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if target == "IDDocVerification"{
                    self.AuthenticationToServer()
                }
            } catch {
                print("error saving file:", error)
            }
        }else{
            do {
                try FileManager.default.removeItem(at: mergedDrivingUri)
                print("Remove successfully")
                do {
                    try data!.write(to: mergedDrivingUri)
                    print("file saved")
                    if target == "FaceMatchToID" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
                        vc.faceMatchToID = true
                        vc.IDDocUri = mergedDrivingUri
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if target == "IDDocVerification"{
                        self.AuthenticationToServer()
                    }
                } catch {
                    print("error saving file:", error)
                }
            }
            catch let error as NSError {
                print("error deleting file:", error)
            }
        }
        
        
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "Verify Driving License...", on: view)
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
        IDDocVerification(urlPart: Constants.URLPart.IDVerify.rawValue, token: token, IDDocPath: mergedDrivingUri, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "ID Card verification is failed. please try again")
            }else{
                let res = response as! [String: Any]
                let status = res["status"] as! String
                if status == "SUCCESS"{
                    let IDDocRes = IDDocVeriResponse(dict: res)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocVeriResultViewController") as! IDDocVeriResultViewController
                    vc.IDDocType = "Driving License"
                    vc.response = IDDocRes
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "Bad input MRZ image!")
                    
                }
                
            }
        })
    }
    
}
