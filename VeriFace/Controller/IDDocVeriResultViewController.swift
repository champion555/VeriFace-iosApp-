//
//  IDDocVeriResultViewController.swift
//  VeriFace
//
//  Created by Admin on 9/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class IDDocVeriResultViewController: UIViewController {

    @IBOutlet weak var firstNameMark: UIImageView!
    @IBOutlet weak var txtFirstName: UILabel!
    @IBOutlet weak var lastNameMark: UIImageView!
    @IBOutlet weak var txtLastName: UILabel!
    @IBOutlet weak var birthMark: UIImageView!
    @IBOutlet weak var txtBirth: UILabel!
    @IBOutlet weak var genderMark: UIImageView!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var IDDocNumMark: UIImageView!
    @IBOutlet weak var txtIDDocNum: UILabel!
    @IBOutlet weak var IDDocTypeMark: UIImageView!
    @IBOutlet weak var txtIDDocType: UILabel!
    @IBOutlet weak var expirationMark: UIImageView!
    @IBOutlet weak var txtExpiration: UILabel!
    @IBOutlet weak var nationalityMark: UIImageView!
    @IBOutlet weak var txtNationality: UILabel!
    @IBOutlet weak var scoreMark: UIImageView!
    @IBOutlet weak var txtScore: UILabel!
    var response: IDDocVeriResponse!
    var IDDocType: String!
    var valid_score:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setVeriResponse()
    }
    private func setVeriResponse(){
        valid_score = response.valid_score
        let score = String(valid_score)
        if response.first_name == ""{
            firstNameMark.image = UIImage(named: "ic_failed")
        }else{
            firstNameMark.image = UIImage(named: "ic_success")
            txtFirstName.text = response.first_name
        }
        if response.last_name == ""{
            lastNameMark.image = UIImage(named: "ic_failed")
        }else{
            lastNameMark.image = UIImage(named: "ic_success")
            txtLastName.text = response.last_name
        }
        if response.date_of_birth == ""{
            birthMark.image = UIImage(named: "ic_failed")
        }else{
            birthMark.image = UIImage(named: "ic_success")
            txtBirth.text = response.date_of_birth
        }
        if response.sex == ""{
            genderMark.image = UIImage(named: "ic_failed")
        }else{
            genderMark.image = UIImage(named: "ic_success")
            txtGender.text = response.sex
        }
        if response.number == ""{
            IDDocNumMark.image = UIImage(named: "ic_failed")
        }else{
            IDDocNumMark.image = UIImage(named: "ic_success")
            txtIDDocNum.text = response.number
        }
        if IDDocType == ""{
            IDDocTypeMark.image = UIImage(named: "ic_failed")
        }else{
            IDDocTypeMark.image = UIImage(named: "ic_success")
            txtIDDocType.text = IDDocType
        }
        if response.expiration_date == ""{
            expirationMark.image = UIImage(named: "ic_failed")
        }else{
            expirationMark.image = UIImage(named: "ic_success")
            txtExpiration.text = response.expiration_date
        }
        if response.nationality == ""{
            nationalityMark.image = UIImage(named: "ic_failed")
        }else{
            nationalityMark.image = UIImage(named: "ic_success")
            txtNationality.text = response.nationality
        }
        if score == ""{
            scoreMark.image = UIImage(named: "ic_failed")
        }else{
            scoreMark.image = UIImage(named: "ic_success")
            txtScore.text = score
        }       
        
    }
    @IBAction func onBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDDocMainViewController") as! IDDocMainViewController
        vc.target = "IDDocVerification"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
