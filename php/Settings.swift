//
//  Settings.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/11/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation



struct Settings {
    
    //questions types
    static let TYPES: [String] = ["all types", "single", "text", "multi"]

    
    enum Theme : Int {
        
        case Light
        case Dark
        case Sepia
    }

    static let DEFAULT_FONT_SIZE: Float = 14.0
    
    static let DEFAULT_NUM_QUESTIONS: Int = 70
    
    static let DEFAULT_TIME_LIMIT: Int = 5400

    static var fontName: String {
        get {
            return "HelveticaNeue"
        }
    }
    
    
    static var brightness: Float {
        get {
        
            let defaults = NSUserDefaults.standardUserDefaults()
            var n = defaults.floatForKey("brightness")
            
            if n == 0 {
                n = 0.5
            }
            return n
        
            // UIScreen.mainScreen().brightness
        }
        
        set(n) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setFloat(n, forKey: "brightness")
            defaults.synchronize()
        }
    }
    
    static var fontSize: Float  {
        get {
        
            let defaults = NSUserDefaults.standardUserDefaults()
            var n = defaults.floatForKey("fontSize")
            
            if n == 0 {
                n = DEFAULT_FONT_SIZE
            }
            return n
        }
        
        set(n) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setFloat(n, forKey: "fontSize")
            defaults.synchronize()
            
        }
    }

    
    static var numberOfQuestions: Int  {
        get {
        
            let defaults = NSUserDefaults.standardUserDefaults()
            var n = defaults.integerForKey("number_questions")
        
            if n == 0 {
                n = DEFAULT_NUM_QUESTIONS
            }

            return n
        }
        
        set(n) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(n, forKey: "number_questions")
            defaults.synchronize()
            
        }
    }
    
    //in seconds
    static var timeLimit: Int {
        get {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var n = defaults.integerForKey("time_limit")
        
        if n == 0 {
            n = DEFAULT_TIME_LIMIT
        }
        
        return n
        }
        
        set(n) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(n, forKey: "time_limit")
            defaults.synchronize()
        }
        
    }
    
    static var theme: Int  {
        get {
    
            let defaults = NSUserDefaults.standardUserDefaults()
            var n = defaults.integerForKey("theme")
    
            return n
        }
        
        set(n) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(n, forKey: "theme")
            defaults.synchronize()

        }
    }
    
    
    static var typeOfQuestions: Int  {
        get {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var n = defaults.integerForKey("type_questions")
        
        return n
        }
        
        set(n) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(n, forKey: "type_questions")
            defaults.synchronize()
            
        }
    }
}