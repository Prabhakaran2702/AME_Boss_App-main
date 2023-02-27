//
//  BrachListVC.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 01/02/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit


protocol BranchProtocol {
    func dataPassing(name: String , isRetail: String)
}


class BrachListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    var tableData : [String] = []
    var IsRetail_TableData : [String] = []
    
    
    @IBOutlet weak var BranchTV: UITableView!
    
    @IBOutlet weak var headerview: GradientView!
    
    var selectIndex = 0
    
    var Name = String()
    
    var IsRetail = String()
    
    
    var delegate: BranchProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        BranchTV.tableFooterView   = UIView()
        let defaults = UserDefaults.standard
        
        if tableData.count == 0 {
            tableData  = defaults.stringArray(forKey: "BranchList") ?? [String]()
            IsRetail_TableData = defaults.stringArray(forKey: "IsRetailArray") ?? [String]()
        }
    }
    
    
    
    @IBAction func BtnDialogCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func BtnDialogOk(_ sender: Any) {
        self.delegate?.dataPassing(name: self.Name, isRetail: self.IsRetail)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrachListCell") as! BrachListCell
        cell.branchname.text = tableData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row
        self.Name = tableData[indexPath.row]
        self.IsRetail = IsRetail_TableData[indexPath.row]
        self.delegate?.dataPassing(name: self.Name, isRetail: self.IsRetail)
        self.dismiss(animated: true, completion: nil)
    }
    
}
