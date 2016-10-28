//
//  SumaryViewController.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/7/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import UIKit
import Foundation


class SumaryViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {

    var questions: NSMutableArray = []
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    var quiz: Quiz!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.quiz = Quiz.sharedInstance
            self.questions = self.quiz.questions

            dispatch_async(dispatch_get_main_queue()) {
                self.updateData()
                self.loading.stopAnimating()
            }
        }
        
        self.tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.screenName = "Summary Screen"
        
        self.navigationController?.navigationBar.hidden = false
        self.updateData()
        
        
       
    }

    
    func updateData() {
        
        if self.quiz != nil {
            
            if self.quiz.finished {
                self.navItem.title = "\(self.quiz.result) / \(self.questions.count)"
            } else {
                self.navItem.title = "\(self.quiz.getDone()) / \(self.questions.count)"
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func closeQuiz(sender: AnyObject) {

        if self.quiz.finished {
            self.quiz.reset()
            self.navigationController?.popToRootViewControllerAnimated(true)
            return
        }
        
        UIAlertView(title: "Finish", message: "Are you sure you want to exit?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes").show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowQuestionSegue" {
            
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let pvc : PagerViewController = segue.destinationViewController as PagerViewController
            pvc.currentPage = indexPath.row
            
        }
    }
    
   
    //Mark: - Result
    
    
    @IBAction func resultClick(sender: AnyObject) {
 
        if self.quiz.finished {
            self.performSegueWithIdentifier("ResultSegue", sender: self)
            return
        }
        
        var leftQuestions = self.questions.count - self.quiz.getDone()
        if leftQuestions > 0 {
            UIAlertView(title: "Result", message: "\(leftQuestions) question(s) left. Do you want finish?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes").show()
        } else {
            self.performSegueWithIdentifier("ResultSegue", sender: self)
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        //result alert and yes pressed
        if alertView.title == "Result" && buttonIndex == 1 {
            
            if !self.quiz.finished {
                self.quiz.finished = true
            }
            
            self.performSegueWithIdentifier("ResultSegue", sender: self)
        }
        else {
            if buttonIndex == 1 {
                self.quiz.reset()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }

        }
        
   }
    
    
    //Mark: - TableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: QuestionCell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCell") as QuestionCell

        var q = self.questions[indexPath.row] as Question
    
        cell.questionLabel.text = q.question
        cell.numberLabel.text = String(indexPath.row + 1)
        
        if q.isAnswered() && !self.quiz.finished {
            cell.backgroundColor = UIColor.grayScaleColor(220.0)
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        if self.quiz.finished {
        
            if q.isCorret() {
                cell.contentView.backgroundColor = UIColor.bgCorrect()
            } else {
                cell.contentView.backgroundColor = UIColor.hexStringToUIColor("#ffb7b7")
            }
        }
        
        if cell.respondsToSelector(Selector("preservesSuperviewLayoutMargins:")) {

            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.respondsToSelector(Selector("layoutMargins:")) {

            cell.layoutMargins = UIEdgeInsetsZero
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowQuestionSegue", sender: self)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
   
}

