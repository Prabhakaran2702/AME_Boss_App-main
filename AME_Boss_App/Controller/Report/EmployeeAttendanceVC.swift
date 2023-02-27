//
//  EmployeeAttendanceVC.swift
//  AME_Boss_App
//
//  Created by Prabhakaran D on 11/01/2023.
//  Copyright © 2023 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import DatePicker
import Foundation



extension EmployeeAttendanceVC : UITextFieldDelegate, MenuSelectionProtocol {
    
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


class EmployeeAttendanceVC: UIViewController  ,  UITableViewDelegate, UITableViewDataSource  {
    
    var employeeList : [String] = []
    
    
    @IBOutlet weak var category1: MetrialTextfield!
 
    
    var selectedDepId : String = "1"
    var selectedCatId : String = "1"

    
    @IBOutlet weak var headerview: GradientView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var etxFromdate: MetrialTextfield!
    @IBOutlet weak var etxTodate: MetrialTextfield!
    @IBOutlet weak var centername: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    
    var SelectedFromDate = String()
    var SelectedToDate = String()
    
    var subArray : [Attendance] = []

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
    
        tableView.register(UINib(nibName: "AttendanceTableViewCell", bundle: nil), forCellReuseIdentifier: "AttendanceTableViewCell")
    
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadEmployeeList()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendanceTableViewCell") as! AttendanceTableViewCell
        cell.prepareForReuse()
        cell.tableView.reloadData()
        cell.array = self.subArray
        if(!self.subArray.isEmpty){
            
            if (self.subArray[0].dateOut == nil) {
                cell.deffTitleLabel.text = "Employee Name"
                cell.deffTitleLabel2.isHidden = true
            }
            else{
                cell.deffTitleLabel.text = "Date In"
                cell.deffTitleLabel2.isHidden = false
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
        let names = employeeList
        vc.list2 = names
        vc.list1 = names
        vc.type = 1
        self.present(vc, animated: true, completion: nil)
        
    }
    
    var loaderCalled = false
    
    func loadData(){
        
    
        self.subArray.removeAll()
        let defaults = UserDefaults.standard
        let BusinessCenter = defaults.string(forKey: "BusinessCenter")!
        let dictParams = ["": ""]
       
        
        var URL1 = ("EmployeeAtt.php?Branch=" + BusinessCenter + "&OpenDate="
        + self.SelectedFromDate + "&CloseDate="
        + self.SelectedToDate + "&Employee="
        + self.category1.text!).replacingOccurrences(of: " ", with: "%20")
        
        print("URL1 : " + URL1)
        

        
    
        Service.sharedInstance.webServiceInitialGETCall(url: URL1, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
            hideHUDForView()

            print(JsonResponse)
            if JsonResponse == nil {
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            if let Output = JsonResponse!["Output"] as? NSDictionary{
                if let data = Output["data"] as? NSArray {
                    for item in data {
                        if let obj = item as? NSDictionary {


                            if(obj["DATE_IN"] as? String == nil){
                                
                                let a = Attendance(dateIn: obj["EMP_NAME"] as! String, dateOut: nil, totalHrs: obj["TOTAL_HRS"] as! String)
                                self.subArray.append(a)
                                
                               
                            }
                            else{
                                let a = Attendance(dateIn: obj["DATE_IN"] as! String, dateOut: obj["DATE_OUT"] as! String, totalHrs:    self.formatTotalHours( hrs: obj["TOTAL_HRS"] as! String))
                                self.subArray.append(a)
                            }


                        }
                    }
                }
                
                
                else{
                    self.subArray = []
                    self.tableView.reloadData()
                    CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                    return
                }
            }

            else{
                self.subArray = []
                self.tableView.reloadData()
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }


            self.tableView.reloadData()

    }
    }
    
    func formatTotalHours( hrs : String)  -> String{
        
        var formatted = ""
        
        if(hrs.contains(".")){
            let splitsDay = hrs.components(separatedBy: ".")
            
            let splitsHours = splitsDay[1].components(separatedBy: ":")
            
    //        if(splitsDay.count)
            
            formatted = splitsDay[0] + "D " + splitsHours[0] + "H " + splitsHours[1] + "M " + splitsHours[2] + "S"
            
        }
        else{
            let splitsHours = hrs.components(separatedBy: ":")
            
            formatted = splitsHours[0] + "H " + splitsHours[1] + "M " + splitsHours[2] + "S"
            
        }
       
       
        
        return formatted
    }
    func loadEmployeeList() {
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
                    
                    if let employee = data["Employee"] as? NSArray {
                        for item in employee {
                            if let obj = item as? NSDictionary {
                                self.employeeList.append(obj["USER"] as! String)
                            }
                        }
                    }
                    
                }
            
            }
            
            else{
                CBGlobalMethods.shared.ShowAlert(TitleString: "Alert", MessageString: "Sorry, No Data Available")
                return
            }
            
            if self.employeeList.count > 0 {
                DispatchQueue.main.async {
                    self.category1.text = self.employeeList[0]
                    self.selectedDepId = self.employeeList[0]
                    self.loadData()
                }
            }
            
        }
    }
    

}




class Attendance {
    
    var dateIn : String = ""
    var dateOut : String? = ""
    var totalHrs : String = ""
    
    init(dateIn:String, dateOut:String?, totalHrs:String){
        self.dateIn = dateIn
        self.dateOut = dateOut
        self.totalHrs = totalHrs
    }
}
