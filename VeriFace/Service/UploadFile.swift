//
//  UploadAudio.swift
//  VeriVoice
//
//  Created by Raza Ali on 27/06/2020.
//  Copyright © 2020 Raza Ali. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let manager = ServerTrustManager(evaluators: ["your.domain.here": DisabledEvaluator()])
let session = Session(serverTrustManager: manager)

func request(urlPart : String ,token: String?, photoFilePath: URL, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(photoFilePath, withName: "live_image_file" , fileName: "capturedPhoto.jpg" , mimeType: "image/jpg")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func authentication(urlPart : String ,apiKey: String?, secretKey: String?, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    let api_key = apiKey
    let secret_key = secretKey
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(api_key!.data(using: .utf8)!, withName: "api_key")
        multipartFormData.append(secret_key!.data(using: .utf8)!, withName: "secret_key")
    }, to: url.appendingPathComponent(urlPart))
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func userEnrollRequest(urlPart : String ,token: String?, photoFilePath: URL,isEnrolled: String?, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let username = (AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.UserName.rawValue)!) as String
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(photoFilePath, withName: "image_file" , fileName: "capturedPhoto.jpg" , mimeType: "image/jpg")
        multipartFormData.append(username.data(using: .utf8)!, withName: "username")
        multipartFormData.append(isEnrolled!.data(using: .utf8)!, withName: "force_enrollment")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func userAuthenticationRequest(urlPart : String ,token: String?, photoFilePath: URL, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let username = (AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.UserName.rawValue)!) as String
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(photoFilePath, withName: "image_file" , fileName: "capturedPhoto.jpg" , mimeType: "image/jpg")
        multipartFormData.append(username.data(using: .utf8)!, withName: "username")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func userEnrollCheck(urlPart : String ,token: String?, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let username = (AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.UserName.rawValue)!) as String
    print(username)
    
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(username.data(using: .utf8)!, withName: "username")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func registerInfo(urlPart : String,token: String? ,firstName: String?, lastName: String?,phone: String?,company: String?,country: String?,industry: String?,job: String?,password: String?,email: String?, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let firstName = firstName
    let lastName = lastName
    let email = email
    let phone = phone
    let company = company
    let country = country
    let industry = industry
    let job = job
    let password = password
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(firstName!.data(using: .utf8)!, withName: "first_name")
        multipartFormData.append(lastName!.data(using: .utf8)!, withName: "last_name")
        multipartFormData.append(email!.data(using: .utf8)!, withName: "email")
        multipartFormData.append(phone!.data(using: .utf8)!, withName: "phone_number")
        multipartFormData.append(company!.data(using: .utf8)!, withName: "company_name")
        multipartFormData.append(country!.data(using: .utf8)!, withName: "country_code")
        multipartFormData.append(industry!.data(using: .utf8)!, withName: "industry_type")
        multipartFormData.append(job!.data(using: .utf8)!, withName: "job_title")
        multipartFormData.append(password!.data(using: .utf8)!, withName: "password")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func sendMail(urlPart : String,token: String? ,language: String?, email: String?, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let language = language
    let email = email
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(language!.data(using: .utf8)!, withName: "language")
        multipartFormData.append(email!.data(using: .utf8)!, withName: "email")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func validateEmail(urlPart : String,token: String? ,jobId: String?, otp: String?, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let jobId = jobId
    let otp = otp
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(jobId!.data(using: .utf8)!, withName: "job_id")
        multipartFormData.append(otp!.data(using: .utf8)!, withName: "otp")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func login(urlPart : String,token: String? ,email: String?, password: String?, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let email = email
    let password = password
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(email!.data(using: .utf8)!, withName: "email")
        multipartFormData.append(password!.data(using: .utf8)!, withName: "password")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func IDDocVerification(urlPart : String ,token: String?, IDDocPath: URL, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(IDDocPath, withName: "document_image_file" , fileName: "idDoc.jpg" , mimeType: "image/jpg")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func faceMatchToServer(urlPart : String ,token: String?, source_image_file: URL,target_image_file: URL, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    let username = (AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.UserName.rawValue)!) as String
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(source_image_file, withName: "source_image_file" , fileName: "capturedPhoto.jpg" , mimeType: "image/jpg")
        multipartFormData.append(target_image_file, withName: "target_image_file" , fileName: "mergedIdDoc.jpg" , mimeType: "image/jpg")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

func ImageCheck(urlPart : String ,token: String?, imagePath: URL, completion: @escaping (Error?, Any?) -> ()) {
    let url = URL(string: AppUtils.getValueFromUserDefaults(key: Constants.AppPrefrenace.AppUrl.rawValue) ?? Constants.Domain.BASEURL)!
    var headers: HTTPHeaders = [
        "content-type": "multipart/form-data; boundary=---011000010111000001101001",
        "accept": "application/json",
    ]
    headers["Authorization"] = "Token \(token ?? "")"
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imagePath, withName: "image_file" , fileName: "demoImage.jpg" , mimeType: "image/jpg")
    }, to: url.appendingPathComponent(urlPart), headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let JSON):
                completion(nil, JSON)
                
            case .failure(let error):
                completion(error, nil)
            }
    }
}

