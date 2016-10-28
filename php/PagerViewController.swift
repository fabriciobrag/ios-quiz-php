//
//  PagerViewController.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/8/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit


class PagerViewController: UIViewController, UIScrollViewDelegate, SettingsDelegate {
    
    @IBOutlet weak var titleItem: UINavigationItem!
    //question pager
    @IBOutlet weak var scrollView: UIScrollView!

    //question controllers
    var viewControllers: NSMutableArray = []
    
    //list of questions
    var questions: NSMutableArray = []
    
    //index
    var currentPage: Int!

    //time left label
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var settingsView: SettingsView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var timer: NSTimer!
    
    var quiz = Quiz.sharedInstance
    
    @IBOutlet weak var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        self.questions = self.quiz.questions
        
        for i in self.questions {
            //init controllers
            self.viewControllers.addObject(NSNull());
        }
        
        //pager setup
        self.scrollView.pagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.layoutIfNeeded()
        let pagerScrollViewSize = self.scrollView.frame.size
        //println("PagerScrollView frame: \(self.scrollView.frame)")
        self.scrollView.contentSize = CGSizeMake(pagerScrollViewSize.width * CGFloat(self.questions.count), 300)
        
        //click out overlay
        let singleTap = UITapGestureRecognizer(target: self, action: "overlayTap:")
        self.overlayView.addGestureRecognizer(singleTap)

        self.settingsView.delegate = self
        
        
        self.nextButton.setBackgroundColor(UIColor.buttonColor(), forUIControlState: UIControlState.Normal)
        self.nextButton.setBackgroundColor(UIColor.defaultColor(), forUIControlState: UIControlState.Normal)
        self.prevButton.setBackgroundColor(UIColor.buttonColor(), forUIControlState: UIControlState.Normal)
        self.prevButton.setBackgroundColor(UIColor.defaultColor(), forUIControlState: UIControlState.Normal)
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        if !self.quiz.finished  {
            self.timer.invalidate()
        }
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.quiz.finished {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        }

        goToCurrentPage(false)
        
        //keep screen on
        UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.layoutSubviews()
    }
    
    func updateTimer() {
        self.timeLabel.text = self.quiz.getTimeLeft()
    }
    
    func updateButtons() {
        
        if self.currentPage == 0 {
            self.prevButton.enabled = false
        } else if self.currentPage == self.questions.count - 1 {
            self.nextButton.enabled = false
        } else {
            self.nextButton.enabled = true
            self.prevButton.enabled = true
        }
    }

    
    //MARK: - settings
    
    @IBAction func showSettings (sender: AnyObject) {
        
        if settingsView.alpha == 0 {
            self.settingsView.userInteractionEnabled = true
            self.settingsView.alpha = 1.0
            self.overlayView.alpha = 0.5
        } else {
            closeSettings()
        }
    }
    
    func overlayTap(recognizer: UITapGestureRecognizer) {
        closeSettings()
    }
    
    func closeSettings() {
        self.settingsView.userInteractionEnabled = false
        self.settingsView.alpha = 0
        self.overlayView.alpha = 0
        
    }
    
    func change() {
        //println("Settings change")
        
        // recreate all controllers
        for controller in self.viewControllers {
            var c = controller as? QuestionViewController
            c?.view.removeFromSuperview()
        }
        
        self.viewControllers = NSMutableArray()
        for i in self.questions {
            self.viewControllers.addObject(NSNull());
        }

        goToCurrentPage(false)
    
    }

    
    //MARK: - pager navigation

    @IBAction func nextClick (sender: AnyObject) {
        if self.currentPage < self.questions.count - 1 {
            self.currentPage = self.currentPage + 1
            goToCurrentPage(true)
            
        }
    }
    
    @IBAction func prevClick (sender: AnyObject) {
        if self.currentPage > 0 {
            self.currentPage = self.currentPage - 1
            goToCurrentPage(true)
            
        }
    }

    
    func goToCurrentPage(animated: Bool) {

        //println("goto page: \(self.currentPage)")
        
        loadPage(self.currentPage - 1)
        loadPage(self.currentPage)
        loadPage(self.currentPage + 1)
        
        // update the scroll view to the appropriate page
        var bounds = self.scrollView.bounds
        bounds.origin.x = CGRectGetWidth(bounds) *  CGFloat(self.currentPage)
        bounds.origin.y = 0
        self.scrollView.scrollRectToVisible(bounds, animated: animated)
        
        self.titleItem.title = "Question \(self.currentPage + 1)"
        
        //hide keyboard
        self.view.endEditing(true)
        
        //change prev/next buttons text
        self.updateButtons()
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= self.questions.count {
            return
        }
        
        var controller: QuestionViewController
        
        let obj:NSObject = self.viewControllers.objectAtIndex(page) as NSObject

        //lazy instantiation view controllers
        if obj == NSNull() {
            
            controller = QuestionViewController()
            controller.question = self.questions.objectAtIndex(page) as Question
            self.viewControllers.replaceObjectAtIndex(page, withObject: controller)

        } else {
            controller = self.viewControllers.objectAtIndex(page) as QuestionViewController
        }
        
        if self.quiz.finished {
            controller.showAnswer = true
        }
        
         //add the controller's view
        if (controller.view.superview == nil) {
            
            var frame = self.scrollView.frame
            frame.origin.x = CGRectGetWidth(frame) * CGFloat(page);
            frame.origin.y = 0
            
            controller.view.frame = frame;
                    
            self.addChildViewController(controller)
            self.scrollView.addSubview(controller.view)
            
            controller.didMoveToParentViewController(self)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var pageWidth = CGRectGetWidth(self.scrollView.frame)
        
        var page:Int = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1)
        
        if page != self.currentPage {
            self.currentPage = page
            //println("Scroll acelerating page: \(page)")
            
            self.goToCurrentPage(true)
        }
    }
}