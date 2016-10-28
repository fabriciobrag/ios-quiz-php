//
//  UIPickerView.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/1/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import UIKit


// MARK: PickerViewDelegate
protocol UIPickerDelegate {
    
    func okPressed()
    
}

class UINumberPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: UIPickerDelegate?
    
    @IBOutlet weak var numberPicker: UIPickerView!
    @IBOutlet weak var okButton: UIButton!
    
    let MAX_QUESTIONS = 400
    
    var numbers: [Int] = []

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
        var view = bundle.loadNibNamed("UINumberPicker", owner: self, options: nil)[0] as UIView
        view.frame = self.bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.addSubview(view)
        
        
        for i in 1...self.MAX_QUESTIONS {
            numbers.append(i)
        }
    
        self.numberPicker.selectRow(Settings.numberOfQuestions, inComponent: 0, animated: false)
        
        self.okButton.setBackgroundColor(UIColor.buttonColor(), forUIControlState: UIControlState.Normal)
        self.okButton.setBackgroundColor(UIColor.defaultColor(), forUIControlState: UIControlState.Normal)

    }
    
    
    @IBAction func okPressed(sender: AnyObject) {
        self.delegate?.okPressed()
    }
    
    // MARK: - PickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - PickerViewDelegate

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return String(self.numbers[row]);
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("select: \(self.numbers[row])")
        Settings.numberOfQuestions = row + 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.numbers.count
    }
    
}
