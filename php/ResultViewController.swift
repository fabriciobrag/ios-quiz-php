//
//  ResultViewController.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/24/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController: GAITrackedViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var quiz = Quiz.sharedInstance
    var score = 0
    
    var y:CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.layoutIfNeeded()
        
        //calculate result
        self.result()
        
        var scoreView = ScoreView(frame: CGRectMake((self.view.frame.width - 200) / 2, 10, 200, 200))
        scoreView.percent = (self.score * 100) / self.quiz.questions.count
        self.scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.scrollView.addSubview(scoreView)
        
        
        //restart button
        let button = UIButton(frame: CGRectMake((self.view.frame.width - 100) / 2, self.y + 50, 100, 40))
        button.setTitle("restart", forState: UIControlState.allZeros)
        button.titleLabel?.font = UIFont(name: Settings.fontName, size: 18.0)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.allZeros)
        button.setBackgroundColor(UIColor.buttonColor(), forUIControlState: UIControlState.Normal)
        button.setBackgroundColor(UIColor.defaultColor(), forUIControlState: UIControlState.Highlighted)
        button.addTarget(self, action: "restartClick:", forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(button)
        
        self.y += 100
        
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.y + 100)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.screenName = "Result Screen"
    }
    
    
    func restartClick(sender: UIButton) {
        self.quiz.reset()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func result() {
        
        var arr: [Int: NSMutableArray] = [Int: NSMutableArray]()
        
        for q in self.quiz.questions {
            var question = q as Question
            if question.isCorret() {
                self.score++
            }
            
            var categoryId = question.category!.id!
            
            if let cat = arr[categoryId]  {
                arr[categoryId]?.addObject(question)
            } else {
                arr[categoryId] = NSMutableArray()
                arr[categoryId]?.addObject(question)
            }
            
        }
        self.quiz.result = self.score
        
        
        //get score by category
        for cat in SqliteHelper.getCategories() {
            
            var scoreCategory = 0

            if let res = arr[cat.id] {
                
                for q in res {
                    var question = q as Question
                    if question.isCorret() {
                        scoreCategory++
                    }
                }
                
                var text = "\(cat.category) \n (\(scoreCategory) / \(res.count)) \((scoreCategory * 100) / res.count)%"
                
                let catLabel = UILabel(frame: CGRectMake(0, self.y, self.view.frame.width, 50))
                catLabel.text = text
                catLabel.textAlignment = NSTextAlignment.Center
                catLabel.font = UIFont(name: Settings.fontName, size: 16.0)
                catLabel.numberOfLines = 2
                
                self.scrollView.addSubview(catLabel)
                
                //separator
                let lineView = UIView(frame: CGRectMake(0, self.y + 52, self.view.frame.width, 1))
                lineView.backgroundColor = UIColor.grayScaleColor(230.0)
                self.scrollView.addSubview(lineView)
                
                self.y += 55
                
            }
        }
    }
}