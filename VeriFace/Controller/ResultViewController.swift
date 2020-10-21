//
//  ResultViewController.swift
//  VeriFace
//
//  Created by Admin on 7/28/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet var backView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var resultMark: UIImageView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var txtScore: UILabel!
    @IBOutlet weak var txtResultMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var photoFaceLiveness:Bool!
    var videoFaceLiveness:Bool!
    var userEnrollmentModel:EnrollmentResponse!
    var threshold: Float = 0.0
    var score: String = ""
    var isLivenessResult:Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let index = score.index(score.startIndex, offsetBy: 5)
        let score_value = score.prefix(upTo: index)
        txtScore.text = String(score_value)
        if photoFaceLiveness == true{
            if isLivenessResult == true{
                resultMark.image = UIImage(named: "ic_success")
                txtResultMessage.text = "Liveness Confirmed"
                btnRetry.isHidden = true
            }else{
                resultMark.image = UIImage(named: "ic_failed")
                txtResultMessage.text = "Spoof Detected"
                btnRetry.isHidden = false
            }
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
        if photoFaceLiveness == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceDetectionViewController") as! FaceDetectionViewController
            vc.captureImage = false
            vc.photoFaceLiveness = self.photoFaceLiveness
            vc.isdetected = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
