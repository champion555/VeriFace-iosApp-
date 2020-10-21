//
//  CaptureIDViewController.swift
//  VeriFace
//
//  Created by Admin on 8/26/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CaptureIDViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var flagImage: UIImage!
    var countryName: String!
    var isFrontCaptured: Bool = false
    var isBackCaptured: Bool = false
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var viewFront: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var imgFrontID: UIImageView!
    @IBOutlet weak var imgBackID: UIImageView!
    @IBOutlet weak var imgFrontCamera: UIImageView!
    @IBOutlet weak var lblFrontCamera: UILabel!
    @IBOutlet weak var imgBackCamera: UIImageView!
    @IBOutlet weak var lblBackCamera: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        imgFlag.image = flagImage
        lblCountry.text = countryName
    }
    func configureView(){
//        viewFront.layer.cornerRadius = 20
//        viewBack.layer.cornerRadius = 20
        imgFrontID.layer.cornerRadius = 20
        imgBackID.layer.cornerRadius = 20
    }

    @IBAction func onFrontIDCapture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker,animated: true,completion: nil)
        }

    }
    @IBAction func onBackIDCapture(_ sender: Any) {
        
    }
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imgFrontID.image = image
        }
        dismiss(animated: true, completion: nil)
    }

}
