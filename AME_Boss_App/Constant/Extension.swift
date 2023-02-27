//
//  Extension.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 14/01/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//


import Foundation
import UIKit

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
let appName = "Warning"
var Logout : Bool = false
var hud: MBProgressHUD?
var StoryBoard = UIStoryboard()

func showHUDAddedTo(){
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    hud = MBProgressHUD.showAdded(to: APP_DELEGATE.window, animated: true)
    hud?.activityIndicatorColor = UIColorFromRGB(0x45a247)
    hud?.labelColor = UIColorFromRGB(0x45a247)
    hud?.labelText = "Loading..."
}

func hideHUDForView(){
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    MBProgressHUD.hide(for: APP_DELEGATE.window, animated: true)
}

func isConnectedToNetwork() -> Bool {
    let status = Reach().connectionStatus()
    switch status {
    case .unknown, .offline:
        return false
    case .online(.wwan):
        return true
    case .online(.wiFi):
        return true
    }
}


extension UIViewController {
    // DisplayMyAlertMaessage function
    func displayAlertMessage(userMessage : String){
        let alert = UIAlertController(title: appName, message: userMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func pushToVc(identifier: String){
        let VC = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    
    // DisplayMyAlertMaessage function
    func displayAlertMaessage(userMessage : String){
        let alert = UIAlertController(title: appName, message: userMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func HomeVC(){
        if UserDefaults.standard.string(forKey: "IsRetail") == "1"{
            let InitalVC = self.storyboard!.instantiateViewController(withIdentifier: "TabVC") as! TabVC
            let rootNC = UINavigationController(rootViewController: InitalVC)
            APP_DELEGATE.window?.rootViewController = rootNC
        }else {
            let InitalVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let rootNC = UINavigationController(rootViewController: InitalVC)
            APP_DELEGATE.window?.rootViewController = rootNC
        }
    }
    
    
    func WelcomeVC(){
        let InitalVC = self.storyboard!.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        let rootNC = UINavigationController(rootViewController: InitalVC)
        APP_DELEGATE.window?.rootViewController = rootNC
    }
    
    
    
    func LoginVC(){
         AMEUserDefaults.userDefaults.setValue("2", forKey: "isUserLogIn")
         if UIDevice.current.userInterfaceIdiom == .phone {
            //Storyboard = UIStoryboard(name: "Main", bundle: nil)
        } else {
            // Storyboard = UIStoryboard(name: "iPad", bundle: nil)
        }
        let InitalVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let rootNC = UINavigationController(rootViewController: InitalVC)
        APP_DELEGATE.window?.rootViewController = rootNC
    }
}


extension CGRect {
    var center_: CGPoint { return CGPoint(x: midX, y: midY) }
}

extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}




extension UIView {
    
    func TopViewGradient(colors: [CGColor]){
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 70, height:  70))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.mask  = maskLayer
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func TopViewGradientWithoutRadius(colors: [CGColor]){
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 0, height:  0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.mask  = maskLayer
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIView {
    func HederViewGradient(colors: [CGColor]){
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 70, height:  70))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        // gradientLayer.mask  = maskLayer
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIButton{
    func BtnGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
         self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
}


// MARK:- Alert controller
func showAlertWithAction(_ viewController : UIViewController, message : String, action : ((UIAlertAction) -> Void)?) {
     let alertController = UIAlertController(title: appName, message: message, preferredStyle: UIAlertController.Style.alert)
     let okAction = UIAlertAction.init(title: "OK", style: .default, handler: action)
     alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
}

func showAlertWithCancelAndOkAction(_ viewController : UIViewController, message : String, cancelAction : ((UIAlertAction) -> Void)?, okAction : ((UIAlertAction) -> Void)?) {
     let alertController = UIAlertController(title: appName, message: message, preferredStyle: UIAlertController.Style.alert)
     let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: cancelAction)
    alertController.addAction(cancelAction)
     let okAction = UIAlertAction.init(title: "Logout", style: .default, handler: okAction)
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
}


func showAlertWithYesAndNoAction(_ viewController : UIViewController, message : String, cancelAction : ((UIAlertAction) -> Void)?, okAction : ((UIAlertAction) -> Void)?) {
     let alertController = UIAlertController(title: appName, message: message, preferredStyle: UIAlertController.Style.alert)
     let cancelAction = UIAlertAction.init(title: "No", style: .default, handler: cancelAction)
    alertController.addAction(cancelAction)
     let okAction = UIAlertAction.init(title: "Yes", style: .default, handler: okAction)
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
}



