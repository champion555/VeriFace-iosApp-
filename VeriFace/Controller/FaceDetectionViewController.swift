//  LiveFaceDetect
//
//  Created by Mohammed Azeem Azeez on 18/02/2020.
//  Copyright © 2020 Blue Mango Global. All rights reserved.
//

import AVFoundation
import UIKit
import Vision
import KVNProgress

class FaceDetectionViewController: UIViewController {
    var photoFaceLiveness:Bool!
    var userEnrollment:Bool!
    var userAuthentication: Bool!
    var faceMatchToID:Bool!
    var isEnrolled = ""
    var sequenceHandler = VNSequenceRequestHandler()
    var captureImage: Bool?
    var recordVideo = false
    @IBOutlet weak var lineView: UIView!
    @IBOutlet var faceView: FaceView!
    @IBOutlet weak var ellipseView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var txtMessage: UILabel!
    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var lbeTitle: UILabel!
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var faceImage: UIImage!
    var imageRect = CGRect()
    let dataOutputQueue = DispatchQueue(label: "video data queue",qos: .userInitiated,attributes: [],autoreleaseFrequency: .workItem)
    var facedetected = false
    var maxX: CGFloat = 0.0
    var midY: CGFloat = 0.0
    var maxY: CGFloat = 0.0
    let shapeLayer = CAShapeLayer()
    var photoFilename: URL!
    var ellipseView_maxX:CGFloat = 0.0
    var ellipseView_maxY:CGFloat = 0.0
    let videoOutput = AVCaptureVideoDataOutput()
    var isdetected = false
    var assetWriter: AVAssetWriter! = nil
    var assetWriterInput: AVAssetWriterInput! = nil
    var videoStartTime: CMTime! = nil
    var videoFileName:URL! = nil
    var videoNumber = 0
    var recordingTS: Double = 0
    var videoOutputURL: URL! = nil
    var alertCheck = false
    var isLivenessResult = false
    var livnessForAuthentication = false
    var livenessFailedMes = false
    var isnotExsitMes = false
    var IDDocUri:URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        captureImage = false
        configureCaptureSession()
        maxX = view.bounds.maxX
        midY = view.bounds.midY
        maxY = view.bounds.maxY
        session.startRunning()
        print(maxX,maxY)
        ellipseView_maxX = ellipseView.bounds.maxX
        ellipseView_maxY = ellipseView.bounds.maxY
        print(ellipseView_maxX,ellipseView_maxY)
        drawEllipse()
    }
    func configureView(){
        mainView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        topBarView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        txtMessage.font = UIFont.boldSystemFont(ofSize: 20)
        processingView.backgroundColor = UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        lineView.backgroundColor = UIColor.white
        processingView.isHidden = true
        lbeTitle.font = UIFont.boldSystemFont(ofSize: 25)
        if photoFaceLiveness == true {
            lbeTitle.text = "Liveness Check"
        }
        if userEnrollment == true {
            lbeTitle.text = "Enrollment"
        }
        if userAuthentication == true {
            lbeTitle.text = "Authentification"
        }
        if faceMatchToID == true {
            lbeTitle.text = "Face Match ID"
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if alertCheck == true {
            if isnotExsitMes == true{
                let alertController = UIAlertController(title: "No exists this enrollment!", message: "Please go to the Enrollment and then enroll your face", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Default action"), style: .`default`, handler: { _ in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                }))
                present(alertController, animated: true, completion: nil)
            }
            if livenessFailedMes == true {
                let alertController = UIAlertController(title: "Livness is Failed", message: "Please try again", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Default action"), style: .`default`, handler: { _ in
                        self.videoOutput.setSampleBufferDelegate(self, queue: self.dataOutputQueue)
                }))
                present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    @IBAction func onBack(_ sender: Any) {
        self.videoOutput.setSampleBufferDelegate(nil, queue: self.dataOutputQueue)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func drawEllipse(){
        let sampleMask = UIView()
        sampleMask.frame = self.ellipseView.frame
        sampleMask.backgroundColor =  UIColor(red: 127/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1).withAlphaComponent(0.8)
        //assume you work in UIViewcontroller
        self.ellipseView.addSubview(sampleMask)
        let maskLayer = CALayer()
        maskLayer.frame = sampleMask.bounds
        let maskEllipseleLayer = CAShapeLayer()
        //assume the circle's radius is 150
        maskEllipseleLayer.frame = CGRect(x:0 , y:0,width: sampleMask.frame.size.width,height: sampleMask.frame.size.height)
        let finalPath = UIBezierPath(roundedRect: CGRect(x:0 , y:0,width: sampleMask.frame.size.width,height: sampleMask.frame.size.height), cornerRadius: 0)
        let maskEllipsePath = UIBezierPath(ovalIn: CGRect(x:30, y: 70, width: ellipseView.bounds.maxX - 95, height: (ellipseView.bounds.maxY * 3/4) - 40))
        finalPath.append(maskEllipsePath.reversing())
        maskEllipseleLayer.path = finalPath.cgPath
        maskEllipseleLayer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
        maskEllipseleLayer.borderWidth = 1
        maskLayer.addSublayer(maskEllipseleLayer)
        sampleMask.layer.mask = maskLayer        
        let ellipsePath = UIBezierPath(ovalIn: CGRect(x:30, y: 70, width: ellipseView.bounds.maxX - 95, height: (ellipseView.bounds.maxY * 3/4) - 40))
        shapeLayer.path = ellipsePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 5.0
        self.ellipseView.layer.addSublayer(shapeLayer)
    }
  
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
    {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!);
        let height = CVPixelBufferGetHeight(imageBuffer!);
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage();
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        // Create an image object from the Quartz image
        let image = UIImage.init(cgImage: quartzImage!);
        return (image);
    }
  
    override func didReceiveMemoryWarning() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    func saveImageToFile(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "capturedPhoto.jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let data = faceImage.jpegData(compressionQuality:  1.0)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data!.write(to: fileURL)
                print("file saved")
                self.AuthenticationToServer()
            } catch {
                print("error saving file:", error)
            }
        }else{
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Remove successfully")
                do {
                    try data!.write(to: fileURL)
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
    
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func AuthenticationToServer(){
        self.videoOutput.setSampleBufferDelegate(nil, queue: self.dataOutputQueue)
        DispatchQueue.main.async {
            self.processingView.isHidden = false
        }
        KVNProgress.show(withStatus: "Processing...", on: processingView)
        photoFilename = getDocumentsDirectory().appendingPathComponent("capturedPhoto.jpg")
        authentication(urlPart: Constants.URLPart.authentificate.rawValue, apiKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.APIKey.rawValue) ?? Constants.Domain.api_key, secretKey: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.SecretKey.rawValue) ?? Constants.Domain.secret_key, completion: {error, response in
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "Authentication Error", msg: "Server is not working now. please try later")
                KVNProgress.dismiss()
                self.processingView.isHidden = true
                self.isdetected = false
                self.videoOutput.setSampleBufferDelegate(self, queue: self.dataOutputQueue)
            }else{
                let res = response as! [String: Any]
                let api_access_token = res["api_access_token"] as! String
                if self.photoFaceLiveness == true {
                    self.uploadPhotoToServer(token: api_access_token)
                }
                if self.userEnrollment == true {
                    self.uploadFaceEnrollmentToServer(token: api_access_token)
                }
                if self.userAuthentication == true {
                    self.uploadFaceAuthenticationToServer(token: api_access_token)
                }
                if self.faceMatchToID == true {
                    self.faceMatchToID(token: api_access_token)
                }
            }
            
        })
    }
    private func uploadPhotoToServer(token : String){
        request(urlPart: Constants.URLPart.photoLivenessCheck.rawValue, token: token, photoFilePath: photoFilename, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil{
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Liveness Checked Error", msg: "User Liveness Checking is Failed, please try again")
                self.processingView.isHidden = true
                self.isdetected = false
                self.videoOutput.setSampleBufferDelegate(self, queue: self.dataOutputQueue)
            }else{
                let res = response as! [String: Any]
                let statusCode = res["statusCode"] as! String
                let res_score = res["score"] as! String
                let res_threshold = res["threshold"] as! String
                if statusCode == "200"{
                    let score = Float(res_score)!
                    let threshold = Float(res_threshold)!
                    let result = score - threshold
                    if result > 0 {
                        self.isLivenessResult = true
                        DispatchQueue.main.async {
                            self.processingView.isHidden = true
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                            vc.photoFaceLiveness = true
                            vc.score = res_score
                            vc.isLivenessResult = self.isLivenessResult
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        self.isLivenessResult = false
                        DispatchQueue.main.async {
                            self.processingView.isHidden = true
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
                            vc.photoFaceLiveness = true
                            vc.score = res_score
                            vc.isLivenessResult = self.isLivenessResult
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }else{
                    print("aljdlajdlrhaliueohaldj")
                    
                }
                
            }
        })
    }
    private func uploadFaceEnrollmentToServer(token : String){
        userEnrollRequest(urlPart: Constants.URLPart.enrollementCheck.rawValue, token: token, photoFilePath: photoFilename,isEnrolled: isEnrolled, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil {
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrollment Error", msg: "User Enrollment is Failed, please try again")
                self.processingView.isHidden = true
                self.isdetected = false
                self.videoOutput.setSampleBufferDelegate(self, queue: self.dataOutputQueue)
            } else {
                let res = response as! [String: Any]
                let statusCode = res["statusCode"] as! String
                if statusCode == "200" {
                    let data = EnrollmentResponse(dict: res)
                    print(data)
                    DispatchQueue.main.async {
                        self.processingView.isHidden = true
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnrollmentResultViewController") as! EnrollmentResultViewController
                        vc.userEnrollCheck = true
                        vc.userEnrollment = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                } else {
                    let data = EnrollmentResponse(dict: res)
                    print(data)
                    DispatchQueue.main.async {
                        self.processingView.isHidden = true
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnrollmentResultViewController") as! EnrollmentResultViewController
                        vc.userEnrollCheck = false
                        vc.userEnrollment = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        })
    }
    private func uploadFaceAuthenticationToServer(token : String){
        userAuthenticationRequest(urlPart: Constants.URLPart.authenticationCheck.rawValue, token: token, photoFilePath: photoFilename, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil {
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Authentication Error", msg: "User Authentication is Failed, please try again")
                self.processingView.isHidden = true
                self.isdetected = false
                self.videoOutput.setSampleBufferDelegate(self, queue: self.dataOutputQueue)
            } else {
                let res = response as! [String: Any]
                let statusCode = res["statusCode"] as! String
                if statusCode == "200" {
                    let score = res["score"] as! String
                    let livenessScore = res["liveness_score"] as! String
                    let livenessThreshold = res["liveness_threshold"] as! String
                    let authentication_score = Float(score)!
                    let authe_result = authentication_score - 0.9
                    let liveness_score = Float(livenessScore)!
                    let liveness_threshold = Float(livenessThreshold)!
                    let liveness_result = liveness_score - liveness_threshold
                    
                    if authe_result > 0 {
                        if liveness_result > 0 {
                            self.livnessForAuthentication = true
                        }else{
                            self.livnessForAuthentication = false
                        }
                        let data = AuthenticationResponse(dict: res)
                        print(data)
                        DispatchQueue.main.async {
                            self.processingView.isHidden = true
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnrollmentResultViewController") as! EnrollmentResultViewController
                            vc.userAuthentication = true
                            vc.autheResult = true
                            vc.score = score
                            vc.livnessForAuthentication = self.livnessForAuthentication
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        if liveness_result > 0 {
                            self.livnessForAuthentication = true
                        }else{
                            self.livnessForAuthentication = false
                        }
                        DispatchQueue.main.async {
                            self.processingView.isHidden = true
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnrollmentResultViewController") as! EnrollmentResultViewController
                            vc.userAuthentication = true
                            vc.livnessForAuthentication = self.livnessForAuthentication
                            vc.score = score
                            vc.autheResult = false
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                }else if statusCode == "404"{
                    DispatchQueue.main.async {
                        self.livenessFailedMes = true
                        self.alertCheck = true
                        self.processingView.isHidden = true
                        self.isdetected = false
                        DispatchQueue.main.async {
                            self.shapeLayer.strokeColor = UIColor.white.cgColor
                        }
                        self.viewDidAppear(true)
                    }
                }else {
                    DispatchQueue.main.async {
                        self.isnotExsitMes = true
                        self.alertCheck = true
                        self.processingView.isHidden = true
                        self.viewDidAppear(true)
                    }
                }
            }
        })
    }
    private func faceMatchToID(token : String){
        faceMatchToServer(urlPart: Constants.URLPart.faceMatchToID.rawValue, token: token, source_image_file: photoFilename,target_image_file: IDDocUri, completion: { error, response in
            KVNProgress.dismiss()
            if error != nil {
                CommonManager.shared.showAlert(viewCtrl: self, title: "User Enrollment Error", msg: "User Enrollment is Failed, please try again")
                self.processingView.isHidden = true
                self.isdetected = false
                self.videoOutput.setSampleBufferDelegate(self, queue: self.dataOutputQueue)
            } else {
                let res = response as! [String: Any]
                let status = res["status"] as! String
                if status == "SUCCESS" {
                    let faceMatchRes = FaceMatchResponse(dict: res)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceMatchResultViewController") as! FaceMatchResultViewController
                    vc.response = faceMatchRes
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                   
                }
            }
        })
    }
   
}
// MARK: - Video Processing methods

extension FaceDetectionViewController {
    func configureCaptureSession() {
        // Define the capture device we want to use
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,for: .video,position: .front)
            else {
                fatalError("No front video camera available")
            }
        // Connect the camera to the capture session input
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            session.addInput(cameraInput)
        } catch {
            fatalError(error.localizedDescription)
        }
        // Create the video data output
        videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

        // Add the video output to the capture session
        session.addOutput(videoOutput)
        let videoConnection = videoOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
        // Configure the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate methods

extension FaceDetectionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 1
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            else {
                return
            }
        let detectFaceRequest = VNDetectFaceLandmarksRequest(completionHandler: detectedFace)
        do {
            try sequenceHandler.perform(
            [detectFaceRequest],
            on: imageBuffer,
            orientation: .leftMirrored)
        } catch {
            print(error.localizedDescription)
        }
        if captureImage == true {
            DispatchQueue.main.async {
            let sampleImg = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
            self.faceImage = sampleImg as? UIImage
            self.captureImage = false
            self.saveImageToFile()
            }
        }
    }
}
extension FaceDetectionViewController {
    func convert(rect: CGRect) -> CGRect {
        let origin = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
        let size = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
        return CGRect(origin: origin, size: size.cgSize)
    }
    func landmark(point: CGPoint, to rect: CGRect) -> CGPoint {
        let absolute = point.absolutePoint(in: rect)
        let converted = previewLayer.layerPointConverted(fromCaptureDevicePoint: absolute)
        return converted
    }

    func landmark(points: [CGPoint]?, to rect: CGRect) -> [CGPoint]? {
        guard let points = points
            else {
                return nil
            }

        return points.compactMap { landmark(point: $0, to: rect) }
    }

    func updateFaceView(for result: VNFaceObservation) {
        defer {
            DispatchQueue.main.async {
                self.faceView.setNeedsDisplay()
            }
        }

        let box = result.boundingBox
        print(box)
        let min_x = faceView.leftEyebrow.first?.x
        let max_x = faceView.rightEyebrow.last?.x
        let min_y = faceView.leftEyebrow.first?.y
        let max_y = faceView.outerLips.last?.y
        if !(min_x == nil) && !(max_x == nil) && !(min_y == nil) && !(max_y == nil){
            let left_x  = Int( min_x! - 30.0)
            let right_x = Int (ellipseView_maxX - 30.0 - max_x!)
            let top_y  = Int (min_y! - 70.0)
            let bottom_y  = Int((ellipseView_maxY * 3/4) - 20.0 - max_y!)
//            let min_limit = ellipseView_maxX*7/100
//            let max_limit = ellipseView_maxX*19/100 // 7% ~ 19%
            //&& 150 < top_y && top_y < 220 && 70 < bottom_y && bottom_y < 95
            print(left_x,right_x,top_y,bottom_y)
            if 30 < left_x && left_x < 60 && 45 < right_x && right_x < 90 {
                DispatchQueue.main.async {
                    self.shapeLayer.strokeColor = UIColor.green.cgColor
                }
                if isdetected == false{
                    captureImage = true
                    self.isdetected = true
                }
            }else if left_x > 60 && right_x > 80 && top_y > 210 && bottom_y > 85 {
                DispatchQueue.main.async {
                    self.shapeLayer.strokeColor = UIColor.white.cgColor
                    self.txtMessage.text = "Move closer."
                }
            }else{
                DispatchQueue.main.async {
                    self.shapeLayer.strokeColor = UIColor.white.cgColor
                    self.txtMessage.text = "Please place your face on the oval and get closer to the device."
                }
            }
            
        }else{
            print("The face was not detected")
        }
        guard let landmarks = result.landmarks else {
        return
        }

        if let leftEye = landmark(
            points: landmarks.leftEye?.normalizedPoints,
            to: result.boundingBox) {
            faceView.leftEye = leftEye
        }

        if let rightEye = landmark(
            points: landmarks.rightEye?.normalizedPoints,
            to: result.boundingBox) {
            faceView.rightEye = rightEye
        }

        if let leftEyebrow = landmark(
            points: landmarks.leftEyebrow?.normalizedPoints,
            to: result.boundingBox) {
            faceView.leftEyebrow = leftEyebrow
        }

        if let rightEyebrow = landmark(
            points: landmarks.rightEyebrow?.normalizedPoints,
            to: result.boundingBox) {
            faceView.rightEyebrow = rightEyebrow
        }

        if let nose = landmark(
            points: landmarks.nose?.normalizedPoints,
            to: result.boundingBox) {
            faceView.nose = nose
        }

        if let outerLips = landmark(
            points: landmarks.outerLips?.normalizedPoints,
            to: result.boundingBox) {
            faceView.outerLips = outerLips
        }

        if let innerLips = landmark(
            points: landmarks.innerLips?.normalizedPoints,
            to: result.boundingBox) {
            faceView.innerLips = innerLips
        }

        if let faceContour = landmark(
            points: landmarks.faceContour?.normalizedPoints,
            to: result.boundingBox) {
            faceView.faceContour = faceContour
        }
    }
    func detectedFace(request: VNRequest, error: Error?) {
        guard
            let results = request.results as? [VNFaceObservation],
            let result = results.first
        else {
        faceView.clear()
        if captureImage == true {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No Face!", message: "No face was detected", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        return
        }
        if facedetected {
            print("the face was detected correctly")
//            self.AuthenticationToServer()
        } else {
        updateFaceView(for: result)
        }
    }

}
extension CGPoint {
   func scaled(to size: CGSize) -> CGPoint {
       return CGPoint(x: self.x * size.width,
                      y: self.y * size.height)
   }
}
extension Double {
    var toTimeString: String {
        let seconds: Int = Int(self.truncatingRemainder(dividingBy: 60.0))
        let minutes: Int = Int(self / 60.0)
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

