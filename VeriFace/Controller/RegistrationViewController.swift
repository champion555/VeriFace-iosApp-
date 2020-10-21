//
//  RegistrationViewController.swift
//  VeriFace
//
//  Created by Admin on 9/21/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import NKVPhonePicker
import ADCountryPicker
import KVNProgress
import Foundation
class RegistrationViewController: UIViewController {
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet var uiViews : [UIView]!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNum: NKVPhonePickerTextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var IndustryDropDown: DropDown!
    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtconfirmPassword: UITextField!
    var unchecked = true
    var flagImage: UIImage!
    var countryName: String!
    var dialingCode: String!
    var ischecked:Bool = false
    var firstName: String!
    var lastName: String!
    var email: String!
    var phone: String!
    var companyName: String!
    var industryType: String!
    var jobTitle: String!
    var password: String!
    var confirmPassword: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        IndustryDropDown.tag = 300
        txtPhoneNum.phonePickerDelegate = self
        configureView()
        dropDownInit()
        btnContinue.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 203/255.0, alpha: 1)
    }
    func dropDownInit(){
        IndustryDropDown.optionArray = ["aaa","bbb","ccc","ddd","fff","ggg","hhh"]
//        dropdata.selectValue(index: 0)
        IndustryDropDown.didSelect(completion: {selectedText, index, id in
        print(selectedText, index, id)
        let date = selectedText.lowercased()
        print("date:\(date)")
        })
        IndustryDropDown.delegate = self
    }
    func configureView(){
        for viewItem in uiViews{
            viewItem.layer.cornerRadius = 5
            viewItem.layer.borderWidth = 1
            viewItem.layer.borderColor = UIColor.gray.cgColor
        }
        btnContinue.layer.cornerRadius = 10
    }
    func getCountryInfo(){
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { name, code in
            _ = picker.navigationController?.popToRootViewController(animated: true)
            if self.flagImage != nil && self.countryName != nil{
                self.imgFlag.image = self.flagImage
                self.txtCountry.text = self.countryName
                
            }
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    

    @IBAction func onCheck(_ sender: Any) {
        if unchecked {
            btnCheck.setImage(UIImage(named:"ic_checked.png"), for: .normal)
            btnContinue.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
            unchecked = false
            ischecked = true
        }else {
            btnCheck.setImage( UIImage(named:"ic_uncheck.png"), for: .normal)
            unchecked = true
            ischecked = false
            btnContinue.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 203/255.0, alpha: 1)
        }
    }
    @IBAction func onSelectCountry(_ sender: Any) {
        getCountryInfo()
    }
    @IBAction func onContinue(_ sender: Any) {
        firstName = txtFirstName.text!
        lastName = txtLastName.text!
        email = txtEmail.text!
        phone = "+" + txtPhoneNum.text!
        companyName = txtCompanyName.text!
        industryType = IndustryDropDown.text!
        jobTitle = txtJobTitle.text!
        password = txtPassword.text!
        confirmPassword = txtconfirmPassword.text!
        if firstName.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter first name")
            return
        }
        if lastName.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter last name")
            return
        }
        if email.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter email")
            return
        } else if !CommonManager.shared.isValidEmail(testStr: email) {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Invalid Email")
            return
        }
        if phone.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter phone number")
            return
        }
        let result = email.split(separator: "@")
        let part = result[1]
        let result1 = part.split(separator: ".")
        let company = result1[0]
        if companyName.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter company name")
            return
        }else if company != companyName{
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter Work Business Email. ex: username@companyname.com")
            return
        }
        if countryName.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please select country name")
            return
        }
        if industryType.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please select industry type")
            return
        }
        if jobTitle.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Warning", msg: "Please enter job title")
            return
        }
        if password.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Please enter password")
            return
        } else if password.count < 6 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Password should be minimum 6 characters")
            return
        }
        if confirmPassword.count == 0 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Please enter confirm password")
            return
        }else if confirmPassword.count < 6 {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Password should be minimum 6 characters")
            return
        }
        if ischecked == false {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Please accept general condition and policy")
            return
        }
        if password == confirmPassword {
            AuthenticationToServer()
        }else{
            CommonManager.shared.showAlert(viewCtrl: self, title: "Reminder", msg: "Confirm password error, please try again")
        }
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func AuthenticationToServer(){
        KVNProgress.show(withStatus: "Registering...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrolled Checking Error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.RegisterToServer(token: api_access_token)
            }
            
        })
    }
    private func RegisterToServer(token : String){
        registerInfo(urlPart: Constants.URLPart.registerInfo.rawValue, token: token, firstName: firstName, lastName: lastName, phone: phone, company: companyName, country: countryName, industry: industryType, job: jobTitle, password: password, email: email, completion: { error, response in
        if error != nil {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Send Email error", msg: "Please try again")
        } else {
            let res = response as! [String: Any]
            let statusCode = res["statusCode"] as! String
            if statusCode == "200"{
                self.sendMailToServer(token: token)
            }else{
                KVNProgress.dismiss()
                CommonManager.shared.showAlert(viewCtrl: self, title: "Sending Email is failed", msg: "Please try again")
            }
        }
        })
    }
    private func sendMailToServer(token : String){
        let language = "en"
        sendMail(urlPart: Constants.URLPart.sendMailOtp.rawValue, token: token,language: language,email: email, completion: { error, response in
        KVNProgress.dismiss()
        if error != nil {
            CommonManager.shared.showAlert(viewCtrl: self, title: "Send Email error", msg: "Please try again")
        } else {
            let res = response as! [String: Any]
            let statusCode = res["statusCode"] as! String
            let jobId = res["job_id"] as! String
            if statusCode == "200"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailVeriViewController") as! EmailVeriViewController
                vc.email = self.email
                vc.jobId = jobId
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Sending Email is failed", msg: "Please try again")
            }
        }
        })
    }
}

extension RegistrationViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 300 {
            IndustryDropDown.isSelected ? IndustryDropDown.hideList(): IndustryDropDown.showList()
            return false
        }
        return true
    }
}
extension RegistrationViewController: ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.flagImage  =  picker.getFlag(countryCode: code)
        self.countryName  =  picker.getCountryName(countryCode: code)
        self.dialingCode  =  picker.getDialCode(countryCode: code)
    }
}
