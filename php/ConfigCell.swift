//
//  ConfigCell.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/1/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import UIKit

class ConfigCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.titleLabel.font = UIFont(name: Settings.fontName, size: 16.0)
        self.valueLabel.font = UIFont(name: Settings.fontName, size: 16.0)

    }

      
}
