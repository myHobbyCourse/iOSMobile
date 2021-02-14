//
//  StringExtension.swift
//  TableShare
//
//  Created by Yudiz Solutions Pvt. Ltd. on 23/02/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Validation
extension String {
    func isValidEmailAddress() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let temp = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        return temp
    }
}
// MARK: - Layout
extension NSString {
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    func WidthWithNoConstrainedHeight(_ font: UIFont) -> CGFloat {
        let width = CGFloat(999)
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
}
//MARK: - Concate
extension String {
    func concateString(withSeparator separator: String, andString secondString: String?) -> String {
        var displayString: String = ""
        displayString = self
        
        if let string2 = secondString {
            if !displayString.isEmpty {
                displayString += "\(separator) \(string2)"
            }else{
                displayString = ""
            }
        }else{
            displayString = ""
        }
        return displayString
    }
}

//MARK: - Character check
extension NSString {
    
    func trimmedString() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find, options: NSString.CompareOptions.caseInsensitive) != nil
    }
    
    func trimWhiteSpace(_ newline: Bool = false) -> String {
        if newline {
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else {
            return self.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
}
//Emoji endcoe
extension String{
    func encodeEmoji()-> String{
        let emojiData = self.data(using: String.Encoding.utf8)
        var message  = self
        if let data = emojiData{
            let strEncode = String(data: data, encoding: String.Encoding.nonLossyASCII)
            if let msgStr  = strEncode {
                message = msgStr
            }
        }
        return message
    }
    func decodeEmoji()->String{
        let emojiData = self.data(using: String.Encoding.nonLossyASCII)
        var message  = self
        if let data = emojiData{
            let strEncode = String(data: data, encoding: String.Encoding.utf8)
            if let msgStr  = strEncode {
                message = msgStr
            }
        }
        return message
    }
}
//MARK: - Conversion
extension String {
    
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
}
// MARK: - Attributed
extension NSAttributedString {
    
    // This will give combined string with respective attributes
    func attributedText(_ texts: [String], attributes: [[String : AnyObject]]) -> NSAttributedString {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        return attbStr
    }
}
