//
//  SupplierPayoutVC.swift
//  AME_Boss_App
//
//  Created by Prabhakaran D on 27/12/2022.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import DatePicker



extension SupplierPayoutVC : UITextFieldDelegate, MenuSelectionProtocol {
    
    func dataPassing(name: String, isRetail: String, type: Int) {
        self.category1.text = name
        self.selectedDepId =  isRetail
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        if textField == self.etxTodate {
            self.createDatePickerTodate()
        }else{
            self.createDatePickerFromDate()
        }
    }
}



class SupplierPayoutVC: UIViewController ,  UITableViewDelegate, UITableViewDataSource  {
    
    
    var supplierList : [String] = []
    
    @IBOutlet weak var category1: MetrialTextfield!
    var testList : [String] = ["T1","T2","T3"]

    
    @IBOutlet weak var totalValue: UIButton!

    @IBOutlet weak var totalView: UIView!
    
    var payAmount : [Double] = []
    
    var selectedDepId : String = "1"
    var selectedCatId : String = "1"
    var departments : [Departments] = []
    var categories : [Departments] = []
    
    @IBOutlet weak var headerview: GradientView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var etxFromdate: MetrialTextfield!
    @IBOutlet weak var etxTodate: MetrialTextfield!
    @IBOutlet weak var centername: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    var subArray : [EmployeePayout] = []

    
    var SelectedFromDate = String()
    var SelectedToDate = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        btnSearch.layer.cornerRadius = 6
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        etxFromdate.text = result
        etxTodate.text = result
        formatter.dateFormat = "yyyy-MM-dd"
        SelectedFromDate  = formatter.string(from: date)
        SelectedToDate  = formatter.string(from: date)
        etxFromdate.delegate = self
        etxTodate.delegate = self
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        centername.text  = BusinessCenter
        
        
        tableView.register(UINib(nibName: "NewMadeTblCell", bundle: nil), forCellReuseIdentifier: "NewMadeTblCell")
    
        tableView.register(UINib(nibName: "PayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "PayoutTableViewCell")
    
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadSupplierList()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createDatePickerFromDate(){
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2015)!
        let today = Date()
        let maxDate = DatePickerHelper.shared.dateFrom(day: today.day(), month: today.month(), year: today.year())!
        // Create picker object
        let datePicker = DatePicker()
        // Setup
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                formatter.dateFormat = "dd-MM-yyyy"
                self.etxFromdate.text = formatter.string(from: selectedDate)
                
                formatter.dateFormat = "yyyy-MM-dd"
                self.SelectedFromDate  = formatter.string(from: selectedDate)
                self.tableView.reloadData()
            } else {
                print("Cancelled")
            }
        }
        // Display
        datePicker.show(in: self, on: self.view)
    }
    
    func createDatePickerTodate(){
        let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2015)!
        let today = Date()
        let maxDate = DatePickerHelper.shared.dateFrom(day: today.day(), month: today.month(), year: today.year())!
        // Create picker object
        let datePicker = DatePicker()
        // Setup
        datePicker.setup(beginWith: today, min: minDate, max: maxDate) { (selected, date) in
            if selected, let selectedDate = date {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                formatter.dateFormat = "dd-MM-yyyy"
                self.etxTodate.text = formatter.string(from: selectedDate)
                formatter.dateFormat = "yyyy-MM-dd"
                self.SelectedToDate  = formatter.string(from: selectedDate)
                self.tableView.reloadData()
            } else {
                print("Cancelled")
            }
        }
        // Display
        datePicker.show(in: self, on: self.view)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(115 + self.subArray.count * 25)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayoutTableViewCell") as! PayoutTableViewCell
        cell.prepareForReuse()
        cell.tableView.reloadData()
        cell.array = self.subArray
        if(!self.subArray.isEmpty){
            
            if (self.subArray[0].payType == nil) {
                cell.deffTitleLabel2.isHidden = true
            }
        
        }
        
        cell.tableView.reloadData()
        return cell
    }
    
    
    
    
    @IBAction func BtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func BtnSalesByItem(_ sender: UIButton) {
        if !isConnectedToNetwork() {
            self.displayAlertMessage(userMessage: defaultServerErrorMsg)
        } else {
            loadData()
        }
    }
    
    @IBAction func category1Clicked(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MenuListVC") as! MenuListVC
        vc.delegate = self
        let names = supplierList
        vc.list2 = names
        vc.list1 = names
        vc.type = 1
        self.present(vc, animated: true, completion: nil)
    }
    
    func loadData(){
        self.subArray.removeAll()
        self.payAmount.removeAll()
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        let dictParams = ["": ""]
        let testURL = "EmployeePayout.php?Branch=ALFA_SKYPOD&Terminal=C1&OpenDate=2020-02-02&CloseDate=2021-02-02&Employee=VIEW%20ALL"
        let testURL2 = "Payout.php?Branch=ALFA_SKYPOD&Terminal=C1&OpenDate=2020-02-02&CloseDate=2021-02-02&Supplier=AIS"
        
        
        let URL = ("Payout.php?Branch=" + BusinessCenter + "&Terminal=C1&OpenDate="
        + self.SelectedFromDate + "&CloseDate="
        + self.SelectedToDate + "&Supplier="
        + self.category1.text!).replacingOccurrences(of: " ", with: "%20")
        Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
            hideHUDForView()
            
            print(JsonResponse)
            if JsonResponse == nil {
                self.tableView.isHidden = true
                self.totalView.isHidden = true
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            if let Output = JsonResponse!["Output"] as? NSDictionary{
                if let data = Output["data"] as? NSArray {
                    for item in data {
                        if let obj = item as? NSDictionary {
                            
                            
                            if(obj["PAY_TYPE"] as? String == nil){
                                let a = EmployeePayout(payTo: obj["PAYTO"] as! String, payAmount: obj["PAY_AMOUNT"] as! String, payType: nil)
                                self.payAmount.append(Double( obj["PAY_AMOUNT"] as! String) ?? 0.0)
                                self.subArray.append(a)
                            }
                            else{
                                let a = EmployeePayout(payTo: obj["PAYTO"] as! String, payAmount: obj["PAY_AMOUNT"] as! String, payType: obj["PAY_TYPE"] as! String)
                                self.subArray.append(a)
                            }
                            
                          
                        }
                    }
                }
                
                else{
                    self.tableView.isHidden = true
                    self.totalView.isHidden = true
                    CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                    return
                }
            }
            
            else{
                self.tableView.isHidden = true
                self.totalView.isHidden = true
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            
            self.tableView.isHidden = false
            
            self.totalValue.setTitle( String(format: "%.2f", self.calculateTotalpayAmount(arr: self.payAmount)) , for: .normal)
            
          
            self.totalView.isHidden = false
     
            self.tableView.reloadData()
        
    }
    }
    
    
    func calculateTotalpayAmount( arr : [Double] ) -> Double {
        
        return arr.reduce(0, {$0 + $1})
        
    }
    
    
    func loadSupplierList() {
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        let dictParams = ["": ""]
        let URL = "EmpAndSupplierList.php?Branch=" + BusinessCenter
        Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
            hideHUDForView()
            
            print(JsonResponse)
            if JsonResponse == nil {
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            if let Output = JsonResponse!["Output"] as? NSDictionary{
                
                if let data = Output["data"] as? NSDictionary{
                    
                    if let employee = data["Supplier"] as? NSArray {
                        for item in employee {
                            if let obj = item as? NSDictionary {
                                self.supplierList.append(obj["SUPPLIER"] as! String)
                            }
                        }
                    }
                    
                }
            
            }
            
            else{
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            
            if self.supplierList.count > 0 {
                DispatchQueue.main.async {
                    self.category1.text = self.supplierList[0]
                    self.selectedDepId = self.supplierList[0]
                    self.loadData()
                }
            }
            
        }
    }
    


}
