//
//  CurrentBodyCell.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 10/02/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//

import UIKit

class CurrentBodyCell: UITableViewCell {
    
    @IBOutlet weak var itemname_txt: UILabel!
    @IBOutlet weak var rate_txt: UILabel!
    @IBOutlet weak var sst_txt: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
