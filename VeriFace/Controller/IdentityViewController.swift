//
//  IdentityViewController.swift
//  VeriFace
//
//  Created by Admin on 8/25/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ADCountryPicker
class IdentityViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPassport: UILabel!
    @IBOutlet weak var lblIDCard: UILabel!
    var flagImage: UIImage!
    var countryName: String!
    var dialingCode: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    func configureView(){
        lblTitle.font = UIFont.boldSystemFont(ofSize: 25)
        
    }
    @IBAction func onPassport(_ sender: Any) {
        getCountryInfo()
        
        
    }
    
    @IBAction func onIDCard(_ sender: Any) {
        getCountryInfo()
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func getCountryInfo(){
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.didSelectCountryClosure = { name, code in
            _ = picker.navigationController?.popToRootViewController(animated: true)
            if self.flagImage != nil && self.countryName != nil{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CaptureIDViewController") as! CaptureIDViewController
                vc.flagImage = self.flagImage
                vc.countryName = self.countryName
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
}
extension IdentityViewController: ADCountryPickerDelegate {
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.flagImage  =  picker.getFlag(countryCode: code)
        self.countryName  =  picker.getCountryName(countryCode: code)
        self.dialingCode  =  picker.getDialCode(countryCode: code)

    }
}
