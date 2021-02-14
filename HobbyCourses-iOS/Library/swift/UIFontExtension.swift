//
//  NSFont+ManUp.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 13/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit


extension UIFont {

    class func hcOpenSansRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans", size: size)!
    }
    
    class func hcOpenSansSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size)!
    }
    
    class func hcOpenSansBold(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    
    class func hcOpenSansLight(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size)!
    }
    
}
