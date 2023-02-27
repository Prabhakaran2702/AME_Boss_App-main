//
//  SupplierVC.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 16/06/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class SupplierVC: UIViewController {

    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var BusinessName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let businessname = defaults.string(forKey: "BusinessName")!
        BusinessName.text = businessname
        
    }
    
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        topview.TopViewGradientWithoutRadius(colors: [UIColor(red: 40/255, green: 60/225, blue: 134/225, alpha: 1).cgColor ,UIColor(red: 69/255, green: 162/225, blue: 71/225, alpha: 1).cgColor])
        CATransaction.commit()
    }

}
