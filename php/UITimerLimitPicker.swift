//
//  UITimerPicker.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/7/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit


class UITimeLimitPicker: UIView {
    
    var delegate: UIPickerDelegate!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var okButton: UIButton!
    
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }
    
    // MARK: - NSCoding
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
    
    // MARK: - Nib loading
    
    /**
    Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
    */
    func setupNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        var view = bundle.loadNibNamed("UITimeLimitPicker", owner: self, options: nil)[0] as UIView
        view.frame = self.bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.addSubview(view)
        
        self.datePicker.countDownDuration = NSTimeInterval(Settings.timeLimit)
        
        self.okButton.setBackgroundColor(UIColor.buttonColor(), forUIControlState: UIControlState.Normal)
        self.okButton.setBackgroundColor(UIColor.defaultColor(), forUIControlState: UIControlState.Normal)

    }

    @IBAction func valueChange(sender: UIDatePicker) {

        var seconds = Int(sender.countDownDuration);
        Settings.timeLimit = seconds
        println(seconds)
    }
    
    @IBAction func okPressed(sender: AnyObject) {
        
        self.delegate?.okPressed()
    }
    
}