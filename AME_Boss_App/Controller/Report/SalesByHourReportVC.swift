//
//  SalesByHourReportVC.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 15/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import DatePicker

extension SalesByHourReportVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        if textField == self.etxTodate {
            self.createDatePickerTodate()
        }else{
            self.createDatePickerFromDate()
        }
    }
}


class SalesByHourReportVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerview: GradientView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var etxFromdate: MetrialTextfield!
    @IBOutlet weak var etxTodate: MetrialTextfield!
    @IBOutlet weak var centername: UILabel!
    var SelectedFromDate = String()
    var SelectedToDate = String()
    @IBOutlet weak var tableView: UITableView!
    
    var subArray : [TotalDay] = []
    var singleObj : TotalDay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
         // Do any additional setup after loading the view.
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        etxFromdate.text = result
        etxTodate.text = result
        formatter.dateFormat = "yyyy-MM-dd"
        SelectedFromDate  = formatter.string(from: date)
        SelectedToDate  = formatter.string(from: date)
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        etxFromdate.delegate = self
        etxTodate.delegate = self
        centername.text  = BusinessCenter
        
        tableView.register(UINib(nibName: "NewMadeTblCell", bundle: nil), forCellReuseIdentifier: "NewMadeTblCell")
        tableView.register(UINib(nibName: "SalesByDateCell", bundle: nil), forCellReuseIdentifier: "SalesByDateCell")
        tableView.register(UINib(nibName: "PieChartCell", bundle: nil), forCellReuseIdentifier: "PieChartCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openPieChart), name: Notification.Name("piechartClicked"), object: nil)
        
        APIs()
    }
    
    @objc func openPieChart(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChartVC") as! ChartVC
        let strings = self.singleObj!.array.map({ $0.mode })
        let numbers = self.singleObj!.array.map({ Double($0.amount) ?? 0.0 })
        vc.numberArray = numbers
        vc.stringArray = strings
        vc.titleString = "Sales By Hour"
        self.present(vc, animated: true)
    }
    
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
    
    @IBAction func BtnBack(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearch(_ sender: UIButton) {
        if !isConnectedToNetwork() {
            self.displayAlertMessage(userMessage: defaultServerErrorMsg)
        } else {
            APIs()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.singleObj == nil {
            return 0
        }else{
            return 3
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }else if indexPath.section == 1 {
            return CGFloat(115 + self.singleObj!.array.count * 25)
        }else{
            return CGFloat(175 + subArray[indexPath.row].array.count * 25)
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else{
            return subArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartCell") as! PieChartCell
            cell.dateLabel.text  = "Date From : " + SelectedFromDate + "  -  Date To : " + SelectedToDate
            cell.animateButton()
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SalesByDateCell") as! SalesByDateCell
            cell.prepareForReuse()
            cell.tableView.reloadData()
            cell.totalRetailLabel.text = self.singleObj!.totalAmount
            cell.totalSSTLabel.text = self.singleObj!.totalSST
            cell.totalDiscountLabel.text = self.singleObj!.totalDiscount
            cell.totalAmountLabel.text = self.singleObj!.totalRetail
            cell.deffTitleLabel.text = "Hour"
            cell.array = self.singleObj!.array
            cell.tableView.reloadData()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMadeTblCell") as! NewMadeTblCell
            cell.prepareForReuse()
            cell.tableView.reloadData()
            cell.dateLabel.text = subArray[indexPath.row].paymentDate
            cell.totalRetailLabel.text = subArray[indexPath.row].totalAmount
            cell.totalSSTLabel.text = subArray[indexPath.row].totalSST
            cell.totalDiscountLabel.text = subArray[indexPath.row].totalDiscount
            cell.totalAmountLabel.text = subArray[indexPath.row].totalRetail
            cell.deffTitleLabel.text = "Hour"
            cell.array = subArray[indexPath.row].array
            cell.tableView.reloadData()
            return cell
        }
    }
    
    
    func APIs(){
        self.subArray.removeAll()
        self.singleObj = nil
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        let dictParams = ["": ""]
        let URL = "SalesByHourMobile.php?Branch=" + BusinessCenter + "&FromDate=" + SelectedFromDate + "&ToDate=" + SelectedToDate
        print(URL)
        Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
            hideHUDForView()
            if JsonResponse == nil {
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            let status = JsonResponse!["Response"] as? String ?? ""
            if status == "1" {
                if let header = JsonResponse!["SummeryData"] as? NSArray {
                    let content = JsonResponse!["Data"] as? NSArray ?? NSArray()
                    var total_ret_amount = 0.0 , total_discount_amount = 0.0 , total_sst_amount = 0.0 , total_amount  = 0.0
                    do {
                        let data = try JSONSerialization.data(withJSONObject: header)
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                        self.singleObj = TotalDay()
                        if let array = jsonResult as? NSArray {
                            for obj in array {
                                if let dict = obj as? NSDictionary {
                                    // Now reference the data you need using:
                                    let  dictionary  = dict.value(forKey: "SummeryDetails")
                                    if let array2 = dictionary as? NSArray{
                                        for obj2 in array2 {
                                            if let dict2  = obj2 as? NSDictionary {
                                                let Hour = dict2.value(forKey: "Hour") as! String
                                                let WITHSST = dict2.value(forKey: "WITHSST") as! String
                                                let DISCOUNT = dict2.value(forKey: "DISCOUNT") as! String
                                                let SST = dict2.value(forKey: "SST") as! String
                                                let WITHOUTSST = dict2.value(forKey: "WITHOUTSST") as! String
                                                /** DeptName String Creating a String Array   */
                                                //Retail Amount
                                                if let amount_ = Double(WITHSST) {
                                                    total_ret_amount += amount_
                                                }
                                                if let discount_ = Double(DISCOUNT) {
                                                    total_discount_amount += discount_
                                                }
                                                if let sst_ = Double(SST) {
                                                    total_sst_amount += sst_
                                                }
                                                if let total_ = Double(WITHOUTSST) {
                                                    total_amount += total_
                                                }
                                                let SingleItemObj = SingleItem(mode: Hour, sst: SST, amount: WITHSST)
                                                self.singleObj!.array.append(SingleItemObj)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        self.singleObj!.totalRetail = String(format:"%01.2f",total_ret_amount)
                        self.singleObj!.totalAmount = String(format: "%01.2f", total_amount)
                        self.singleObj!.totalSST = String(format: "%01.2f", total_sst_amount)
                        self.singleObj!.totalDiscount = String(format: "%01.2f", total_discount_amount)
                        /** Added the new data in  Muti Dimensional Array   */
                        
                        /** Start Content Part  - Sale Date Header */
                        total_ret_amount = 0.0
                        total_discount_amount = 0.0
                        total_sst_amount = 0.0
                        total_amount  = 0.0
                        
                        let content_data = try JSONSerialization.data(withJSONObject: content)
                        let Content_jsonResult = try JSONSerialization.jsonObject(with: content_data, options: [])
                        if let array = Content_jsonResult as? NSArray {
                            for obj in array {
                                let TotalDayObj = TotalDay()
                                if let dict = obj as? NSDictionary {
                                    // Header
                                    TotalDayObj.paymentDate = dict.value(forKey: "SalesDateHeader") as? String ?? ""
                                    //  Child
                                    let  sale_date_child  = dict.value(forKey: "SalesDetails")
                                    if let array2 = sale_date_child as? NSArray{
                                        for obj2 in array2 {
                                            if let dict2  = obj2 as? NSDictionary {
                                                let Hour = dict2.value(forKey: "Hour") as! String
                                                let WITHSST = dict2.value(forKey: "WITHSST") as! String
                                                let discount_amt = dict2.value(forKey: "DISCOUNT") as! String
                                                let SST = dict2.value(forKey: "SST") as! String
                                                let total_amt = dict2.value(forKey: "WITHOUTSST") as! String
                                                
                                                if let amount_ = Double(WITHSST) {
                                                    total_ret_amount += amount_
                                                }
                                                if let discount_ = Double(discount_amt) {
                                                    total_discount_amount += discount_
                                                }
                                                if let sst_ = Double(SST) {
                                                    total_sst_amount += sst_
                                                }
                                                if let total_ = Double(total_amt) {
                                                    total_amount += total_
                                                }
                                                
                                                let SingleItemObj = SingleItem(mode: Hour, sst: SST, amount: WITHSST)
                                                TotalDayObj.array.append(SingleItemObj)
                                            }
                                        }
                                    }
                                }
                                TotalDayObj.totalRetail = String(format:"%01.2f",total_ret_amount)
                                TotalDayObj.totalAmount = String(format: "%01.2f", total_amount)
                                TotalDayObj.totalSST = String(format: "%01.2f", total_sst_amount)
                                TotalDayObj.totalDiscount = String(format: "%01.2f", total_discount_amount)
                                self.subArray.append(TotalDayObj)
                                total_ret_amount = 0.0
                                total_discount_amount = 0.0
                                total_sst_amount = 0.0
                                total_amount  = 0.0
                            }
                        }
                        /** End Content Part */
                        self.tableView.reloadData()
                    }catch let error {
                        print(error.localizedDescription)
                    }
                }else{
                    let message : String = JsonResponse!["Message"] as? String ?? "Some unknown error!"
                    CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: message)
                }
            }
            else {
                self.subArray.removeAll()
                self.singleObj = nil
                self.tableView.reloadData()
                self.displayAlertMessage(userMessage: "Sorry, No data available")
            }
        }
    }
    
}
