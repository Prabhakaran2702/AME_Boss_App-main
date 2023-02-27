//
//  CustomTblCell.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 16/03/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class CustomTblCell: UITableViewCell {
    
    @IBOutlet weak var height2: NSLayoutConstraint!
    @IBOutlet weak var height1: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var maintitleLable: UILabel!
    @IBOutlet weak var lable1: UILabel!
    @IBOutlet weak var lable2: UILabel!
    @IBOutlet weak var lable3: UILabel!
    
    var isFirtsRow : Bool = false
    
    var array : [SUbModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "CustomSingle", bundle: nil), forCellReuseIdentifier: "CustomSingle")

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setCellvalues(obj : MianModel){
        self.maintitleLable.text = obj.maintitle
        self.lable1.text = obj.title1
        self.lable2.text = obj.title2
        self.lable3.text = obj.title3
        self.array = obj.items
        self.tableView.reloadData()
        
        if isFirtsRow {
            height1.constant = 0
            height2.constant = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.array = []
        self.lable1.text = ""
        self.lable2.text = ""
        self.lable3.text = ""
        self.maintitleLable.text = ""
        if isFirtsRow {
            height1.constant = 0
            height2.constant = 0
        }
    }
    
}

extension CustomTblCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSingle") as! CustomSingle
        cell.lable1.text = array[indexPath.row].item1
        cell.lable2.text = array[indexPath.row].item2
        cell.lable3.text = array[indexPath.row].item3
        return cell
    }
    
    
}
