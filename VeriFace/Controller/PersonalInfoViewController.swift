//
//  PersonalInfoViewController.swift
//  VeriFace
//
//  Created by Admin on 8/23/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import NKVPhonePicker
class PersonalInfoViewController: UIViewController {
    @IBOutlet var uiviews: [UIView]!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNum: NKVPhonePickerTextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPhoneNum.phonePickerDelegate = self
//        txtPhoneNum.countryPickerDelegate = self
        configureView()
    }
    func configureView(){
        for viewItem in uiviews{
            viewItem.layer.borderColor = UIColor.black.cgColor
            viewItem.layer.cornerRadius = 5
            viewItem.layer.borderWidth = 0.5
        }
        btnContinue.layer.cornerRadius = 5
        let locale = Locale.current
        print(locale.regionCode! as String)
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onContinue(_ sender: Any) {
//        let firstName = txtFirstName.text!
//        let lastName = txtLastName.text!
//        let email = txtEmail.text!
//        let phoneNaumber = txtPhoneNum.text!
//        if firstName.count == 0 {
//            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter First Name")
//            return
//        }
//        if lastName.count == 0 {
//            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter Last Name")
//            return
//        }
//        if email.count == 0 {
//            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter email")
//            return
//        } else if !CommonManager.shared.isValidEmail(testStr: email) {
//            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Invalid Email")
//            return
//        }
//        if phoneNaumber.count == 0 {
//            CommonManager.shared.showAlert(viewCtrl: self, title: "Waring", msg: "Please enter Phone Number")
//            return
//        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhoneVeriViewController") as! PhoneVeriViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//extension ExampleViewController: CountriesViewControllerDelegate {
//    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
//        print("✳️ Did select country: \(country)")
//    }
//
//    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
//        print("😕")
//    }
//}
