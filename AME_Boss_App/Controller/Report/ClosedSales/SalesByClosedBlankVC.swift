//
//  SalesByClosedBlankVC.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 11/06/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import DatePicker


extension SalesByClosedBlankVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        
    }
}


class SalesByClosedBlankVC: UIViewController {
    
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var centername: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        centername.text = BusinessCenter
    }
     
    
    @IBAction func BtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
