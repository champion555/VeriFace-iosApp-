//
//  CameraViewController.swift
//  IDCardCapture
//
//  Created by Admin on 9/12/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation
//import KVNProgress
class CameraViewController: UIViewController {
    @IBOutlet weak var rectFrameView: UIView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtMessage: UILabel!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var btnTake: UIButton!
    @IBOutlet weak var btnReTake: UIButton!
    @IBOutlet weak var btnFlash: UIButton!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorMesTitle: UILabel!
    @IBOutlet weak var errorMesBlurry: UILabel!
    @IBOutlet weak var errorMesGlare: UILabel!
    var captureSession = AVCaptureSession()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var originalImage: UIImage?
    let imagePicker = UIImagePickerController()
    let shapeLayer = CAShapeLayer()
    var cropRect: CGRect!
    var IdType: String = ""
    var target: String = ""
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var isFlash: Bool = false
    var demoFileUri: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        //set up capture session
        setupCaptureSession()
        //set up devic
        setupDevice()
        //set up input and output
        setupInputOutput()
        //set up preview the photo that take from camera or gallery
        setupPreviewLayer()
        //start capture
        startRunningCaptureSession()
        
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let xPos = 0.04 * screenWidth
        let yPos = 0.19 * screenHeight
        let rectWidth = screenWidth - 2 * xPos
        let rectHeight = screenHeight - 3.55 * yPos
        cropRect = CGRect(x:CGFloat(xPos), y:CGFloat(yPos), width:CGFloat(rectWidth), height:CGFloat(rectHeight))
        txtTitle.text = "Powered by BIOMIID"
        if IdType == "FrontIDCard"{
            txtMessage.text = "Place the Front of ID Card inside the Frame and take the Photo"
        }else if IdType == "BackIDCard"{
            txtMessage.text = "Place the Back of ID Card inside the Frame and take the Photo"
        }
        if IdType == "FrontDriving"{
            txtMessage.text = "Place the Front of Driving License inside the Frame and take the Photo"
        }else if IdType == "BackDriving"{
            txtMessage.text = "Place the Back of Driving License inside the Frame and take the Photo"
        }
        if IdType == "FrontResident"{
            txtMessage.text = "Place the Front of Resident Permit inside the Frame and take the Photo"
        }else if IdType == "BackResident"{
            txtMessage.text = "Place the Back of Resident Permit inside the Frame and take the Photo"
        }
        if IdType == "Passport"{
            txtMessage.text = "Place the Passport inside the Frame and take the Photo"
        }
    }
    func configureView(){
        previewImage.isHidden = true
        btnTake.layer.cornerRadius = 10
        btnReTake.layer.cornerRadius = 10
        errorMessageView.layer.borderWidth = 1
        errorMessageView.layer.borderColor = UIColor(red: 251/255.0, green: 226/255.0, blue: 15/255.0, alpha: 1).cgColor
        errorMessageView.layer.cornerRadius = 5
        btnTake.isHidden = true
        btnReTake.isHidden = true
        errorMessageView.isHidden = true
        errorMesTitle.font = UIFont.boldSystemFont(ofSize: 20)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setupDevice() {
        //get Camera from device
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        //set the camera to back or front
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        //set up the backCamera to current camera
        currentCamera = backCamera
    }
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!) //if there is camera in device
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    func cropImage(_ inputImage: UIImage) -> UIImage?
    {
        let xPos = 0.24 * inputImage.size.width
        let yPos = 0.11 * inputImage.size.height
        let rectWidth = inputImage.size.width - 2.5 * xPos
        let rectHeight = inputImage.size.height - 4.4 * yPos
        let rectangle = CGRect(x:CGFloat(xPos), y:CGFloat(yPos), width:CGFloat(rectWidth), height:CGFloat(rectHeight))
        
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:rectangle)
        else {
            return nil
        }
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        let rotateImage: UIImage = croppedImage.rotate(radians: .pi/2)!
        
        let timestamp = NSDate().timeIntervalSince1970
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "IDDocPhoto" + "\(timestamp)" + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let data = rotateImage.jpegData(compressionQuality:  1.0)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data!.write(to: fileURL)
                print("file saved")
                if IdType == "FrontIDCard"{
                    Constants.FrontIDCardPath = fileURL.absoluteString
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if IdType == "BackIDCard"{
                    Constants.BackIDCardPath = fileURL.absoluteString
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "IDCardViewController") as! IDCardViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if IdType == "FrontDriving"{
                    Constants.FrontDrivingPath = fileURL.absoluteString
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrivingLicenseViewController") as! DrivingLicenseViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if IdType == "BackDriving"{
                    Constants.BackDrivingPath = fileURL.absoluteString
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrivingLicenseViewController") as! DrivingLicenseViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if IdType == "FrontResident"{
                    Constants.FrontResidentPath = fileURL.absoluteString
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResidentPermitViewController") as! ResidentPermitViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if IdType == "BackResident"{
                    Constants.BackResidentPath = fileURL.absoluteString
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResidentPermitViewController") as! ResidentPermitViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                if IdType == "Passport"{
                    Constants.passportPath = fileURL.absoluteString
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PassportViewController") as! PassportViewController
                    vc.target = self.target
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } catch {
                print("error saving file:", error)
            }
        }
        
        return croppedImage
    }
    
    @IBAction func onCapture(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onPhotoTake(_ sender: Any) {
        cropImage(originalImage!)
    }
    @IBAction func onReTake(_ sender: Any) {
        previewImage.isHidden = true
        btnTake.isHidden = true
        btnReTake.isHidden = true
        btnCapture.isHidden = false
        btnFlash.isHidden = false
        errorMessageView.isHidden = true
        txtMessage.isHidden = false
        txtTitle.text = "Powered by BIOMIID"
        if IdType == "FrontIDCard"{
            txtMessage.text = "Place the Front of ID Card inside the Frame and take the Photo"
        }else if IdType == "BackIDCard"{
            txtMessage.text = "Place the Back of ID Card inside the Frame and take the Photo"
        }
        if IdType == "FrontDriving"{
            txtMessage.text = "Place the Front of Driving License inside the Frame and take the Photo"
        }else if IdType == "BackDriving"{
            txtMessage.text = "Place the Back of Driving License inside the Frame and take the Photo"
        }
        if IdType == "FrontResident"{
            txtMessage.text = "Place the Front of Resident Permit inside the Frame and take the Photo"
        }else if IdType == "BackResident"{
            txtMessage.text = "Place the Back of Resident Permit inside the Frame and take the Photo"
        }
        if IdType == "Passport"{
            txtMessage.text = "Place the Passport inside the Frame and take the Photo"
        }
    }
    @IBAction func onFlash(_ sender: Any) {
        if isFlash == false{
            toggleTorch(on: true)
            btnFlash.setImage(UIImage(named: "camera_flash_on.png"), for: .normal)
            isFlash = true
        }else{
            toggleTorch(on: false)
            btnFlash.setImage(UIImage(named: "camera_flash_off.png"), for: .normal)
            isFlash = false
        }
        
    }
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    func AuthenticationToServer(){
//        KVNProgress.show(withStatus: "checking Image quality...", on: view)
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrolled Checking Error", msg: "Server is not working now. please try later")
//                KVNProgress.dismiss()
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                self.imageQualityCheckToServer(token: api_access_token)
            }
            
        })
    }
    private func imageQualityCheckToServer(token : String){
        ImageCheck(urlPart: Constants.URLPart.imageQualityCheck.rawValue, token: token, imagePath: demoFileUri, completion: { error, response in
//            KVNProgress.dismiss()
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Error", msg: "ID Card verification is failed. please try again")
            }else{
                let res = response as! [String: Any]
                let statusCode = res["statusCode"] as! String
                let imageCheckRes = ImageQualityResponse(dict: res)
                if statusCode == "200"{
                    self.previewImage.isHidden = false
                    self.btnTake.isHidden = false
                    self.btnReTake.isHidden = false
                    if let imgData = try? Data(contentsOf: self.demoFileUri!) {
                        let image = UIImage(data: imgData)
                        self.previewImage.image = image
                    }
                    self.originalImage = self.previewImage.image
                    self.btnCapture.isHidden = true
                    self.btnFlash.isHidden = true
                    self.txtTitle.text = "Preview Captured ID Document"
                    self.txtMessage.text = "Make sure the ID Document image is clear to read"
                }else{
                    let listCount:Int = imageCheckRes.errorList.count
                    if listCount > 1 {
                        self.errorMesBlurry.text = "- image too blur"
                        self.errorMesGlare.text = "- Glares are detected on Image"
                    }else{
                        let errorType = imageCheckRes.errorList[0].errorType
                        if errorType == "GlareFound"{
                            self.errorMesBlurry.text = "- Glares are detected on Image"
                        }else if errorType == "ImageTooBlurry"{
                            self.errorMesBlurry.text = "- image too blur"
                        }
                    }
                    self.previewImage.isHidden = false
                    self.btnTake.isHidden = true
                    self.btnReTake.isHidden = false
                    if let imgData = try? Data(contentsOf: self.demoFileUri!) {
                        let image = UIImage(data: imgData)
                        self.previewImage.image = image
                    }
                    self.originalImage = self.previewImage.image
                    self.btnCapture.isHidden = true
                    self.btnFlash.isHidden = true
                    self.txtTitle.text = "Preview Captured ID Document"
                    self.txtMessage.isHidden = true
                    self.errorMessageView.isHidden = false
                }
                
            }
        })
    }
    
}
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            let image :UIImage = UIImage(data: imageData)!
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileName = "demoImage" + "\(timestamp)" + ".jpg"
            let fileName = "demoImage.jpg"
            demoFileUri = documentsDirectory.appendingPathComponent(fileName)
            let data = image.jpegData(compressionQuality:  1.0)
            if !FileManager.default.fileExists(atPath: demoFileUri.path) {
                do {
                    try data!.write(to: demoFileUri)
                    print("file saved")
                    self.AuthenticationToServer()
                } catch {
                    print("error saving file:", error)
                }
            }else{
                do {
                    try FileManager.default.removeItem(at: demoFileUri)
                    print("Remove successfully")
                    do {
                        try data!.write(to: demoFileUri)
                        print("file saved")
                        self.AuthenticationToServer()
                    } catch {
                        print("error saving file:", error)
                    }
                }
                catch let error as NSError {
                    print("error deleting file:", error)
                }
            }
            
//            if !FileManager.default.fileExists(atPath: demoFileUri.path) {
//                do {
//                    try data!.write(to: demoFileUri)
//                    print("file saved")
//                    AuthenticationToServer()
//                } catch {
//                    print("error saving file:", error)
//                }
//                previewImage.isHidden = false
//                btnTake.isHidden = false
//                btnReTake.isHidden = false
//                previewImage.image = image
//                originalImage = previewImage.image
//                btnCapture.isHidden = true
//                btnFlash.isHidden = true
//                txtTitle.text = "Preview Captured ID Document"
//                txtMessage.text = "Make sure the ID Document image is clear to read"
//            }
        }
    }
}
extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
