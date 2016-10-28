//
//  Quiz.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/20/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation


class Quiz: NSObject {
    
    var questions: NSMutableArray = []
    
    var startTime:NSDate!
    
    var finished: Bool = false
    
    var result: Int = 0
    
    private struct Static {
        static var instance : Quiz!
    }

    //singleton
    class var sharedInstance : Quiz {
        if Static.instance == nil {
            Static.instance = Quiz()
        }
        
        return Static.instance
    }
    
    override init(){
        
        self.questions.addObjectsFromArray(SqliteHelper.getQuestions(Settings.numberOfQuestions, type:Settings.typeOfQuestions))
        //println("init time: \(Settings.timeLimit) ")
        self.startTime = NSDate(timeIntervalSinceNow: NSTimeInterval(Settings.timeLimit))
    }
    
    func reset() {
        Static.instance = nil
    }
    
    func durationsBySecond(seconds s: Int) -> (days:Int,hours:Int,minutes:Int,seconds:Int) {
        return (s / (24 * 3600),(s % (24 * 3600)) / 3600, s % 3600 / 60, s % 60)
    }
    
    func getTimeLeft() -> NSString {
        
        //Get the time left until
        var ti = self.startTime.timeIntervalSinceNow
        
        if ti < 0 {
            finished = true
            return "00:00:00"
            
        }
        var seconds = Int(ti % 60)
        var minutes = Int(ti % 3600 / 60)
        var hours = Int((ti % (24 * 3600)) / 3600)
        
        return NSString(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
    }
    
    func getDone() -> Int {
        
        var i = 0
        for q in self.questions {
            var question = q as Question
            if question.isAnswered() {
                i++
            }
        }
        
        return i
    }

     
}

