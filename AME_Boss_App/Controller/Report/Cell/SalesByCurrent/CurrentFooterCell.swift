//
//  CurrentFooterCell.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 10/02/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class CurrentFooterCell: UITableViewCell {
    
    
    @IBOutlet weak var firstview: GradientView!
    @IBOutlet weak var secondview: GradientView!
    @IBOutlet weak var thirdview: GradientView!
    @IBOutlet weak var fourthview: GradientView!
    
    @IBOutlet weak var btnviewmore: UIButton!
    
    @IBOutlet weak var TxtTotalRetailAmount: UILabel!
    @IBOutlet weak var TxtTotalDiscount: UILabel!
    @IBOutlet weak var TxtSSTAmount: UILabel!
    @IBOutlet weak var TxtTotalAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstview.layer.cornerRadius = 5
        secondview.layer.cornerRadius = 5
        thirdview.layer.cornerRadius = 5
        fourthview.layer.cornerRadius = 5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
