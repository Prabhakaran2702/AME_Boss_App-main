//
//  SalesByVoidVC.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 15/02/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import DatePicker

extension SalesByVoidVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        if textField == self.etxTodate {
            self.createDatePickerTodate()
        }else{
            self.createDatePickerFromDate()
        }
    }
}

class SalesByVoidVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var centername: UILabel!
    @IBOutlet weak var etxFromdate: MetrialTextfield!
    @IBOutlet weak var etxTodate: MetrialTextfield!
    let datePicker = UIDatePicker()
    var SelectedFromDate = String()
    var SelectedToDate = String()
    @IBOutlet weak var tableView: UITableView!
    
    var secondArray : [TotalVoid] = []
     
    var voidTopArray : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        btnSearch.layer.cornerRadius = 6
        centername.text = BusinessCenter
                
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        etxFromdate.text = result
        etxTodate.text = result
        formatter.dateFormat = "yyyy-MM-dd"
        SelectedFromDate  = formatter.string(from: date)
        SelectedToDate  = formatter.string(from: date)
                
        tableView.dataSource = self
        tableView.delegate = self
        
        etxFromdate.delegate = self
        etxTodate.delegate = self
        
        tableView.register(UINib(nibName: "PieChartCell", bundle: nil), forCellReuseIdentifier: "PieChartCell")
        tableView.register(UINib(nibName: "NewMadeSingleCell", bundle: nil), forCellReuseIdentifier: "NewMadeSingleCell")
        tableView.register(UINib(nibName: "VoidSecondCell", bundle: nil), forCellReuseIdentifier: "VoidSecondCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.openPieChart), name: Notification.Name("piechartClicked"), object: nil)
        
        APIs()
    }
    
    @objc func openPieChart(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChartVC") as! ChartVC
        var stringArray : [String] = []
        var numberArray : [Double] = []
        for item in self.voidTopArray {
            stringArray.append(item[0])
            numberArray.append(Double(item[1]) ?? 0.0)
        }
        numberArray.removeLast()
        stringArray.removeLast()
        vc.numberArray = numberArray
        vc.stringArray = stringArray
        vc.titleString = "Sales By Void"
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }else if indexPath.section == 1 {
            return 25
        }else{
            var height : CGFloat = 0.0
            height = CGFloat(self.secondArray[indexPath.row].print_array.count) * 25.0 + 190.0
            height = height + CGFloat(self.secondArray[indexPath.row].non_print_array.count) * 25.0
            return height
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return self.voidTopArray.count
        }else{
            return self.secondArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartCell") as! PieChartCell
            cell.dateLabel.text  = "Date From : " + SelectedFromDate + "  -  Date To : " + SelectedToDate
            cell.animateButton()
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMadeSingleCell") as! NewMadeSingleCell
            cell.modeLabel.text = "    " + self.voidTopArray[indexPath.row][0]
            cell.sstLabel.text = self.voidTopArray[indexPath.row][1]
            cell.amountLabel.text = ""
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoidSecondCell") as! VoidSecondCell
            cell.prepareForReuse()
            cell.array = self.secondArray[indexPath.row].print_array
            cell.array2 = self.secondArray[indexPath.row].non_print_array
            cell.dateLabel.text = self.secondArray[indexPath.row].paymentDate
            cell.totalPrintedLabel.text = self.secondArray[indexPath.row].totalPrinted
            cell.totalNonPrintedLabel.text = self.secondArray[indexPath.row].totalNotPrinted
            cell.tableView.reloadData()
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func APIs(){
        self.voidTopArray.removeAll()
        self.secondArray.removeAll()
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        let dictParams = ["": ""]
        let URL =  "SalesByVoid.php?Branch=" + BusinessCenter + "&FromDate=" + SelectedFromDate + "&ToDate=" + SelectedToDate
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
                    var total_ret_amount = 0.0
                    do {
                        let data = try JSONSerialization.data(withJSONObject: header)
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                        if let array = jsonResult as? NSArray {
                            for obj in array {
                                if let dict = obj as? NSDictionary {
                                    // Now reference the data you need using:
                                    let  dictionary  = dict.value(forKey: "SummeryDetails")
                                    if let array2 = dictionary as? NSArray{
                                        for obj2 in array2 {
                                            if let dict2  = obj2 as? NSDictionary {
                                                let PRINTED = dict2.value(forKey: "PRINTED") as! String
                                                let AMOUNT = dict2.value(forKey: "AMOUNT") as! String
                                                /** DeptName String Creating a String Array   */
                                                //Retail Amount
                                                if let amount_ = Double(AMOUNT) {
                                                    total_ret_amount += amount_
                                                }
                                                
                                                var myArray : [String] = []
                                                myArray.append(PRINTED)
                                                myArray.append(AMOUNT)
                                                self.voidTopArray.append(myArray)
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        var myArray : [String] = []
                        myArray.append("TOTAL")
                        myArray.append(String(format:"%01.2f",total_ret_amount))
                        self.voidTopArray.append(myArray)
                        
                        for temp in content {
                            if let item = temp as? NSDictionary {
                                let obj = TotalVoid()
                                var printTotal : Double = 0.0
                                var nonPrintTotal : Double = 0.0
                                obj.paymentDate = item["SaleByVoidHeader"] as? String ?? ""
                                for data in item["SaleByVoidDetPrint"] as! NSArray{
                                    if let dict = data as? NSDictionary {
                                        let PRODUCT : String = dict["PRODUCT"] as! String
                                        let CANCELBY : String = dict["CANCELBY"] as! String
                                        let AMOUNT : String = dict["AMOUNT"] as! String
                                        let singleObj = SingleVoid(PRODUCT: PRODUCT, CANCELBY: CANCELBY, AMOUNT: AMOUNT)
                                        obj.print_array.append(singleObj)
                                        printTotal = printTotal + (Double(AMOUNT) ?? 0)
                                    }
                                }
                                
                                for data in item["SaleByVoidDetNonPrint"] as! NSArray{
                                    if let dict = data as? NSDictionary {
                                        let PRODUCT : String = dict["PRODUCT"] as! String
                                        let CANCELBY : String = dict["CANCELBY"] as! String
                                        let AMOUNT : String = dict["AMOUNT"] as! String
                                        let singleObj = SingleVoid(PRODUCT: PRODUCT, CANCELBY: CANCELBY, AMOUNT: AMOUNT)
                                        obj.non_print_array.append(singleObj)
                                        nonPrintTotal = nonPrintTotal + (Double(AMOUNT) ?? 0)
                                    }
                                }
                                
                                obj.totalNotPrinted = String(format:"%01.2f",nonPrintTotal)
                                obj.totalPrinted = String(format:"%01.2f",printTotal)
                                self.secondArray.append(obj)
                            }
                        }
                        
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
                self.voidTopArray.removeAll()
                self.secondArray.removeAll()
                self.tableView.reloadData()
                self.displayAlertMessage(userMessage: "Sorry, No data available")
            }
        }
    }
     
}


class TotalVoid {
    var paymentDate : String = ""
    var totalPrinted : String = ""
    var totalNotPrinted : String = ""
    var print_array : [SingleVoid] = []
    var non_print_array : [SingleVoid] = []
}

class SingleVoid{
    
    var PRODUCT : String = ""
    var CANCELBY : String = ""
    var AMOUNT : String = ""
    
    init(PRODUCT:String, CANCELBY:String, AMOUNT:String){
        self.PRODUCT = PRODUCT
        self.CANCELBY = CANCELBY
        self.AMOUNT = AMOUNT
    }
}
