//
//  FaceMatchResultViewController.swift
//  VeriFace
//
//  Created by Admin on 9/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FaceMatchResultViewController: UIViewController {
    @IBOutlet weak var imgResultMark: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblScroe: UILabel!
    @IBOutlet weak var txtScore: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    var response: FaceMatchResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let score = Float(response.match_score)! / 100.0
        if score > 0.8 {
            imgResultMark.image = UIImage(named: "ic_success")
            txtScore.text = String(score)
            btnRetry.isHidden = true
        }else{
            imgResultMark.image = UIImage(named: "ic_failed")
            txtScore.text = String(score)
            btnRetry.isHidden = false
        }
        
    }
    func configureView(){
        btnRetry.layer.cornerRadius = 10
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
    }

    @IBAction func onBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocMainViewController") as! IDDocMainViewController
        vc.target = "FaceMatchToID"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
