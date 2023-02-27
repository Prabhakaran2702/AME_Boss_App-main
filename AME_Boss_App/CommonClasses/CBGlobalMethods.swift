//
//  CBGlobalMethods.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 10/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import Foundation
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import CoreLocation

// MARK: - Singleton

@objc(CBGlobalMethods)
public final class CBGlobalMethods: NSObject {
    
    @objc static let shared = CBGlobalMethods()
    
    /// Show alert
    @objc func ShowAlert(TitleString : String, MessageString : String, buttonTitle: String = "OK") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: TitleString, message: MessageString, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            alert.addAction(okAction)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}
