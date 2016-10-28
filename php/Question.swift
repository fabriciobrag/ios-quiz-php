//
//  Question.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/7/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation

class Question {
    
    var id:Int!
    var type:Int!
    var question:String!
    var answer: String?
    var inputAnswer: String! = ""
    var category: Category?
    var alternatives: [Alternative]! = []
    
    
    init(q: FMResultSet) {
        
        self.id = q.objectForColumnName("id") as Int
        self.type = q.objectForColumnName("type_question") as Int
        self.question = q.objectForColumnName("question") as String
        self.answer = q.objectForColumnName("answer") as? String
        let idCategory = q.objectForColumnName("category_id") as Int
        self.category = SqliteHelper.getCategory(idCategory)
        self.alternatives = SqliteHelper.getAlternatives(self.id)
    }
    
    
    func isAnswered() -> Bool {
        
        switch self.type {
        case 1: //single
            for alt in self.alternatives {
                if alt.isSelected {
                    return true
                }
            }
            
            return false
        
        case 2: //text
            if !self.inputAnswer.isEmpty {
                return true
            }
            
            return false
            
        case 3: //multi
            if self.altRemaining() == 0 {
                return true
            }
            return false
            
        default: return false
        }
        
    }

    
    func isCorret() -> Bool {
        switch self.type {
            
        case 1: //single
            for alt in self.alternatives {
                if alt.isCorrect && alt.isSelected {
                    return true
                }
            }
            
            return false
            
        case 2: //text
            
            if self.filterString(self.inputAnswer) == self.filterString(self.answer) {
                return true
            }
            
            return false
            
            
        case 3: //multi
            
            var n = 0
            for alt in self.alternatives {
                if alt.isCorrect && alt.isSelected {
                    n++
                }
            }
            
            if n == getNumCorrect() {
                return true
            }
            
            return false
            
        default:()
        }
        
        return false
    }
    
    
    func filterString(str: String!) -> String! {
        
        var s = str?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return s?.lowercaseString
    }
    
    
    func altRemaining() -> Int {

        var n = self.getNumCorrect()
        
        for alt in self.alternatives {
            if alt.isSelected {
                n--
            }
        }
        
        return n
        
    }
    
    func getNumCorrect() -> Int {
        var correct = 0
        
        for alt in self.alternatives {
            if alt.isCorrect {
                correct++
            }
        }
        
        return correct
        
    }
    
}