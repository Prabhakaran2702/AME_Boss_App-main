//
//  CornerButton.swift
//  AME_Boss_App
//
//  Created by mohammed junaid on 15/01/21.
//  Copyright © 2021 amebusinesssolutions.com. All rights reserved.
//


import Foundation
import UIKit


class CornerButton: UIButton
{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.cornerButton()
    }
    
    func cornerButton()
    {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
}
