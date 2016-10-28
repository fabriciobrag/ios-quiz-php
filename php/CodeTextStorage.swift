//
//  CodeTextStorage.swift
//  php
//
//  Created by Fabricio on 10/24/14.
//  Copyright (c) 2014 z. All rights reserved.
//

import Foundation
import UIKit


class CodeTextStorage: NSTextStorage {

    var str: NSMutableAttributedString!
    
    

    override init () {

        str = NSMutableAttributedString()
        
        
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Read

    func string() -> NSMutableString {
        return self.str.mutableString
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [NSObject : AnyObject] {
        return str.attributesAtIndex(location, effectiveRange: range)
    }
    
    
    // MARK: - Edit
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        self.str.replaceCharactersInRange(range, withString: str)
        
        self.edited(NSTextStorageEditActions.EditedCharacters, range: range, changeInLength: (str as NSString).length - NSInteger(range.length))
    }
    
    
    override func setAttributes(attrs: [NSObject : AnyObject]?, range: NSRange) {
        self.str.setAttributes(attrs, range: range)
        
        self.edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
    }
    
    // MARK: Syntax Highlighting
    
    override func processEditing() {
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let font = UIFont(name: "HelveticaNeue", size: CGFloat(Settings.fontSize))!
        
        let color = UIColor.blackColor()
        
        let attrs = NSDictionary(objects: [paragraphStyle, font], forKeys: [NSParagraphStyleAttributeName, NSFontAttributeName])
        
        self.addAttributes(attrs, range: self.editedRange)
        
        
        let pattern = "\\[code\\](?:.|[\\n\\r])*?\\[\\/code\\]"

        var regex: NSRegularExpression = NSRegularExpression(pattern:pattern, options: nil, error: nil)!
        
        //clear text color
        self.removeAttribute(NSForegroundColorAttributeName, range: self.editedRange)
        
        regex.enumerateMatchesInString(self.str.string, options: nil, range: self.editedRange, usingBlock: { match, flags, stop in
            
            self.processKeywords(match.range)
            self.processNumbers(match.range)
            self.processVariables(match.range)
            self.processStrings(match.range)
            self.removeCodeTags(match.range)
            
        })
        
        // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
        super.processEditing()
    }
    
    
    func removeCodeTags(range:NSRange) {
        
        let pattern = "\\[(\\/)?code\\]"
        
        let regex: NSRegularExpression = NSRegularExpression(pattern:pattern, options: nil, error: nil)!
        
        regex.enumerateMatchesInString(self.string, options: nil, range: range, usingBlock: { match, flags, stop in
            
            self.replaceCharactersInRange(match.range, withString: "      ")//replace with whitespace, keep the same range
        })
        
    }

    func processKeywords(range:NSRange) {
        
        let pattern = "\\b(__halt_compiler|abstract|and|array|as|break|callable|case|catch|class|clone|const|continue|declare|default|die|do|echo|else|elseif|empty|enddeclare|endfor|endforeach|endif|endswitch|endwhile|eval|exit|extends|final|for|foreach|function|global|goto|if|implements|include|include_once|instanceof|insteadof|interface|isset|list|namespace|new|or|print|private|protected|public|require|require_once|return|static|switch|throw|trait|try|unset|use|var|while|xor)\\b"
        
        let regex: NSRegularExpression = NSRegularExpression(pattern:pattern, options: nil, error: nil)!
        
        regex.enumerateMatchesInString(self.string, options: nil, range: range, usingBlock: { match, flags, stop in

            self.addAttribute(NSForegroundColorAttributeName, value: UIColor.hexStringToUIColor("#CC7832"), range: match.range)
        })
        
    }
    
    
    func processStrings(range:NSRange) {
        
        let pattern = "(?:\"|')(?:.|[\\n\\r])*?(?:\"|')"
        
        let regex: NSRegularExpression = NSRegularExpression(pattern:pattern, options: nil, error: nil)!
        
        regex.enumerateMatchesInString(self.string, options: nil, range: range, usingBlock: { match, flags, stop in
            
            self.addAttribute(NSForegroundColorAttributeName, value: UIColor.hexStringToUIColor("#6A8759"), range: match.range)
        })
        
    }

    
    func processNumbers(range:NSRange) {
        
        let pattern = "\\b(\\d*[.]?\\d+)\\b"
        
        let regex: NSRegularExpression = NSRegularExpression(pattern:pattern, options: nil, error: nil)!
        
        regex.enumerateMatchesInString(self.string, options: nil, range: range, usingBlock: { match, flags, stop in
            
            self.addAttribute(NSForegroundColorAttributeName, value: UIColor.hexStringToUIColor("#6897BB"), range: match.range)
        })
        
    }
    
    
    func processVariables(range:NSRange) {
        
        let pattern = "\\$[a-zA-Z_0-9]+"
        
        let regex: NSRegularExpression = NSRegularExpression(pattern:pattern, options: nil, error: nil)!
        
        regex.enumerateMatchesInString(self.string, options: nil, range: range, usingBlock: { match, flags, stop in
            
            self.addAttribute(NSForegroundColorAttributeName, value: UIColor.hexStringToUIColor("#6F599D"), range: match.range)
        })
        
    }
    
    
    

}