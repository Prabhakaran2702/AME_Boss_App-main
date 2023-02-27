//
//  NewMadeTblCell.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 15/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class NewMadeTblCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalRetailLabel: UILabel!
    @IBOutlet weak var totalDiscountLabel: UILabel!
    @IBOutlet weak var totalSSTLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    
    @IBOutlet weak var ttleLabel: UILabel!
    
    @IBOutlet weak var deffTitleLabel: UILabel!
    
    @IBOutlet weak var view1: GradientView!
    @IBOutlet weak var view2: GradientView!
    @IBOutlet weak var view3: GradientView!
    @IBOutlet weak var view4: GradientView!
    
    var array : [SingleItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.register(UINib(nibName: "NewMadeSingleCell", bundle: nil), forCellReuseIdentifier: "NewMadeSingleCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view1.layer.cornerRadius = 5
        view2.layer.cornerRadius = 5
        view3.layer.cornerRadius = 5
        view4.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.array = []
        self.dateLabel.text = ""
        self.totalRetailLabel.text = ""
        self.totalDiscountLabel.text = ""
        self.totalSSTLabel.text = ""
        self.totalAmountLabel.text = ""
    }
 
}

extension NewMadeTblCell: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMadeSingleCell") as! NewMadeSingleCell
        cell.modeLabel.text = array[indexPath.row].mode
        cell.sstLabel.text = array[indexPath.row].sst
        cell.amountLabel.text = array[indexPath.row].amount
        return cell
    }
    
    
}
