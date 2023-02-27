//
//  SalesByClosedRetailVC.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 16/03/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import DatePicker


extension SalesByClosedRetailVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        if textField == self.etxdate {
            self.createDatePickerTodate()
        }
    }
}

class SalesByClosedRetailVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
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
        if indexPath.row == 0 {
            return CGFloat(self.mainModelArray[indexPath.row].items.count * 25)
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
        if indexPath.row == 0 {
            cell.isFirtsRow = true
        }
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
        let URL = "SalesByClosingNashmir.php?Branch=\(BusinessCenter)&Date=\(self.SelectedDate)&Terminal=\(terminal)"
        Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
            hideHUDForView()
            if JsonResponse == nil {
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            let status  = JsonResponse!["Response"] as? String ?? ""
            if status == "1", let content = JsonResponse!["Data"] as? NSArray {
                if content.count > 0 {
                    if let item = content[0] as? NSDictionary {
                        if let ShiftDetails = item["ShiftDetails"] as? NSArray {
                            if ShiftDetails.count > 0 {
                                if  let obj = ShiftDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "Closing Sales"
                                    a.title1 = "Description"
                                    a.title2 = ""
                                    a.title3 = "Values"
                                    a.items.append(SUbModel(item1: "Shift End By", item2: "", item3: obj["PRINTEDBY"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Shift Start Time", item2: "", item3: obj["SHIFTSTART"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Shift End Time", item2: "", item3: obj["SHIFTEND"] as? String ?? ""))
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let ShiftEndDetails = item["ShiftEndDetails"] as? NSArray {
                            if ShiftEndDetails.count > 0 {
                                if  let obj = ShiftEndDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "Shift End Report"
                                    a.title1 = "Description"
                                    a.title2 = ""
                                    a.title3 = "Amount"
                                    a.items.append(SUbModel(item1: "Item Sales", item2: "", item3: obj["ITEMSALES"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Bill Discount", item2: "", item3: obj["DISCOUNT"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Sales Before Tax", item2: "", item3: obj["SALESBEFORETAX"] as? String ?? ""))
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let ServiceTaxDetails = item["ServiceTaxDetails"] as? NSArray {
                            if ServiceTaxDetails.count > 0 {
                                if  let obj = ServiceTaxDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "SST Summary"
                                    a.title1 = "Tax Summury"
                                    a.title2 = ""
                                    a.title3 = "Amount(RM)"
                                    a.items.append(SUbModel(item1: "Service Tax 6%", item2: "", item3: obj["SERVICETAX6"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Service Tax 0%", item2: "", item3: obj["SERVICETAX0"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Sales After Tax", item2: "", item3: obj["SALESAFTERTAX"] as? String ?? ""))
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let PaymentTypeDetails = item["PaymentTypeDetails"] as? NSArray {
                            if PaymentTypeDetails.count > 0 {
                                if  let obj = PaymentTypeDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "Payment types"
                                    a.title1 = "Payment types"
                                    a.title2 = "Quantity"
                                    a.title3 = "Amount(RM)"
                                    a.items.append(SUbModel(item1: "Cash", item2: obj["SALESCASHQTY"] as? String ?? "", item3: obj["CASHSALE"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Card", item2: obj["SALESCARDQTY"] as? String ?? "", item3: obj["CARDSALE"] as? String ?? ""))
                                    
                                    if let PaymentModeDetails = item["PaymentModeDetails"] as? NSArray {
                                        var amt : Double = 0.0
                                        for x in PaymentModeDetails {
                                            if let dict = x as? NSDictionary {
                                                a.items.append(SUbModel(item1: dict["PAYMENT_MODE"] as? String ?? "", item2: "", item3: dict["AMOUNT"] as? String ?? ""))
                                                let tmp = dict["AMOUNT"] as? String ?? "0"
                                                amt = amt + Double(tmp)!
                                            }
                                        }
                                        a.items.append(SUbModel(item1: "Total amount with Tax", item2: "", item3: obj["TOTALSALES"] as? String ?? ""))
                                    }
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let CashBalancingDetails = item["CashBalancingDetails"] as? NSArray {
                            if CashBalancingDetails.count > 0 {
                                if let obj = CashBalancingDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "Cash Balancing"
                                    a.title1 = "Description"
                                    a.title2 = "Quantity"
                                    a.title3 = "Amount(RM)"
                                    a.items.append(SUbModel(item1: "Sales Cash(+)", item2: obj["SALESCASHQTY"] as? String ?? "", item3: obj["CASHSALE"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Float In(+)", item2: "", item3: obj["FLOAT_CASH"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Drop Out(-)", item2: "", item3: obj["DROP_CASH"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Payout(-)", item2: "", item3: obj["PAYOUT_CASH"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Employee Payout(-)", item2: "", item3: obj["EMP_PAYOUT"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Rounding (-)", item2: obj["ROUNDINGQTY"] as? String ?? "", item3: obj["SALESROUND"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Cash In Hand", item2: "", item3: obj["CASHINHAND"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Cash Short", item2: "", item3: obj["CASHSORT"] as? String ?? ""))
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let CashCountedDetails = item["CashCountedDetails"] as? NSArray {
                            if CashCountedDetails.count > 0 {
                                if  let obj = CashCountedDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "Cash Counted"
                                    a.title1 = "RM"
                                    a.title2 = "Count"
                                    a.title3 = "Amount(RM)"
                                    a.items.append(SUbModel(item1: "RM0.05(x)", item2: "0", item3: obj["R05"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM0.10(x)", item2: "0", item3: obj["R010"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM0.50(x)", item2: "0", item3: obj["R050"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM1.00(x)", item2: "0", item3: obj["R1"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM5.00(x)", item2: "0", item3: obj["R5"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM10.00(x)", item2: "0", item3: obj["R10"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM20.00(x)", item2: "0", item3: obj["R20"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM50.00(x)", item2: "0", item3: obj["R50"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "RM100.00(x)", item2: "0", item3: obj["R100"] as? String ?? ""))
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let SalesTypeDetails = item["SalesTypeDetails"] as? NSArray {
                            let a = MianModel()
                            a.maintitle = "Sales Types"
                            a.title1 = "Types"
                            a.title2 = "Quantity"
                            a.title3 = "Amount(RM)"
                            for x in SalesTypeDetails {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["SALES_TYPE"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["AMOUNT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        if let RefundVoidDetails = item["RefundVoidDetails"] as? NSArray {
                            if RefundVoidDetails.count > 0 {
                                if let obj = RefundVoidDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "Refund/Void/Pending Bills"
                                    a.title1 = "Description"
                                    a.title2 = "Quantity"
                                    a.title3 = "Amount(RM)"
                                    a.items.append(SUbModel(item1: "Refund", item2: obj["SALESREFUNDQTY"] as? String ?? "", item3: obj["REFUNDSALE"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Pre-Send Void", item2: obj["NPVOIDQTY"] as? String ?? "", item3: obj["NPVOID"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Post-Send Void", item2: obj["PVOIDQTY"] as? String ?? "", item3: obj["PVOID"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Bill Pending", item2: obj["PENDINGQTY"] as? String ?? "", item3: obj["PENDINGAMT"] as? String ?? ""))
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let OtherDetails = item["OtherDetails"] as? NSArray {
                            if OtherDetails.count > 0 {
                                if let obj = OtherDetails[0] as? NSDictionary {
                                    let a = MianModel()
                                    a.maintitle = "Other Details"
                                    a.title1 = "Description"
                                    a.title2 = ""
                                    a.title3 = "Count"
                                    a.items.append(SUbModel(item1: "Total Bills", item2: "", item3: obj["NOOFBILL"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Average Bills", item2: "", item3: obj["AVGBILL"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Start Reciept", item2: "", item3: obj["FBILL"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "End Reciept", item2: "", item3: obj["LBILL"] as? String ?? ""))
                                    a.items.append(SUbModel(item1: "Drawer Opened", item2: "", item3: obj["CASHDRAWOPENED"] as? String ?? ""))
                                    self.mainModelArray.append(a)
                                }
                            }
                        }
                        
                        if let VoidSales = item["VoidSales"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "Void Sales"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in VoidSales {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["PRINTED"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["AMT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        if let DepartmentSale = item["DepartmentSale"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "Department Sales"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in DepartmentSale {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["DEPARTMENT_NAME"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["TOTAL_AMOUNT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        if let ItemSales = item["ItemSales"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "Item Sales"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in ItemSales {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["ITEM"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["TOTAL_AMOUNT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        if let GroupSales = item["GroupSales"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "Group Sales"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in GroupSales {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["ID"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["TOTAL_AMOUNT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        if let WaiterSales = item["WaiterSales"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "Waiter Sales"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in WaiterSales {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["WAITER"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["AMT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        
                        if let CategorySales = item["CategorySales"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "Category Sales"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in CategorySales {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["CATEGORY_NAME"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["TOTAL_AMOUNT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        if let AddON = item["AddON"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "AddON"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in AddON {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["ADDON"] as? String ?? "Null", item2: dict["QTY"] as? String ?? "Null", item3: dict["TOTAL_AMOUNT"] as? String ?? "Null"))
                                }
                            }
                            self.mainModelArray.append(a)
                        }
                        
                        if let HourlySales = item["HourlySales"] as? NSArray {
                            let a = MianModel()
                            a.canExpand = true
                            a.maintitle = "Hourly Sales"
                            a.title1 = ""
                            a.title2 = ""
                            a.title3 = ""
                            for x in HourlySales {
                                if let dict = x as? NSDictionary {
                                    a.items.append(SUbModel(item1: dict["Hour"] as? String ?? "Null", item2: "", item3: dict["HRSALE"] as? String ?? "Null"))
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

        

class MianModel {
    var canExpand : Bool = false
    var maintitle = String()
    var title1 =  String()
    var title2 =  String()
    var title3 =  String()
    var items : [SUbModel] = []
}

class SUbModel {
    var item1 =  String()
    var item2 =  String()
    var item3 =  String()
    
    init(item1 : String, item2 : String, item3 : String){
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
    }
}
