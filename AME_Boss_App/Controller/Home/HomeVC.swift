//
//  HomeVC.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 14/01/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, BranchProtocol {
    
    func dataPassing(name: String, isRetail: String) {
        let current : String = UserDefaults.standard.string(forKey: "IsRetail") ?? ""
        if current == isRetail {
            self.EtxCenterName.text = name
            self.IsRetail = isRetail
            UserDefaults.standard.setValue(name, forKey: "BusinessCenter")
            UserDefaults.standard.setValue(isRetail, forKey: "IsRetail")
            DoGetBusinessInfo()
        }else {
            let br =  current == "1" ? "restaurent" : "retail"
            let message = "If your selected branch is based on \(br) once back to login and proceed further. Are you sure you want to logout?"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let alertController = UIAlertController(title: "Confirmation", message: message, preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
               alertController.addAction(cancelAction)
                let okAction = UIAlertAction.init(title: "Logout", style: .default) { action in
                    UserDefaults.standard.setValue("2", forKey: "isUserLogIn")
                    self.WelcomeVC()
                }
               alertController.addAction(okAction)
               self.present(alertController, animated: true, completion: nil)
            }
            
            
        }
    }
    
    func dataPassing(name: String) {
        
    }
    
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var SaleByItemView: UIView!
    @IBOutlet weak var SaleByDateView: UIView!
    @IBOutlet weak var SaleByDepView: UIView!
    @IBOutlet weak var SaleByCurrentView: UIView!
    @IBOutlet weak var SaleByVoidView: UIView!
    @IBOutlet weak var SaleByClosedView: UIView!
    @IBOutlet weak var EtxCenterName: MetrialTextfield!
    @IBOutlet weak var BusinessName: UILabel!
    
    var tapGesture = UITapGestureRecognizer()
    var IsRetail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.SaleByDateView.isUserInteractionEnabled = true
        self.SaleByItemView.isUserInteractionEnabled  = true
        self.SaleByDepView.isUserInteractionEnabled  = true
        self.SaleByCurrentView.isUserInteractionEnabled = true
        self.SaleByVoidView.isUserInteractionEnabled  = true
        self.SaleByClosedView.isUserInteractionEnabled = true
        
        let mytapGestureRecognizer_ = UITapGestureRecognizer(target: self, action: #selector(myTapAction_SaleByDate))
        mytapGestureRecognizer_.numberOfTapsRequired = 1
        self.SaleByDateView.addGestureRecognizer(mytapGestureRecognizer_)
        
        let mytapGestureRecognizer_item = UITapGestureRecognizer(target: self, action: #selector(myTapAction_SaleByItem))
        mytapGestureRecognizer_item.numberOfTapsRequired = 1
        self.SaleByItemView.addGestureRecognizer(mytapGestureRecognizer_item)
        
        let mytapGestureRecognizer_dep = UITapGestureRecognizer(target: self, action: #selector(myTapAction_SaleByDep))
        mytapGestureRecognizer_item.numberOfTapsRequired = 1
        self.SaleByDepView.addGestureRecognizer(mytapGestureRecognizer_dep)
        
        let mytapGestureRecognizer_current = UITapGestureRecognizer(target: self, action: #selector(myTapAction_SaleByCurrent))
        mytapGestureRecognizer_item.numberOfTapsRequired = 1
        self.SaleByCurrentView.addGestureRecognizer(mytapGestureRecognizer_current)
        
        let mytapGestureRecognizer_void = UITapGestureRecognizer(target: self, action: #selector(myTapAction_SaleByVoid))
        mytapGestureRecognizer_item.numberOfTapsRequired = 1
        self.SaleByVoidView.addGestureRecognizer(mytapGestureRecognizer_void)
        
        let mytapGestureRecognizer_closed = UITapGestureRecognizer(target: self, action: #selector(myTapAction_SaleByClosed))
        mytapGestureRecognizer_item.numberOfTapsRequired = 1
        self.SaleByClosedView.addGestureRecognizer(mytapGestureRecognizer_closed)
        
        
        DoGetBusinessInfo()
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        EtxCenterName.text = BusinessCenter
        
    }
    
    
    
    func DoGetBusinessInfo() {
        let defaults = UserDefaults.standard
        let businessname = defaults.string(forKey: "BusinessName")!
        BusinessName.text = businessname
        self.IsRetail = defaults.string(forKey: "IsRetail")!
        
    }
    
    @objc func myTapAction_SaleByDate(recognizer: UITapGestureRecognizer) {
        self.pushToVc(identifier: "SalesByDateReportVC")
    }
    
    @objc func myTapAction_SaleByItem(recognizer: UITapGestureRecognizer) {
        self.pushToVc(identifier: "SaleByItemReportVC")
    }
    
    
    @objc func myTapAction_SaleByDep(recognizer: UITapGestureRecognizer) {
        self.pushToVc(identifier: "SalesByDepReportVC")
    }
    
    @objc func myTapAction_SaleByCurrent(recognizer: UITapGestureRecognizer) {
        self.pushToVc(identifier: "SalesByCurrentVC")
    }
    
    @objc func myTapAction_SaleByVoid(recognizer: UITapGestureRecognizer) {
        self.pushToVc(identifier: "SalesByVoidVC")
    }
    
    
    @objc func myTapAction_SaleByClosed(recognizer: UITapGestureRecognizer) {
        let defaults = UserDefaults.standard
        let businessname = defaults.string(forKey: "BusinessName") ?? ""
        if businessname == "NASMIR" || businessname == "THAQWA" {
            self.pushToVc(identifier: "SalesByClosedRetailVC")
        } else if businessname == "INDIAGATEBOSS" {
            self.pushToVc(identifier: "SalesClosedIndiaGateVC")
        }else if businessname == "PELITA1331" {
            self.pushToVc(identifier: "SalesClosedPelitaVC")
        } else {
            self.pushToVc(identifier: "SalesByClosedRetailVC")
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        topview.TopViewGradientWithoutRadius(colors: [UIColor(red: 40/255, green: 60/225, blue: 134/225, alpha: 1).cgColor ,UIColor(red: 69/255, green: 162/225, blue: 71/225, alpha: 1).cgColor])
        CATransaction.commit()
    }
    
    
    
    
    
    
    @IBAction func BtnSalesByDate(_ sender: Any) {
        self.pushToVc(identifier: "SalesByDateReportVC")
    }
    
    
    
    
    @IBAction func BtnSalesByDept(_ sender: Any) {
        self.pushToVc(identifier: "SalesByDepReportVC")
    }
    
    
    @IBAction func BtnSalesByItem(_ sender: Any) {
        self.pushToVc(identifier: "SaleByItemReportVC")
    }
    
    
    @IBAction func BtnSalesByVoid(_ sender: Any) {
        
        self.pushToVc(identifier: "SalesByVoidVC")
        
    }
    
    
    @IBAction func BtnSalesByCurrent(_ sender: Any) {
        
        self.pushToVc(identifier: "SalesByCurrentVC")
        
    }
    
    
    @IBAction func salesByWaiter(_ sender: Any) {
        self.pushToVc(identifier: "SalesByWaiterReportVC")
    }
    
    @IBAction func salesByHour(_ sender: Any) {
        self.pushToVc(identifier: "SalesByHourReportVC")
    }
    
    
    @IBAction func BtnSalesByClosed(_ sender: Any) {
        let defaults = UserDefaults.standard
        let businessname = defaults.string(forKey: "BusinessName") ?? ""
        
        if businessname == "NASMIR" || businessname == "THAQWA" {
            self.pushToVc(identifier: "SalesByClosedRetailVC")
        } else {
            
        }
    }
    
    
    @IBAction func salesByCategory(_ sender: Any) {
        self.pushToVc(identifier: "SalesByCategoryVC")
    }
    
    @IBAction func employeeAttendance(_ sender: Any) {
        self.pushToVc(identifier: "EmployeeAttendanceVC")
    }
    
    @IBAction func salesByBill(_ sender: Any) {
        self.pushToVc(identifier: "SalesByBillVC")
    }
    
    @IBAction func salesByItemBill(_ sender: Any) {
        self.pushToVc(identifier: "SalesByItemBillVC")
    }
    
    
    
    @IBAction func employeePayoutBtn(_ sender: Any) {
        
        self.pushToVc(identifier: "EmployeePayoutVC")
    }
    
    
    
    @IBAction func supplierPayoutBtn(_ sender: Any) {
        
        self.pushToVc(identifier: "SupplierPayoutVC")
    }
    
    
    
    
    
    @IBAction func BtnBack(_ sender: UIButton) {
        showAlertWithCancelAndOkAction(self, message: "Are you sure want to Logout ?", cancelAction: { (action) in
        }) { (action) in
            UserDefaults.standard.setValue("2", forKey: "isUserLogIn")
            self.WelcomeVC()
        }
    }
    
    @IBAction func BtnSelectTerminal(_ sender: UIButton) {
        let VC  = self.storyboard?.instantiateViewController(identifier: "BrachListVC") as! BrachListVC
        VC.delegate = self
        self.present(VC, animated: true, completion: nil)
    }
    
    
    
    
}
