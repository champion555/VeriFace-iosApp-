//
//  ResponseModel.swift
//  VeriVoice
//
//  Created by Raza Ali on 27/06/2020.
//  Copyright © 2020 Raza Ali. All rights reserved.
//

import Foundation
struct Response : Codable {
    var job_id : String
    var duration : String
    var statusCode : String
    var status : String
    var score : String
    var threshold : String
   
}

struct AuthKeyResponse : Codable {
    var api_access_token : String
    var token_expiration : String
    var statusCode : String
    var status : String
       
}

class EnrollmentResponse : NSObject {
    var job_id : String = ""
    var status : String = ""
    var statusCode : String = ""
    var liveness_status : String = ""
    var liveness_score : String = ""
    var liveness_threshold : String = ""
    var duration : String = ""
    var enrollment_id : String = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        if let val = dict["job_id"] as? String                  { job_id = val }
        if let val = dict["status"] as? String                  { status = val }
        if let val = dict["statusCode"] as? String              { statusCode = val }
        if let val = dict["liveness_status"] as? String         { liveness_status = val }
        if let val = dict["liveness_score"] as? String          { liveness_score = val }
        if let val = dict["liveness_threshold"] as? String      { liveness_threshold = val }
        if let val = dict["duration"] as? String                { duration = val }
        if let val = dict["enrollment_id"] as? String           { enrollment_id = val }
    }
}
class AuthenticationResponse : NSObject {
    var job_id : String = ""
    var status : String = ""
    var statusCode : String = ""
    var liveness_status : String = ""
    var liveness_score : String = ""
    var liveness_threshold : String = ""
    var duration : String = ""
    var score : String = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        if let val = dict["job_id"] as? String                  { job_id = val }
        if let val = dict["status"] as? String                  { status = val }
        if let val = dict["statusCode"] as? String              { statusCode = val }
        if let val = dict["liveness_status"] as? String         { liveness_status = val }
        if let val = dict["liveness_score"] as? String          { liveness_score = val }
        if let val = dict["liveness_threshold"] as? String      { liveness_threshold = val }
        if let val = dict["duration"] as? String                { duration = val }
        if let val = dict["score"] as? String                   { score = val }
    }
}
class IDDocVeriResponse : NSObject {
    var job_id : String = ""
    var status : String = ""
    var statusCode : String = ""
    var duration : String = ""
    var mrz_type : String = ""
    var valid_score : Int = 0
    var type : String = ""
    var country : String = ""
    var number : String = ""
    var date_of_birth : String = ""
    var expiration_date : String = ""
    var nationality : String = ""
    var sex : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var valid_number : String = ""
    var valid_date_of_birth : String = ""
    var valid_expiration_date : String = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        if let val = dict["job_id"] as? String                  { job_id = val }
        if let val = dict["status"] as? String                  { status = val }
        if let val = dict["statusCode"] as? String              { statusCode = val }
        if let val = dict["duration"] as? String                { duration = val }
        if let val = dict["mrz_type"] as? String                { mrz_type = val }
        if let val = dict["valid_score"] as? Int                { valid_score = val }
        if let val = dict["duration"] as? String                { duration = val }
        if let val = dict["type"] as? String                    { type = val }
        if let val = dict["country"] as? String                 { country = val }
        if let val = dict["number"] as? String                  { number = val }
        if let val = dict["date_of_birth"] as? String           { date_of_birth = val }
        if let val = dict["expiration_date"] as? String         { expiration_date = val }
        if let val = dict["nationality"] as? String             { nationality = val }
        if let val = dict["sex"] as? String                     { sex = val }
        if let val = dict["first_name"] as? String              { first_name = val }
        if let val = dict["last_name"] as? String               { last_name = val }
        if let val = dict["valid_number"] as? String            { valid_number = val }
        if let val = dict["valid_date_of_birth"] as? String     { valid_date_of_birth = val }
        if let val = dict["valid_expiration_date"] as? String   { valid_expiration_date = val }
    }
}
class FaceMatchResponse : NSObject {
    var job_id : String = ""
    var status : String = ""
    var statusCode : String = ""
    var duration : String = ""
    var match_score : String = ""
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        if let val = dict["job_id"] as? String                  { job_id = val }
        if let val = dict["status"] as? String                  { status = val }
        if let val = dict["statusCode"] as? String              { statusCode = val }
        if let val = dict["duration"] as? String                { duration = val }
        if let val = dict["match_score"] as? String             { match_score = val }
    }
}
class ImageQualityResponse : NSObject {
    var status : String = ""
    var statusCode : String = ""
    var errorList : [ListResponse] = []
    var message : String = ""
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        if let val = dict["status"] as? String                  { status = val }
        if let val = dict["statusCode"] as? String              { statusCode = val }
        if let val = dict["errorList"]  as? [Any] {
            for error in val {
                let err = ListResponse(dict: error as! [String: Any])
                errorList.append(err)
            }
        }
        if let val = dict["message"] as? String                 { message = val }
    }
}
class ListResponse : NSObject {
    var errorType : String = ""
    var details : String = ""
    override init() {
        super.init()
    }
    
    init(dict: [String: Any]) {
        if let val = dict["errorType"] as? String               { errorType = val }
        if let val = dict["details"] as? String                 { details = val }
    }
}

