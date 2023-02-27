//
//  MenuListVC.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 24/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit

protocol MenuSelectionProtocol {
    func dataPassing(name: String , isRetail: String, type : Int)
}

class MenuListVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    var list1 : [String] = []
    var list2 : [String] = []
    
    var type : Int = 1
    
    
    @IBOutlet weak var BranchTV: UITableView!
    
    @IBOutlet weak var headerview: GradientView!
    
    var selectIndex = 0
    
    var Name = String()
    var IsRetail = String()
    
    
    var delegate: MenuSelectionProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    
    @IBAction func BtnDialogOk(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrachListCell") as! BrachListCell
        cell.branchname.text = list2[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row
        self.Name = list2[indexPath.row]
        self.IsRetail = list1[indexPath.row]
        self.delegate?.dataPassing(name: self.Name, isRetail: self.IsRetail, type: self.type)
        self.dismiss(animated: true, completion: nil)
    }
    
}
