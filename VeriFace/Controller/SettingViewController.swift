//
//  SettingViewController.swift
//  VeriFace
//
//  Created by Admin on 7/28/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet var backView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var presentView: UIView!
    @IBOutlet var uiViews: [UIView]!
    @IBOutlet weak var txtBaseURL: UITextField!
    @IBOutlet weak var txtVideoDuration: UITextField!
    @IBOutlet weak var txtAPIKey: UITextField!
    @IBOutlet weak var txtAPISecretKey: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        txtBaseURL.text = AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue)
        txtAPIKey.text = AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue)
        txtAPISecretKey.text = AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue)
        txtVideoDuration.text = AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.RecordTime.rawValue)
        configureView()
        txtUserName.text = AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.UserName.rawValue)

    }
    func configureView(){
        backView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        mainView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        topBarView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        presentView.backgroundColor = UIColor(red: 204/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1)
        for itemView in uiViews{
            itemView.layer.cornerRadius = 5
            itemView.backgroundColor = UIColor(red: 204/255.0, green: 148/255.0, blue: 255/255.0, alpha: 1)
            itemView.layer.borderWidth = 1
            itemView.layer.borderColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1).cgColor
        }
        btSave.layer.cornerRadius = 10               
    }
    @IBAction func onSave(_ sender: Any) {
        AppUtils.savetoUserDefaults(value: txtBaseURL.text ?? Constants.Domain.BASEURL, key: Constants.AppPrefrenace.AppUrl.rawValue)
        AppUtils.savetoUserDefaults(value: txtAPIKey.text ?? Constants.Domain.api_key, key: Constants.AppPrefrenace.APIKey.rawValue)
        AppUtils.savetoUserDefaults(value: txtAPISecretKey.text ?? Constants.Domain.secret_key, key: Constants.AppPrefrenace.SecretKey.rawValue)
        AppUtils.savetoUserDefaults(value: txtVideoDuration.text ?? "6000", key: Constants.AppPrefrenace.RecordTime.rawValue)
        AppUtils.savetoUserDefaults(value: txtUserName.text ?? Constants.Domain.user_name, key: Constants.AppPrefrenace.UserName.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
