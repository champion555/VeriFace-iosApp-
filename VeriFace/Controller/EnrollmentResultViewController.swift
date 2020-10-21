//
//  EnrollmentResultViewController.swift
//  VeriFace
//
//  Created by Admin on 8/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EnrollmentResultViewController: UIViewController {
    @IBOutlet var backView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var resultMark: UIImageView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var txtLivnessScore: UILabel!
    @IBOutlet weak var txtResultMessage: UILabel!
    @IBOutlet weak var txtLivnessScorelb: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtScorelb: UILabel!
    @IBOutlet weak var txtScore: UILabel!
    var userEnrollment: Bool!
    var userEnrollCheck: Bool!
    var userAuthentication: Bool!
    var autheResult: Bool!
    var livnessForAuthentication: Bool!
    var score = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = score.index(score.startIndex, offsetBy: 5)
        let score_value = score.prefix(upTo: index)
        configureView()
        if userEnrollCheck == true{
            resultMark.image = UIImage(named: "ic_success")
            txtResultMessage.text = "Enrollment Successfully"
            txtLivnessScorelb.text = "Liveness Confirmed:"
            txtLivnessScore.text = "YES"
            txtScorelb.text = "Score:"
            txtScore.text = String(score_value)
            btnRetry.isHidden = true
        }
        if userEnrollCheck == false{
            resultMark.image = UIImage(named: "ic_failed")
            txtResultMessage.text = "Enrollment Failed"
            txtLivnessScorelb.text = "Liveness Confirmed:"
            txtLivnessScore.text = "NO"
            txtScorelb.text = "Score:"
            txtScore.text = String(score_value)
            btnRetry.isHidden = false
        }
        if autheResult == true {
            resultMark.image = UIImage(named: "ic_success")
            txtResultMessage.text = "Authentification Successfully"
            txtLivnessScorelb.text = "Liveness Confirmed:"
            txtScorelb.text = "Score:"
            txtScore.text = String(score_value)
            if livnessForAuthentication == true{
                txtLivnessScore.text = "YES"
            }else{
                txtLivnessScore.text = "No"
            }
            btnRetry.isHidden = true
        }
        if autheResult == false {
            resultMark.image = UIImage(named: "ic_failed")
            txtResultMessage.text = "Authentification Failed"
            txtLivnessScorelb.text = "Liveness Confirmed:"
            txtScorelb.text = "Score:"
            txtScore.text = String(score_value)
            if livnessForAuthentication == true{
                txtLivnessScore.text = "YES"
            }else{
                txtLivnessScore.text = "NO"
            }
            btnRetry.isHidden = false
        }
    }
    func configureView(){
        backView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1).withAlphaComponent(1)
        mainView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1).withAlphaComponent(1)
        txtResultMessage.font = UIFont.boldSystemFont(ofSize: 25)
        btnRetry.layer.cornerRadius = 10
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = btnRetry.frame.size
        gradientLayer.colors = [UIColor.white.cgColor,UIColor(red: 204/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1).cgColor,UIColor(red: 204/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1).withAlphaComponent(1).cgColor]
        //Use diffrent colors
        btnRetry.layer.addSublayer(gradientLayer)
        lblTitle.font = UIFont.boldSystemFont(ofSize: 25)
    }
    @IBAction func onBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onRetry(_ sender: Any) {
        if userEnrollment == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
            vc.isdetected = false
            vc.captureImage = false
            vc.userEnrollment = true
            self.navigationController?.pushViewController(vc, animated: true)
        }        
        if userAuthentication == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
            vc.recordVideo = false
            vc.userAuthentication = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
