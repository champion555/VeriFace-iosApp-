//
//  IDDocMainViewController.swift
//  VeriFace
//
//  Created by Admin on 9/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ADCountryPicker
class IDDocMainViewController: UIViewController {
    @IBOutlet weak var imgMark: UIView!
    var flagImage: UIImage!
    var countryName: String!
    var dialingCode: String!
    var target: String!
    var IDDocType: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        imgMark.idDocMainDropShadow()
    }
    func configureView(){
        imgMark.layer.cornerRadius = 50
    }
    @IBAction func onBack(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onPassport(_ sender: Any) {
        IDDocType = "Passport"
        getCountryInfo()
    }
    @IBAction func onIDCard(_ sender: Any) {
        IDDocType = "IDCard"
        getCountryInfo()
    }
    @IBAction func onDrivingLicense(_ sender: Any) {
        IDDocType = "Driving"
        getCountryInfo()
    }
    @IBAction func onResidentPermit(_ sender: Any) {
        IDDocType = "Resident"
        getCountryInfo()
    }
    func getCountryInfo(){
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { name, code in
            _ = picker.navigationController?.popToRootViewController(animated: true)
            if self.flagImage != nil && self.countryName != nil{
                if self.IDDocType == "Passport" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PassportViewController") as! PassportViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if self.IDDocType == "IDCard"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if self.IDDocType == "Driving"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrivingLicenseViewController") as! DrivingLicenseViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if self.IDDocType == "Resident"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResidentPermitViewController") as! ResidentPermitViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    

}
extension UIView {
    func idDocMainDropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension IDDocMainViewController: ADCountryPickerDelegate {
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.flagImage  =  picker.getFlag(countryCode: code)
        self.countryName  =  picker.getCountryName(countryCode: code)
        self.dialingCode  =  picker.getDialCode(countryCode: code)

    }
}
