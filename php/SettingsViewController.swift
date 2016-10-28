//
//  SettingsViewController.swift
//  php
//
//  Created by Fabricio Bedeschi on 10/28/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, UIPickerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var popupHolder: UIView!
    @IBOutlet weak var overlayView: UIView!

    @IBOutlet weak var listPickerView: UIListPicker!
    @IBOutlet weak var numberPickerView: UINumberPicker!
    @IBOutlet weak var timePickerView: UITimeLimitPicker!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.registerNib(UINib(nibName: "ConfigCell", bundle: nil), forCellReuseIdentifier: "ConfigCell")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.scrollEnabled = false
        
//        var pattern = UIImage(named: "bg.png")
//        self.bgView.backgroundColor = UIColor(patternImage: pattern!)
        
        let singleTap = UITapGestureRecognizer(target: self, action: "overlayTap:")
        self.overlayView.addGestureRecognizer(singleTap)
        
        self.numberPickerView.delegate = self
        self.listPickerView.delegate = self
        self.timePickerView.delegate = self
        
        
        self.startButton.setBackgroundColor(UIColor.buttonColor(), forUIControlState: UIControlState.Normal)
        self.startButton.setBackgroundColor(UIColor.defaultColor(), forUIControlState: UIControlState.Highlighted)
          
    }
    
  
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientation.Portrait.rawValue | UIInterfaceOrientation.PortraitUpsideDown.rawValue)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.screenName = "Settings Screen"
        
        self.navigationController?.navigationBar.hidden = true

    }
    
    func overlayTap(recognizer: UITapGestureRecognizer) {
        closePopUp()
    }
    
    func closePopUp() {
        self.popupHolder.userInteractionEnabled = false
        self.overlayView.alpha = 0
        
        self.timePickerView.alpha = 0
        self.numberPickerView.alpha = 0
        self.listPickerView.alpha = 0
        
        self.tableView.reloadData()

    }
    
    // Mark: - UIPickerViewDelegate
    
    func okPressed() {
        self.closePopUp()
    }
    
    // Mark: - TableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("ConfigCell") as ConfigCell
        
        switch indexPath.row {
        case 0 :
            cell.titleLabel.text = "Number of questions"
            cell.valueLabel.text = String(Settings.numberOfQuestions)
            break
            
        case 1 :
            cell.titleLabel.text = "Time limit"
            cell.valueLabel.text = self.stringTimeLimit()
            break
       
        case 2 :
            cell.titleLabel.text = "Type of questions"
            cell.valueLabel.text = Settings.TYPES[Settings.typeOfQuestions]
            break
            
        default:
            break
        }
        
        cell.selectionStyle = .None
        if cell.respondsToSelector(Selector("preservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }

        if cell.respondsToSelector(Selector("layoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }

        return cell
    }
    
    
    func stringTimeLimit() -> NSString {
        
        var seconds = Settings.timeLimit
        
        var hours: Int = seconds / 3600
        var minutes: Int = (seconds % 3600) / 60
        
        return NSString(format: "%02d:%02d", hours,minutes)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.popupHolder.userInteractionEnabled = true

        self.overlayView.alpha = 0.5
        
        switch indexPath.row {
        case 0:
            self.numberPickerView.alpha = 1.0
            break
            
        case 1:
            self.timePickerView.alpha = 1.0
            break
            
        case 2:
            self.listPickerView.alpha = 1.0
            
        default:
            break
        }

    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
}