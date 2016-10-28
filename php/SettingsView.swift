//
//  SettingsView.swift
//  php
//
//  Created by Fabricio Bedeschi on 12/5/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsDelegate {
    func change()
}


class SettingsView: UIView {

    let FONT_MAX: Float = 26.0
    let FONT_MIN: Float = 8.0
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var fontLabel: UILabel!
    var delegate: SettingsDelegate!
    
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
        var view = bundle.loadNibNamed("SettingsView", owner: self, options: nil)[0] as UIView
        view.frame = self.bounds
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.addSubview(view)
        
        
        self.updateConfig()
    }

    
    func updateConfig() {
        self.fontLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(Settings.fontSize))!
        
        slider.value = Settings.brightness
    }
    
    
    //slider change
    @IBAction func setBrightness(sender: UISlider) {
        
        Settings.brightness = sender.value
        UIScreen.mainScreen().brightness = CGFloat(sender.value)
    }
    
    @IBAction func decreaseFont(sender: AnyObject) {
        
        if Settings.fontSize <= self.FONT_MIN {
            return
        }
        Settings.fontSize--
        println("Font \(Settings.fontSize)")
        
        self.updateConfig()
        self.delegate?.change()
    
    }
    
    
    @IBAction func increaseFont(sender: AnyObject) {

        if Settings.fontSize >= self.FONT_MAX {
            return
        }
        Settings.fontSize++
        
        println("Font \(Settings.fontSize)")
        
        self.updateConfig()
        self.delegate.change()

    }
}