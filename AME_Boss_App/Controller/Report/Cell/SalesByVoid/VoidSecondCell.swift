//
//  VoidSecondCell.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 16/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class VoidSecondCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalPrintedLabel: UILabel!
    @IBOutlet weak var totalNonPrintedLabel: UILabel!
    
    
    @IBOutlet weak var view1: GradientView!
    @IBOutlet weak var view2: GradientView!
    
    var array : [SingleVoid] = []
    var array2 : [SingleVoid] = []
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.array = []
        self.array2 = []
        self.dateLabel.text = ""
        self.totalPrintedLabel.text = ""
        self.totalNonPrintedLabel.text = ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "NewMadeSingleCell", bundle: nil), forCellReuseIdentifier: "NewMadeSingleCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view1.layer.cornerRadius = 5
        view2.layer.cornerRadius = 5
    }
    
    
}

extension VoidSecondCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    } 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return self.array.count
        }else if section == 2{
            return 1
        }else{
            return self.array2.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Printed"
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMadeSingleCell") as! NewMadeSingleCell
            cell.modeLabel.text = array[indexPath.row].PRODUCT
            cell.sstLabel.text = array[indexPath.row].AMOUNT
            cell.amountLabel.text = array[indexPath.row].CANCELBY
            return cell
        }else if indexPath.section == 2{
            let cell = UITableViewCell()
            cell.textLabel?.text = "Non-Printed"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMadeSingleCell") as! NewMadeSingleCell
            cell.modeLabel.text = array2[indexPath.row].PRODUCT
            cell.sstLabel.text = array2[indexPath.row].AMOUNT
            cell.amountLabel.text = array2[indexPath.row].CANCELBY
            return cell
        }
    }
    
    
}
