//
//  CBGlobalMethods.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 10/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//


import Foundation
import Alamofire


let defaultHeader = ["Accept" : "application/json",]
let defaultServerErrorMsg : String! = "Please check your network connection!"
let defaultErrorMessage : String! = "Something went wrong please try again later"
let APIBaseUrl : String! = "https://amebusinesssolutions.com/AMEService/"
let GETOAUTHTOKEN : String! = "oauth/token"
//let LOGIN : String! = "BranchList.php?OrgName="
let USERDETAIL_ : String! = "api/user-details"
let SAVE_ : String! = "api/appointment-store"
let LICENSEDATA_ : String! = "api/insurance-list"
let APPOINTMENTSEARCH_ : String! = "api/appointment-list"
let APPOINTMENT_REQUEST_UPDATE_ : String! = "api/appointment-req-update"


//MARK:- Send the Params to API...
var dictParams_ = [String : Any]()

class Service {
    
    struct Singleton {
        static let sharedInstance = Service()
    }
    
    class var sharedInstance: Service {
         return Singleton.sharedInstance
    }
    
    typealias SuccessBlock = ( _ error : NSError?, _ responseDict : NSDictionary, _ headerDict : NSDictionary)  -> Void
    typealias ErrorBlock = ( _ errorDict : NSDictionary)  -> Void
    typealias FailurBlock = ( _ error : NSError)  -> Void
    typealias SuccessBlockForArray = ( _ error : NSError?, _ responseArray : NSArray)  -> Void
    typealias LWebserviceStatusDictCompletionBlock = ( _ error : NSError?, _ responseDict : [String : AnyObject]?)  -> Void
    typealias LWebserviceStatusCompletionBlock = ( _ error : NSError?, _ responseDict : NSArray?)  -> Void
    
    
    
    //MARK:- Webservice Get Dictonary method
    func webServiceInitialGETCall(url : String, isShowLoader: Bool,paramValues : NSDictionary, headerValues : [String:String], completionBlock : @escaping LWebserviceStatusDictCompletionBlock) {
        
        if isShowLoader{
            showHUDAddedTo()
        }
        
        var urlStr = APIBaseUrl + url
//        urlStr = "https://mocki.io/v1/6dac8949-5c2d-49ad-90e4-df0623f4e9b7"
        debugPrint("DEBUG: \(urlStr)")
        
        AF.request(urlStr, method: .post, parameters: paramValues as? Parameters, encoding: URLEncoding.default, headers: nil) .responseJSON { response in
            switch response.result {
            case .success(let responseDict):
                completionBlock( nil, responseDict as? [String : AnyObject])
            case .failure(let error):
                completionBlock(error as NSError?, nil)
            }
        }
    }
    
}



