//
//  SalesByClosedRetailMoreVC.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 18/04/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit
import ExpyTableView


class SalesByClosedRetailMoreVC: UIViewController {
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBAction func BtnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var items : [SUbModel] = []
    
    var myTitle : String = "Back"
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomSingle", bundle: nil), forCellReuseIdentifier: "CustomSingle")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
        
        pageTitle.text = myTitle
    }    
    
}


//MARK: ExpyTableViewDataSourceMethods
extension SalesByClosedRetailMoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:"CustomSingle")) as! CustomSingle
        cell.lable1.text =  items[indexPath.row].item1
        cell.lable2.text =  items[indexPath.row].item2
        cell.lable3.text =  items[indexPath.row].item3
        return cell
    }
    
}

