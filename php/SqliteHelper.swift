//
//  SqliteHelper.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/26/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation

class SqliteHelper: NSObject {

    
    class func getQuestions (limit: Int, type: Int) -> NSMutableArray {
        var questions: NSMutableArray = []
        var query = "SELECT id, type_question, question, answer, category_id FROM questions"
        
        if type > 0 {
            query += " WHERE type_question = \(type)"
        }
        
        query += " ORDER BY RANDOM() LIMIT \(limit)"
        
        //query += " limit \(limit)"
        
        
        let db = FMDatabase(path: SqliteHelper.pathToFile())
        db.open()
        
        let resutSet = db.executeQuery(query, withArgumentsInArray: nil)
        
        while resutSet!.next() {
            questions.addObject(Question(q: resutSet))
        }
        return questions
    }
    
    
    class func getCategory(id:Int) -> Category? {

        let db = FMDatabase(path: SqliteHelper.pathToFile())
        db.open()
        
        let resultSet = db.executeQuery("SELECT id, category FROM categories WHERE id = ?", withArgumentsInArray:[id])
        
        while resultSet!.next() {
            return Category(c: resultSet!)
            
        }
        
        return nil
    }
    
    class func getCategories() -> [Category] {
        var categories = [Category]()
        
        let db = FMDatabase(path: SqliteHelper.pathToFile())
        db.open()
        
        let resutSet = db.executeQuery("SELECT id, category FROM categories", withArgumentsInArray: nil)
        
        while resutSet!.next() {
            categories.append(Category(c: resutSet!))
        }
        
        return categories

    }
    
    class func getAlternatives(questionId: Int) -> [Alternative]? {
    
        var alternatives = [Alternative]()
        
        let db = FMDatabase(path: SqliteHelper.pathToFile())
        db.open()
        
        let resutSet = db.executeQuery("SELECT id, alternative, is_correct FROM alternatives WHERE question_id = ? ", withArgumentsInArray: [questionId])
        
        while resutSet!.next() {
            alternatives.append(Alternative(q: resutSet))
        }
        
        return alternatives
    }
    
   class func pathToFile() -> String {
        
        let filemanager = NSFileManager.defaultManager()
        
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/data.db")
        
        if(!filemanager.fileExistsAtPath(destinationPath) ){
            
            let fileForCopy = NSBundle.mainBundle().pathForResource("data",ofType:"db")
            filemanager.copyItemAtPath(fileForCopy!,toPath:destinationPath, error: nil)
            
            return destinationPath
        }
        else{
            return destinationPath
        }

    }
}
