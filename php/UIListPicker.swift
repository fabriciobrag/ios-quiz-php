//
//  UIListPickerView.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/7/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit

class UIListPicker: UIView, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate: UIPickerDelegate!

    
    
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
        var view = bundle.loadNibNamed("UIListPicker", owner: self, options: nil)[0] as UIView
        view.frame = self.bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.addSubview(view)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.okButton.setBackgroundColor(UIColor.buttonColor(), forUIControlState: UIControlState.Normal)
        self.okButton.setBackgroundColor(UIColor.defaultColor(), forUIControlState: UIControlState.Normal)

    }
    
    
    //MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Settings.TYPES.count
    }
    
    
    //MARK: - TableView DataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        cell.textLabel?.text = Settings.TYPES[indexPath.row]
        cell.textLabel?.font = UIFont(name: Settings.fontName, size: 16.0)
        
        if indexPath.row == Settings.typeOfQuestions {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Settings.typeOfQuestions = indexPath.row
        println("select \(Settings.TYPES[indexPath.row])")
        self.tableView.reloadData()
        
    }
    
    @IBAction func okPressed(sender: AnyObject) {
        self.delegate?.okPressed()
    }
}