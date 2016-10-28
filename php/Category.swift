//
//  Category.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/26/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation

class Category: NSObject {
    var id: Int! = 0
    var category: String!
    
    init(c: FMResultSet) {
        
        self.id = c.objectForColumnName("id") as Int
        self.category = c.objectForColumnName("category") as String
    }

}