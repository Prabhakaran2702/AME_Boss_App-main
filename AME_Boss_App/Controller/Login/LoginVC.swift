//
//  LoginVC.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 14/01/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var etxUserName: MetrialTextfield!
    @IBOutlet weak var etxPassword: MetrialTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        topview.TopViewGradient(colors: [UIColor(red: 40/255, green: 60/225, blue: 134/225, alpha: 1).cgColor ,UIColor(red: 69/255, green: 162/225, blue: 71/225, alpha: 1).cgColor])
        btnsubmit.BtnGradient(colors: [UIColor(red: 40/255, green: 60/225, blue: 134/225, alpha: 1).cgColor ,UIColor(red: 69/255, green: 162/225, blue: 71/225, alpha: 1).cgColor])
        CATransaction.commit()
    }
    
    
    @IBAction func BtnSubmit(_ sender: UIButton) {
        if self.etxUserName.text!.count == 0 {
            self.displayAlertMessage(userMessage: "Enter the  Username  ")
        }
        else if self.etxPassword.text!.count == 0 {
            self.displayAlertMessage(userMessage: "Enter the Password ")
        } else {
            self.APILOGIN()
        }
    }
    
    @IBAction func BtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func APILOGIN() {
        if self.etxUserName.text!.count != 0  && self.etxPassword.text!.count != 0 {
            self.view.endEditing(true)
            
            let defaults = UserDefaults.standard
            let  BusinessCenter = defaults.string(forKey: "BusinessCenter")!
            let dictParams = ["": ""]
            let URL  =  "UserLogin.php?Branch=" + BusinessCenter + "&UserName=" + self.etxUserName.text! + "&Password=" + self.etxPassword.text!
            Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
                hideHUDForView()
                if JsonResponse == nil {
                    CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Your server is offline. Please check after some time...")
                    return
                }
                let status = JsonResponse!["Response"] as? String ?? ""
                if status == "1", let data = JsonResponse!["Data"] as? NSArray {
                    UserDefaults.standard.setValue("1", forKey: "isUserLogIn")
                    if UserDefaults.standard.string(forKey: "IsRetail") == "1"{
                        self.pushToVc(identifier: "TabVC")
                    }else{
                        self.pushToVc(identifier: "HomeVC")
                    }
                    
                } else {
                    self.displayAlertMessage(userMessage: "Incorrect username or password.")
                }
            }
        } else {
            self.displayAlertMessage(userMessage: "Plese enter the username and password" )
        }
    }
}



