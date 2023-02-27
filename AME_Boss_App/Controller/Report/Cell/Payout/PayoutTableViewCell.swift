//
//  PayoutTableViewCell.swift
//  AME_Boss_App
//
//  Created by Prabhakaran D on 28/12/2022.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class PayoutTableViewCell:UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deffTitleLabel: UILabel!
    @IBOutlet weak var deffTitleLabel2: UILabel!
    @IBOutlet weak var deffTitleLabel3: UILabel!
    
    
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    
 

    var array : [EmployeePayout] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(UINib(nibName: "NewMadeSingleCell", bundle: nil), forCellReuseIdentifier: "NewMadeSingleCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
     
        
 
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.array = []
    }
    
    
}

extension PayoutTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.modeLabel.text = array[indexPath.row].payTo
        cell.sstLabel.text = array[indexPath.row].payType
        cell.amountLabel.text = array[indexPath.row].payAmount
        return cell
    }
        
}
