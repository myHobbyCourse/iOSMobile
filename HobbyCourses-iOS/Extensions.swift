//
//  Extensions.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit



// MARK: - Text Display
extension UITextField {
    
    func setAttributedPlaceholder(_ text: String, font: UIFont, color: UIColor) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        mutatingAttributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, text.characters.count))
        mutatingAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, text.characters.count))
        attributedPlaceholder = mutatingAttributedString
    }
    
    // This will give combined string with respective attributes
    func setAttributedPlaceholder(_ texts: [String], attributes: [[String : AnyObject]]) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        attributedPlaceholder = attbStr
    }
}

extension UILabel {
    
    func animateLabelAlpha( _ fromValue: NSNumber, toValue: NSNumber, duration: CFTimeInterval) {
        let titleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        titleAnimation.duration = duration
        titleAnimation.fromValue = fromValue
        titleAnimation.toValue = toValue
        titleAnimation.isRemovedOnCompletion = true
        layer.add(titleAnimation, forKey: "opacity")
    }
    
    func setAttributedText(_ text: String, font: UIFont, color: UIColor) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        mutatingAttributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, text.characters.count))
        mutatingAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, text.characters.count))
        attributedText = mutatingAttributedString
    }
    
    // This will give combined string with respective attributes
    func setAttributedText(_ texts: [String], attributes: [[String : AnyObject]]) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        attributedText = attbStr
    }
    
}

// To calculate text rect
extension UIFont {
    // Will return size to fit rect for given string.
    func sizeOfString(_ string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: DBL_MAX),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self],
            context: nil).size
    }
}

// MARK: - Alerts
// Inline Alert message pop up with controller
extension UIAlertController {
    
    class func actionWithMessage(_ message: String?, title: String?, type: UIAlertControllerStyle, buttons: [String], controller: UIViewController ,block:@escaping (_ tapped: String)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: UIAlertActionStyle.default, handler: { (action) -> Void in
                block(btn)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:  { (action) -> Void in
            block("Cancel")
        }))
        
//        alert.popoverPresentationController?.sourceView = controller.view
//        alert.popoverPresentationController?.sourceRect = CGRect(x: controller.view.bounds.size.width / 2.0, y: controller.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)

        controller.present(alert, animated: true, completion: nil)
    }
}

// Inline alert message popup
extension UIAlertView {
    
    class func show(_ title: String, message: String? = nil) {
        let alert: UIAlertView = UIAlertView()
        alert.title = title
        if let msg = message {
            alert.message = msg
        }
        alert.addButton(withTitle: "Dismiss")
        alert.show()
    }
}
extension NSIndexPath {
    // Return IndexPath for given view
    func indexPathForCellContainingView(_ view: UIView, inTableView tableView:UITableView) -> IndexPath? {
        let viewCenterRelativeToTableview = tableView.convert(CGPoint(x: view.bounds.midX, y: view.bounds.midY), from:view)
        return tableView.indexPathForRow(at: viewCenterRelativeToTableview)
    }
    func indexPathForCellContainingCollectionView(_ view: UIView, inCollectionView collectionView:UICollectionView) -> IndexPath? {
        let viewCenterRelativeToTableview = collectionView.convert(CGPoint(x: view.bounds.midX, y: view.bounds.midY), from:view)
        return collectionView.indexPathForItem(at: viewCenterRelativeToTableview)
    }
}
// MARK: - Devices
// To identify devices and its Family
extension UIDevice {
    
    class func isiPhone4() -> Bool {
        return _screenSize.height == 480.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPhone5() -> Bool {
        return _screenSize.height == 568.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPhone6() -> Bool {
        return _screenSize.height == 667.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPhone6plus() -> Bool {
        return _screenSize.height == 736.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPad() -> Bool {
        return _screenSize.height == 1024 && UIDevice.current.userInterfaceIdiom == .pad
    }
    class func isiPadPro() -> Bool {
        return _screenSize.width == 1024 && UIDevice.current.userInterfaceIdiom == .pad
    }
    class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    class func isPhone() -> Bool {
      return UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isAtLeastiOSVersion(_ ver: String) -> Bool {
        return self.current.systemVersion.compare(ver, options: NSString.CompareOptions.numeric, range: nil, locale: nil) != ComparisonResult.orderedAscending
    }
    
    class func configureFor(i6p b1:()->(), i6 b2:()->(), i5 b3:()->(), i4 b4:()->()) {
        if self.isiPhone6plus() {
            b1()
        } else if self.isiPhone6() {
            b2()
        } else if self.isiPhone5() {
            b3()
        } else if self.isiPhone4() {
            b4()
        }
    }
    
}
