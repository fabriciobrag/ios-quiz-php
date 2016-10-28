//
//  QuestionViewController.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/9/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController, UITextFieldDelegate {
  
    var textStorage: CodeTextStorage!
    
    var scrollView: UIScrollView!
    
    //current questions
    var question: Question!
    
    //array of alternatives views
    var altViews: [UIView] = []
    
    //y position
    var y: CGFloat = 0
    
    var padding: CGFloat = 5.0
    
    var altRemainingLabel: UILabel!
    
    var showAnswer: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        
        var txt = self.question.question + "\n"

        //question highlight textview
        var questionTextView = UITextView(frame: CGRectMake(self.padding, self.padding, self.view.frame.width - (self.padding * 2) , 0))
        questionTextView.backgroundColor = UIColor.clearColor()
        questionTextView.font = UIFont(name: "HelveticaNeue", size: 19.0)
        questionTextView.editable = false
        questionTextView.scrollEnabled = false
        questionTextView.userInteractionEnabled = false
        
       
        textStorage = CodeTextStorage()
        textStorage.addLayoutManager(questionTextView.layoutManager)
        textStorage.replaceCharactersInRange(NSMakeRange(0, 0), withString: txt)
        
        questionTextView.sizeToFit()
        self.scrollView.addSubview(questionTextView)

        //alternative position
        self.y = questionTextView.frame.size.height
        

        //separator
        var lineView = UIView(frame: CGRectMake(0, y, self.view.frame.width, 1))
        lineView.backgroundColor = UIColor.grayScaleColor(230)
        scrollView.addSubview(lineView)
        
        self.y += 5
    
        //println("type: \(self.question.type)")
        
        switch self.question.type {
        case 1://single choice
            self.addAlternatives()
            break
            
        case 2: //text
            self.addTextField()
            break
            
        case 3://multi
            
            //alternatives remaining
            self.altRemainingLabel = UILabel(frame: CGRectMake(self.view.frame.width - 65, y, 65, 20))
            self.altRemainingLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
            self.updateAltRemaining()
            scrollView.addSubview(self.altRemainingLabel)
            
            self.y += 20
            
            self.addAlternatives()
            break
        default:()
        }
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width, y + 150)
        self.view.addSubview(scrollView)
        
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Question Screen")
        tracker.send(GAIDictionaryBuilder.createScreenView().build())
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func addTextField() {
        //text input type question
        var textField = UITextField(frame: CGRectMake(self.padding, self.y, self.view.frame.width - self.padding * 2, 40))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.returnKeyType = UIReturnKeyType.Done
        textField.autocorrectionType = UITextAutocorrectionType.No
        textField.placeholder = "Your Answer"
        textField.delegate = self
        textField.autocapitalizationType = .None
        textField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        
        
        
        if self.question.isAnswered() {
            textField.text = self.question.inputAnswer
        }

        scrollView.addSubview(textField)
        
        if self.showAnswer {

            self.y += 50

            var answerLabel = UILabel(frame: CGRectMake(5, self.y, self.view.frame.width, 40))
            answerLabel.text = "Answer: \(self.question.answer!)"
            scrollView.addSubview(answerLabel)
            
            //disable text input
            textField.enabled = false
        }
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        if !textField.text.isEmpty {
            self.question.inputAnswer = textField.text
            
        } else {
            self.question.inputAnswer = ""
        }
        
    }
    
    
    func addAlternatives() {
        
        var maxWidth = self.view.frame.width
        
        //alternatives
        for (i, alt) in enumerate(self.question.alternatives!) {
            
            //println("Y: \(y)")
            
            //println("Alternative: \(alt.alternative) isCorrect: \(alt.isCorrect) isSelected: \(alt.isSelected)")
            
            var altTextView = UITextView(frame: CGRectMake(20, 0, maxWidth - 20 - self.padding, 0))
            altTextView.attributedText = self.alternativeString(alt.alternative)
            altTextView.editable = false
            altTextView.backgroundColor = UIColor.clearColor()
            altTextView.scrollEnabled = false
            altTextView.selectable = false
            altTextView.sizeToFit()
            
            var posImg = (altTextView.frame.height / 2) - 7
            var altImageView = UIImageView(frame: CGRectMake(self.padding, posImg, 15, 15))
            if alt.isSelected {
                altImageView.image = UIImage(named: "btn_\(i + 1)_active.png")
            } else {
                altImageView.image = UIImage(named: "btn_\(i + 1).png")
            }
            altImageView.backgroundColor = UIColor.clearColor()
            
            //alternative container View
            var altView = UIView(frame: CGRectMake(0, self.y, maxWidth, altTextView.frame.size.height))
            altView.tag = i
            
            if self.showAnswer && alt.isCorrect {
                altView.backgroundColor = UIColor.bgCorrect()
            }
            
            altView.addSubview(altTextView)
            altView.addSubview(altImageView)
            
            if !self.showAnswer {
                let singleTap = UITapGestureRecognizer(target: self, action: "chooseTap:")
                altView.addGestureRecognizer(singleTap)
            }
            
            scrollView.addSubview(altView)
            self.altViews.append(altView)
            
            //increment alternative Height + padding
            self.y += altView.frame.size.height + 10
            
            if alt.isSelected {
                self.setSelected(i)
            }
        }
    }
    
    func alternativeString(str:String) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Left
        
        let font = UIFont(name: Settings.fontName, size: CGFloat(Settings.fontSize))!
        
        let color = UIColor.blackColor()
        
        let attrs = NSDictionary(objects: [paragraphStyle, font], forKeys: [NSParagraphStyleAttributeName, NSFontAttributeName])
        
//        let attrs = [NSParagraphStyleAttributeName : paragraphStyle,
//            NSFontAttributeName : labelFont,
//            NSForegroundColorAttributeName : labelColor]
        
        let attrStr = NSAttributedString(string: str, attributes: attrs)
        
        return  attrStr
    }
    
    
    func chooseTap(sender: UITapGestureRecognizer) {
        
        var index: Int! = sender.view?.tag
        
        
        if self.question.type == 1 { //single
            
            if self.question.alternatives[index].isSelected {
                return
            }

            self.clearSelections()
            self.setSelected(index)
            
        } else { //multi
            
            if self.question.alternatives[index].isSelected {
                
                self.deselect(index)
                
            } else {
                
                if self.question.altRemaining() > 0 {
                    self.setSelected(index)
                }
            }
            
            self.updateAltRemaining()
        }
    }

    func deselect(index:Int) {

        self.question.alternatives[index].isSelected  = false
        self.altViews[index].backgroundColor = UIColor.clearColor()
        
        var img = self.altViews[index].subviews[1] as? UIImageView
        img?.image = UIImage(named: "btn_\(index + 1).png")

    }
    
    func setSelected(index:Int) {
        
        self.question.alternatives[index].isSelected  = true
        self.altViews[index].backgroundColor = UIColor.grayScaleColor(230)

        var img = self.altViews[index].subviews[1] as UIImageView
        img.image = UIImage(named: "btn_\(index + 1)_active.png")
    }
    
    func updateAltRemaining() {
        self.altRemainingLabel.text = "Choose: \(self.question.altRemaining())"
    }
    
    func clearSelections() {

        for (i, v) in enumerate(self.altViews) {
            self.deselect(i)
        }
    }
}