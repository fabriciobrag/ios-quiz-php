//
//  ScoreView.swift
//  php
//
//  Created by Fabricio Bedeschi on 11/29/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit

class ScoreView: UIView {
    
    
    var startAngle: CGFloat!
    var endAngle: CGFloat!
    
    var percent: Int! = 0
    
    override init() {
        super.init();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.startAngle = CGFloat(M_PI * 1.5)
        self.endAngle = self.startAngle + CGFloat(M_PI * 2)
    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func drawRect(rect: CGRect) {
        
        var circle1 = UIBezierPath()
        circle1.addArcWithCenter(CGPointMake(rect.size.width / 2, rect.size.height / 2), radius: 70,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        circle1.lineWidth = 10
        UIColor.grayScaleColor(200).setStroke()
        circle1.stroke()

        
        var endPercent = (endAngle - startAngle) * (CGFloat(self.percent)  / 100.0) + startAngle
        
        //println("start: \(self.startAngle) end: \(endPercent)")
        
        var circle2 = UIBezierPath()
        circle2.addArcWithCenter(CGPointMake(rect.size.width / 2, rect.size.height / 2), radius: 70,
            startAngle: startAngle,
            endAngle: endPercent,
            clockwise: true)
        
        circle2.lineWidth = 9
        UIColor.defaultColor().setStroke()
        circle2.stroke()

        var text = "\(self.percent)"
        var x: CGFloat = 35
        if self.percent < 10 {
            x = 18
        } else if self.percent == 100 {
            x = 52
        }
        var txtRect = CGRectMake((rect.size.width - x) / 2 , (rect.size.height / 2) - 20, x, 60)
        var font = UIFont(name:"Helvetica", size: 30.0)!
        var textAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName: font,
            NSBackgroundColorAttributeName: UIColor.clearColor()
        ]
        
        text.drawInRect(txtRect, withAttributes: textAttributes)
        
        var percent = "%"
        var percetnRect = CGRectMake(((rect.size.width - x) / 2 ) + txtRect.width, (rect.size.height / 2) - 8, 20, 20)
        textAttributes  = [
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName: UIFont(name:"Helvetica", size: 16.0)!,
            NSBackgroundColorAttributeName: UIColor.clearColor()
        ]
        
        percent.drawInRect(percetnRect, withAttributes: textAttributes)
        
        
    }
}