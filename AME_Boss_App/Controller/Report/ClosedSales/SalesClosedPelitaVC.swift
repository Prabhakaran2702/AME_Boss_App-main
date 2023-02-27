//
//  SalesClosedPelitaVC.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 17/06/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import DatePicker

extension SalesClosedPelitaVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        if textField == self.etxdate {
            self.createDatePickerTodate()
        }
    }
}

class SalesClosedPelitaVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var clientServerButton: UIButton!
    
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    var SelectedDate = String()
    @IBOutlet weak var centername: UILabel!
    @IBOutlet weak var etxTerminal: MetrialTextfield!
    @IBOutlet weak var etxdate: MetrialTextfield!
    @IBOutlet weak var tableView: UITableView!
    
    var mainModelArray : [MianModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        
        clientServerButton.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.5, options:  [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.clientServerButton.alpha = 0.0

        }, completion: nil)
        
        tableView.register(UINib(nibName: "CustomTblCell", bundle: nil), forCellReuseIdentifier: "CustomTblCell")
        tableView.register(UINib(nibName: "ExpandCell", bundle: nil), forCellReuseIdentifier: "ExpandCell")
        
        
        
        centername.text = BusinessCenter
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        
        etxdate.text = result
        
        formatter.dateFormat = "yyyy-MM-dd"
        self.SelectedDate = formatter.string(from: date)
        
        tableView.dataSource = self
        tableView.delegate = self
        etxdate.delegate = self
        btnSearch.layer.cornerRadius = 6
        
        APIs()
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
                self.etxdate.text = formatter.string(from: selectedDate)
                
                formatter.dateFormat = "yyyy-MM-dd"
                self.SelectedDate  = formatter.string(from: selectedDate)
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    
    @IBAction func BtnSearch(_ sender: UIButton) {
        if !isConnectedToNetwork() {
            self.displayAlertMessage(userMessage: defaultServerErrorMsg)
        } else {
            if self.etxTerminal.text!.count != 0 {
                APIs()
            } else {
                self.displayAlertMessage(userMessage: "Enter the terminal")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mainModelArray[indexPath.row].canExpand {
            return 45
        }
        return CGFloat(50 + self.mainModelArray[indexPath.row].items.count * 25)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mainModelArray[indexPath.row].canExpand {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandCell
            cell.mainLabel.text = self.mainModelArray[indexPath.row].maintitle
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTblCell") as! CustomTblCell
        cell.prepareForReuse()
        
        cell.height2.constant = 0
        
        cell.setCellvalues(obj: self.mainModelArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.mainModelArray[indexPath.row].canExpand {
            let vc = self.storyboard?.instantiateViewController(identifier: "SalesByClosedRetailMoreVC") as! SalesByClosedRetailMoreVC
            vc.items = self.mainModelArray[indexPath.row].items
            vc.myTitle = self.mainModelArray[indexPath.row].maintitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func APIs() {
        self.mainModelArray.removeAll()
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        let dictParams = ["": ""]
        let terminal: String = self.etxTerminal.text!
        let URL = "SalesByClosingPelita.php?Branch=\(BusinessCenter)&Date=\(self.SelectedDate)&Terminal=\(terminal)"
        Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
            hideHUDForView()
            if JsonResponse == nil {
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            let status  = JsonResponse!["Response"] as? String ?? ""
            if status == "1", let content = JsonResponse!["Data"] as? NSArray {
                if content.count > 0 {
                    var ttt : Int = 0
                    for temp in content {
                        ttt =  ttt + 1
                        if let item = temp as? NSDictionary {
                            let a = MianModel()
                            a.maintitle = "Primary Details"
                            if ttt == 1 {
                                a.maintitle = "Closing Report - Shift 1"
                            }else if ttt == 2 {
                                a.maintitle = "Closing Report - Shift 2"
                            }else {
                                a.maintitle = "Closing Total Report"
                            }
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            
                            
                            if let ShiftDetails = item["ShiftDetails"] as? NSArray {
                                if ShiftDetails.count > 0 {
                                    if  let obj = ShiftDetails[0] as? NSDictionary {
                                        
                                        a.items.append(SUbModel(item1: "Terminal", item2: "", item3: terminal))
                                        a.items.append(SUbModel(item1: "Cashier", item2: "", item3: obj["PRINTEDBY"] as? String ?? "--"))
                                        a.items.append(SUbModel(item1: "Opening Time", item2: "", item3: obj["SHIFTSTART"] as? String ?? "--"))
                                        a.items.append(SUbModel(item1: "Closing Time", item2: "", item3: obj["SHIFTEND"] as? String ?? "--"))
    
                                    }
                                }
                            }
                            
                            if let PrimaryDetails = item["PrimaryDetails"] as? NSArray {
                                if PrimaryDetails.count > 0 {
                                    if let obj = PrimaryDetails[0] as? NSDictionary {
                                        if let CASHSALE = obj["CASHSALE"] as? String {
                                            a.items.append(SUbModel(item1: "Cash sales", item2: "", item3: CASHSALE))
                                        }else if let CASHSALE = obj["CASHSALE"] as? Double {
                                            a.items.append(SUbModel(item1: "Cash sales", item2: "", item3: "\(CASHSALE)"))
                                        }
                                        
                                        if let CARDSALE = obj["CARDSALE"] as? String {
                                            a.items.append(SUbModel(item1: "Card sales", item2: "", item3: CARDSALE))
                                        }else if let CARDSALE = obj["CARDSALE"] as? Double {
                                            a.items.append(SUbModel(item1: "Card sales", item2: "", item3: "\(CARDSALE)"))
                                        }
                                    }
                                }
                            }
                            
                            
                            if let PaymentModeDetails = item["PaymentModeDetails"] as? NSArray {
                                for x in PaymentModeDetails {
                                    if let dict = x as? NSDictionary {
                                        a.items.append(SUbModel(item1: dict["PAYMENT_MODE"] as? String ?? "0.00", item2: "", item3: dict["AMOUNT"] as? String ?? ""))
                                    }
                                }
                            }
                            
                            
                            if let PrimaryDetails = item["PrimaryDetails"] as? NSArray {
                                if PrimaryDetails.count > 0 {
                                    if let obj = PrimaryDetails[0] as? NSDictionary {
                                        if let TOTALSALES = obj["TOTALSALES"] as? String {
                                            a.items.append(SUbModel(item1: "Total sales", item2: "", item3: TOTALSALES))
                                        }else if let TOTALSALES = obj["TOTALSALES"] as? Double {
                                            a.items.append(SUbModel(item1: "Total sales", item2: "", item3: "\(TOTALSALES)"))
                                        }
                                        
                                        if let TotalGST = obj["TotalGST"] as? String {
                                            a.items.append(SUbModel(item1: "Total SST", item2: "", item3: TotalGST))
                                        }else if let TotalGST = obj["TotalGST"] as? Double {
                                            a.items.append(SUbModel(item1: "Total SST", item2: "", item3: "\(TotalGST)"))
                                        }
                                        
                                        if let VoucherAmt = obj["VoucherAmt"] as? String {
                                            a.items.append(SUbModel(item1: "Total Voucher", item2: "", item3: VoucherAmt))
                                        }else if let VoucherAmt = obj["VoucherAmt"] as? Double {
                                            a.items.append(SUbModel(item1: "Total Voucher", item2: "", item3: "\(VoucherAmt)"))
                                        }
                                        
                                        if let NoOfBill = obj["NoOfBill"] as? String {
                                            a.items.append(SUbModel(item1: "No of Bills", item2: "", item3: NoOfBill))
                                        }else if let NoOfBill = obj["NoOfBill"] as? Double {
                                            a.items.append(SUbModel(item1: "No of Bills", item2: "", item3: "\(NoOfBill)"))
                                        }
                                        
                                        
                                    }
                                }else {
                                    a.items.append(SUbModel(item1: "Total sales", item2: "", item3: "0"))
                                    a.items.append(SUbModel(item1: "Total SST", item2: "", item3: "0"))
                                    a.items.append(SUbModel(item1: "Total Voucher", item2: "", item3: "0"))
                                    a.items.append(SUbModel(item1: "No of Bills", item2: "", item3: "0"))
                                }
                            }
                            
                            
                            
                            self.mainModelArray.append(a)
                            
                        }
                    }
                    
                    
                }else{
                    self.displayAlertMessage(userMessage: "Sorry, No data available")
                }
            } else {
                self.displayAlertMessage(userMessage: "Sorry, No data available")
            }
            
            self.tableView.reloadData()
        }
    }
    
}
