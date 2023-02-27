//
//  WelcomeVC.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 26/01/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController, BranchProtocol {
    
    func dataPassing(name: String, isRetail: String) {
        print(name)
        print(isRetail)
        UserDefaults.standard.setValue(isRetail, forKey: "IsRetail")
        etxSelectBusinessName.text = name
    }
    
    
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var etxEnterBusinessName: MetrialTextfield!
    @IBOutlet weak var etxSelectBusinessName: MetrialTextfield!
    @IBOutlet weak var btnSelectBusinessName: UIButton!
    
    var ComNameArray = [String]()
    var IsRetailArray = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
        
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        topview.TopViewGradient(colors: [UIColor(red: 40/255, green: 60/225, blue: 134/225, alpha: 1).cgColor ,UIColor(red: 69/255, green: 162/225, blue: 71/225, alpha: 1).cgColor])
        btnsubmit.BtnGradient(colors: [UIColor(red: 40/255, green: 60/225, blue: 134/225, alpha: 1).cgColor ,UIColor(red: 69/255, green: 162/225, blue: 71/225, alpha: 1).cgColor])
        CATransaction.commit()
    }
    
    
    @IBAction func BtnSubmit(_ sender: UIButton) {
        if self.etxEnterBusinessName.text!.count == 0 && self.etxSelectBusinessName.text!.count == 0 {
            self.displayAlertMessage(userMessage: "Enter a business name and center")
        } else {
            if self.etxEnterBusinessName.text!.count == 0 {
                self.displayAlertMessage(userMessage: "Enter a business name ")
            } else if self.etxSelectBusinessName.text!.count == 0 {
                self.displayAlertMessage(userMessage: "Select a business center ")
            } else {
                let BusinessName = self.etxEnterBusinessName.text!
                let BusinessCenter = self.etxSelectBusinessName.text!
                UserDefaults.standard.setValue(BusinessName, forKey: "BusinessName")
                UserDefaults.standard.setValue(BusinessCenter, forKey: "BusinessCenter")
                self.pushToVc(identifier: "LoginVC")
            }
        }
    }
    
    
    @IBAction func BtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectBusinessName(_ sender: UIButton) {
        if !isConnectedToNetwork() {
            self.displayAlertMessage(userMessage: defaultServerErrorMsg)
        } else {
            self.APILOGIN()
        }
    }
    
    
    
    func APILOGIN() {
        if self.etxEnterBusinessName.text!.count != 0 {
            self.view.endEditing(true)
            let dictParams = ["": ""]
            let URL  =  "BranchList.php?OrgName=" + self.etxEnterBusinessName.text!
            Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
                hideHUDForView()
                if JsonResponse == nil {
                    CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Your server is offline. Please check after some time...")
                    return
                }
                let status = JsonResponse!["Response"] as? String ?? ""
                if status == "1" {
                    let jsonData = try? JSONSerialization.data(withJSONObject:JsonResponse!)
                    if self.isValidJson(check: jsonData!) {
                        let data = JsonResponse!["Data"] as! NSArray
                        self.ComNameArray.removeAll()
                        self.IsRetailArray.removeAll()
                        for clientar in data {
                            let AppDict = clientar as! NSDictionary
                            let compname = AppDict.value(forKey: "compnam")
                            let IsRetail = AppDict.value(forKey: "IsRetail")
                            self.ComNameArray.append(compname! as! String)
                            self.IsRetailArray.append(IsRetail! as! String)
                        }
                        UserDefaults.standard.setValue(self.ComNameArray, forKey: "BranchList")
                        UserDefaults.standard.setValue(self.IsRetailArray, forKey: "IsRetailArray")
                        let VC  = self.storyboard?.instantiateViewController(identifier: "BrachListVC") as! BrachListVC
                        VC.delegate                     = self
                        self.present(VC, animated: true, completion: nil)
                    } else {
                        self.displayAlertMessage(userMessage: "Invalid Data")
                    }
                    }else {
                        self.displayAlertMessage(userMessage: "Sorry, No data available")
                }
            }
        }else {
            self.displayAlertMessage(userMessage: "Plese enter the businessname" )
        }
    }
    
    
    
    
    func isValidJson(check data:Data) -> Bool{
        do{
            if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                return true
            } else if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                return true
            } else {
                return false
            }
        }
        catch let error as NSError {
            print(error)
            return false
        }
    }
    
    
}
