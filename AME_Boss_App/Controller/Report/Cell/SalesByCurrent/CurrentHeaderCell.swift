//
//  CurrentHeaderCell.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 10/02/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class CurrentHeaderCell: UITableViewCell {
    
    @IBOutlet weak var summery_txt: UILabel!
       @IBOutlet weak var date_txt: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
