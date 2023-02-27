//
//  AttendanceTableViewCell.swift
//  AME_Boss_App
//
//  Created by Prabhakaran D on 14/01/2023.
//  Copyright © 2023 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class AttendanceTableViewCell:UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deffTitleLabel: UILabel!
    @IBOutlet weak var deffTitleLabel2: UILabel!
    @IBOutlet weak var deffTitleLabel3: UILabel!
    
    
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    
 

    var array : [Attendance] = []
    
    var title1 : String = "Date In"
    var title2 : String = "Date Out"
    var title3 : String = "Total Hours"
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.register(UINib(nibName: "NewMadeSingleCell", bundle: nil), forCellReuseIdentifier: "NewMadeSingleCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        deffTitleLabel.text = title1
        deffTitleLabel2.text = title2
        deffTitleLabel3.text = title3
     
        
 
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.array = []
    }
    
    
}

extension AttendanceTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.modeLabel.text = array[indexPath.row].dateIn
        cell.sstLabel.text = array[indexPath.row].dateOut
        cell.amountLabel.text = array[indexPath.row].totalHrs
        
        if(array[indexPath.row].dateOut != nil){
            cell.amountLabel.font =  cell.amountLabel.font.withSize(10)
        }
        else{
            cell.amountLabel.font =  cell.amountLabel.font.withSize(18)
        }
        
        
        
        return cell
    }
    
    
}
