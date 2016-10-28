//
//  Alternative.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/28/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation

class Alternative: NSObject {
    
    var id: Int?
    var alternative: String = ""
    var isCorrect: Bool = false
    var isSelected: Bool  = false

    
    init(q: FMResultSet) {
        self.id = q.objectForColumnName("id") as? Int
        self.alternative = q.objectForColumnName("alternative") as String
        self.isCorrect = Bool(q.objectForColumnName("is_correct") as Int)
    }
}
