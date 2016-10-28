//
//  QuestionCell.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/12/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.questionLabel.font = UIFont(name: Settings.fontName, size: 14.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
