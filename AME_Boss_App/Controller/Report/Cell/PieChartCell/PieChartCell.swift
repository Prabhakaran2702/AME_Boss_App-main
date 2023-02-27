//
//  PieChartCell.swift
//  AME_Boss_App
//
//  Created by MOHAMMED ABDUL BASITHK on 15/02/22.
//  Copyright © 2022 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class PieChartCell: UITableViewCell {

    @IBOutlet weak var piechartButton: UIButton!
    @IBOutlet weak var clientServerButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func animateButton(){
        clientServerButton.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.5, options:  [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.clientServerButton.alpha = 0.0

        }, completion: nil)
    }
    
    @IBAction func piechartClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("piechartClicked"), object: nil)
    }
}
