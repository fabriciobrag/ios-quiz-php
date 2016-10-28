//
//  Colors.swift
//  php
//
//  Created by Fabricio Bedeschi on 12/5/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // MARK: - Custom Colors
    
    /**xxx
    Get gray from scale factor
    
    :params: scale CGFloat gray color scale
    
    :returns: UIColor
    */
    class func grayScaleColor(scale: CGFloat) -> UIColor {
        return UIColor(red: scale/255.0, green: scale/255.0, blue: scale/255.0, alpha: 1.0)
    }
    
    
    
    /**
    #8892bf
    
    :returns: UIColor #8892bf
    */
    class func defaultColor() -> UIColor {
        return UIColor(red: 136.0/255.0, green: 146.0/255.0, blue: 191.0/255.0, alpha: 1.0)
    }
    
    
    /**
    #96a1d1
    
    :returns: UIColor #96a1d1
    */
    class func buttonColor() -> UIColor {
        return UIColor(red: 150/255.0, green: 161/255.0, blue: 209/255.0, alpha: 1.0)
    }
    
    
    /**
    #c3ebb9
    
    :returns: UIColor #c3ebb9
    */
    class func bgCorrect() -> UIColor {
        return UIColor(red: 195.0/255.0, green: 235.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    }
    
    
    /**
    Cinza #212121
    
    :returns: UIColor #212121
    */
    class func textDefaultColor() -> UIColor {
        return  UIColor.grayScaleColor(33.0)
    }
    
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (countElements(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    

}