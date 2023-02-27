
import UIKit

class SalesByCurrentVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var etxTerminal: MetrialTextfield!
    @IBOutlet weak var centername: UILabel!
    @IBOutlet weak var selected_terminal: UILabel!
    var Terminal = String()
    @IBOutlet weak var tableView: UITableView!
    var HeaderName = [String]()
    var ContentItem = [String]()
    var ContentRate = [String]()
    var IsShowMoreDetails = false
    var ContentData = [[String]]()
    var ItemAmount = [[String]]()
    var ItemSST = [[String]]()
    var headerTitles = [String]()
    var headerTitlesDate = [String]()
    var Total_Retail_Sum_Array = [String]()  /* WithSST  **/
    var Total_Discount_Sum_Array = [String]()
    var Total_SST_Sum_Array = [String]()
    var Total_Sum_Array = [String]()    /* WithoutSST  **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSearch.layer.cornerRadius = 6
        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        let  BusinessCenter      = defaults.string(forKey: "BusinessCenter")!
        centername.text  = BusinessCenter ;
        IsShowMoreDetails  = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView   = UIView()
        // Do any additional setup after loading the view.
        APIs()
    }
    
    @IBAction func BtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearch(_ sender: UIButton) {
        if !isConnectedToNetwork() {
            self.displayAlertMessage(userMessage: defaultServerErrorMsg)
        } else {
            let terminal_val = etxTerminal.text!
            self.selected_terminal.text = "Terminal :" + terminal_val
            APIs()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.ContentData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if IsShowMoreDetails {
            if section < headerTitles.count {
                return headerTitles[section]
            }
        } else {
            if section == 0 {
                if section < headerTitles.count {
                    return headerTitles[section]
                }
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if IsShowMoreDetails {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentHeaderCell") as! CurrentHeaderCell
            cell.summery_txt.text = headerTitles[section]
            cell.date_txt.text = headerTitlesDate[section]
            return cell
        } else {
            if section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentHeaderCell") as! CurrentHeaderCell
                cell.summery_txt.text = headerTitles[section]
                cell.date_txt.text = headerTitlesDate[section]
                return cell
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentFooterCell") as! CurrentFooterCell
        //set the data here
        if section == 0 {
            if IsShowMoreDetails {
                cell.btnviewmore.setTitle("View Less ▲", for: .normal)
                cell.TxtTotalRetailAmount.text = Total_Sum_Array[section]
                cell.TxtTotalDiscount.text = Total_Discount_Sum_Array[section]
                cell.TxtSSTAmount.text = Total_SST_Sum_Array[section]
                cell.TxtTotalAmount.text = Total_Retail_Sum_Array[section]
            } else {
                cell.btnviewmore.setTitle("View More ▼", for: .normal)
                cell.TxtTotalRetailAmount.text = Total_Sum_Array[section]
                cell.TxtTotalDiscount.text = Total_Discount_Sum_Array[section]
                cell.TxtSSTAmount.text = Total_SST_Sum_Array[section]
                cell.TxtTotalAmount.text = Total_Retail_Sum_Array[section]
            }
            cell.btnviewmore.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        }
        else {
            if !IsShowMoreDetails {
                return nil
            }
            // cell.btnviewmore.titleLabel?.text = "H"
            cell.btnviewmore.setTitle("\("")", for: .normal)
            cell.TxtTotalRetailAmount.text = Total_Sum_Array[section]
            cell.TxtTotalDiscount.text = Total_Discount_Sum_Array[section]
            cell.TxtSSTAmount.text = Total_SST_Sum_Array[section]
            cell.TxtTotalAmount.text = Total_Retail_Sum_Array[section]
        }
        return cell
    }
    
    @objc func buttonClicked(sender: UIButton) {
        print("Hai")
        if IsShowMoreDetails {
            IsShowMoreDetails  = false
        } else {
            IsShowMoreDetails  = true
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if IsShowMoreDetails {
            return 115.0
        } else {
            if section == 0 {
                return  115.0
            }
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if IsShowMoreDetails {
            return  40.0
        } else {
            if section == 0 {
                return  40.0
            }
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if IsShowMoreDetails {
            return ContentData[section].count
        } else {
            if section == 0 {
                return ContentData[section].count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if IsShowMoreDetails {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentBodyCell") as! CurrentBodyCell
            cell.itemname_txt.text = ContentData[indexPath.section][indexPath.row]
            cell.rate_txt.text = ItemAmount[indexPath.section][indexPath.row]
            cell.sst_txt.text = ItemSST[indexPath.section][indexPath.row]
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentBodyCell") as! CurrentBodyCell
                cell.itemname_txt.text = ContentData[indexPath.section][indexPath.row]
                cell.rate_txt.text = ItemAmount[indexPath.section][indexPath.row]
                return cell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "CurrentBodyCell") as! CurrentBodyCell
    }
    
    func APIs() {
        self.ItemSST.removeAll()
        self.HeaderName.removeAll()
        self.ContentItem.removeAll()
        self.ContentRate.removeAll()
        self.ContentData.removeAll()
        self.ItemAmount.removeAll()
        self.headerTitles.removeAll()
        self.headerTitlesDate.removeAll()
        self.Total_Retail_Sum_Array.removeAll()
        self.Total_Discount_Sum_Array.removeAll()
        self.Total_SST_Sum_Array.removeAll()
        self.Total_Sum_Array.removeAll()
        let defaults    = UserDefaults.standard
        let  BusinessCenter      = defaults.string(forKey: "BusinessCenter")!
        if self.etxTerminal.text!.count == 0 {
            Terminal  = "C1"
        } else {
            Terminal  =  self.etxTerminal.text!
        }
        let dictParams = ["": ""]
        let URL = "SalesByCurrent.php?Branch=" + BusinessCenter + "&Terminal=" + Terminal
        // let URL  = ""
        print(URL)
        Service.sharedInstance.webServiceInitialGETCall(url: URL, isShowLoader: true, paramValues: dictParams as NSDictionary, headerValues: defaultHeader) { (error, JsonResponse) in
            hideHUDForView()
            let status = JsonResponse!["Response"] as? String ?? ""
            if status == "1", let header = JsonResponse!["SummeryData"] as? NSArray{
                 let  content   =    JsonResponse!["Data"] as! NSArray
                /** Header Part start here   */
                var total_ret_amount = 0.0 , total_discount_amount = 0.0 , total_sst_amount = 0.0 , total_amount  = 0.0
                var dept_string_builder_summery :[String] = []
                var amount_string_builder_summery :[String] = []
                var sst_string_builder_summery:[String] = []
                do {
                    let data = try JSONSerialization.data(withJSONObject: header)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
                    if let array = jsonResult as? NSArray {
                        for obj in array {
                            if let dict = obj as? NSDictionary {
                                // Now reference the data you need using:
                                let  dictionary  = dict.value(forKey: "SummeryDetails")
                                self.headerTitles.append("Terminal")
                                self.headerTitlesDate.append("Amount")
                                if let array2 = dictionary as? NSArray{
                                    for obj2 in array2 {
                                        if let dict2  = obj2 as? NSDictionary
                                        {
                                            let dept_name  = dict2.value(forKey: "TERMINAL")
                                            let total_ret_amt = dict2.value(forKey: "WITHSST")
                                            let discount_amt  = dict2.value(forKey: "DISCOUNT")
                                            let sst_amt = dict2.value(forKey: "SST")
                                            let total_amt = dict2.value(forKey: "WITHOUTSST")
                                            /** DeptName String Creating a String Array   */
                                            dept_string_builder_summery.append(dept_name as! String)
                                            amount_string_builder_summery.append(total_ret_amt as! String)
                                            sst_string_builder_summery.append(sst_amt as! String)
                                            //Retail Amount
                                            if let amount_ = Double(total_ret_amt as! String) {
                                                total_ret_amount += amount_
                                            }
                                            // Discount Amt
                                            if let discount_ = Double(discount_amt as! String) {
                                                total_discount_amount += discount_
                                            }
                                            // SST Amt
                                            if let sst_ = Double(sst_amt as! String) {
                                                total_sst_amount += sst_
                                            }
                                            // Total Amount
                                            if let total_ = Double(total_amt as! String) {
                                                total_amount += total_
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    /** Added the new data in  Muti Dimensional Array   */
                    self.ContentData.append(dept_string_builder_summery)
                    self.ItemAmount.append(amount_string_builder_summery)
                    self.ItemSST.append(sst_string_builder_summery)
                    self.Total_Retail_Sum_Array.append(String(format:"%01.2f",total_ret_amount))
                    self.Total_Discount_Sum_Array.append(String(format: "%01.2f", total_discount_amount))
                    self.Total_SST_Sum_Array.append(String(format: "%01.2f", total_sst_amount))
                    self.Total_Sum_Array.append(String(format: "%01.2f", total_amount))
                    /** End Header Part    */
                    /** Start Content Part  - Sale Date Header */
                    total_ret_amount = 0.0
                    total_discount_amount = 0.0
                    total_sst_amount = 0.0
                    total_amount  = 0.0
                    var dept_string_builder_child :[String] = []
                    var amount_string_builder_child :[String] = []
                    var sst_string_builder_child :[String] = []
                    let content_data = try JSONSerialization.data(withJSONObject: content)
                    let Content_jsonResult = try JSONSerialization.jsonObject(with: content_data, options: [])
                    if let array = Content_jsonResult as? NSArray {
                        for obj in array {
                            if let dict = obj as? NSDictionary {
                                // Header
                                let  sale_date_header  = dict.value(forKey: "PaymentCurrentHeader")
                                self.headerTitles.append("Payment Date")
                                self.headerTitlesDate.append(sale_date_header as! String)
                                //  Child
                                let  sale_date_child  = dict.value(forKey: "PaymentDetails")
                                if let array2 = sale_date_child as? NSArray{
                                    for obj2 in array2 {
                                        if let dict2  = obj2 as? NSDictionary {
                                            let dept_name = dict2.value(forKey: "BILL_NO")
                                            let total_ret_amt = dict2.value(forKey: "WITHSST")
                                            let discount_amt = dict2.value(forKey: "DISCOUNT")
                                            let sst_amt = dict2.value(forKey: "SST")
                                            let total_amt = dict2.value(forKey: "WITHOUTSST")
                                            /** DeptName String Creating a String Array   */
                                            sst_string_builder_child.append(sst_amt as! String)
                                            amount_string_builder_child.append(total_ret_amt as! String)
                                            dept_string_builder_child.append(dept_name as! String)
                                            //Total_Ret_SUM
                                            if let amount_ = Double(total_ret_amt as! String) { //Double(String) returns an optional.
                                                total_ret_amount += amount_
                                            }
                                            // Discount Amt
                                            if let discount_ = Double(discount_amt as! String) {
                                                total_discount_amount += discount_
                                            }
                                            // SST Amt
                                            if let sst_ = Double(sst_amt as! String) {
                                                total_sst_amount += sst_
                                            }
                                            // Total Amount
                                            if let total_ = Double(total_amt as! String) {
                                                total_amount += total_
                                            }
                                        }
                                    }
                                }
                            }
                            //self.Total_Sum_Value.append(amount_string_builder_child)
                            self.ContentData.append(dept_string_builder_child)
                            self.ItemAmount.append(amount_string_builder_child)
                            self.ItemSST.append(sst_string_builder_child)
                            self.Total_Retail_Sum_Array.append(String(format:"%01.2f",total_ret_amount))
                            self.Total_Discount_Sum_Array.append(String(format: "%01.2f", total_discount_amount))
                            self.Total_SST_Sum_Array.append(String(format: "%01.2f", total_sst_amount))
                            self.Total_Sum_Array.append(String(format: "%01.2f", total_amount))
                        }
                    }
                    /** End Content Part */
                    UserDefaults.standard.setValue(self.ContentData, forKey: "SectionArray")
                    self.tableView.reloadData()
                }catch let error {
                    print(error.localizedDescription)
                }
            } else {
                self.HeaderName.removeAll()
                self.ContentItem.removeAll()
                self.ContentRate.removeAll()
                self.ContentData.removeAll()
                self.ItemAmount.removeAll()
                self.headerTitles.removeAll()
                self.headerTitlesDate.removeAll()
                self.Total_Retail_Sum_Array.removeAll()
                self.Total_Discount_Sum_Array.removeAll()
                self.Total_SST_Sum_Array.removeAll()
                self.Total_Sum_Array.removeAll()
                self.tableView.reloadData()
                self.ItemSST.removeAll()
                self.displayAlertMessage(userMessage: "Sorry, No data available")
            }
        }
    }
}
