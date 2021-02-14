//
//  Subclasses.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
let _screenSize     = UIScreen.main.bounds.size
let _heighRatio     = _screenSize.height/736
let _widthRatio     = _screenSize.width/414
// MARK: - Useful Classes
class GenericCollectionViewCell: UICollectionViewCell
{
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heighRatio
                const.constant = v2
            }
        }
    }
    
}



@objc class PushWithoutAnimationSegue: UIStoryboardSegue {
    override func perform() {
        let svc =  source
        svc.navigationController?.pushViewController(destination , animated: false)
    }
}

@objc class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
    }
}

@objc class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
    }
}
@objc class RoundedCournerButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}
@objc class RoundedCournerShadowButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
}
@objc class RoundedCournerShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
}
@objc class RoundedCournerView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
    }
}

@objc class RoundedLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
    }
}
class PaddingTextFeild: UITextField
{
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return CGRect(x: bounds.origin.x + 30, y: 0, width: bounds.size.width - 10, height: bounds.size.height)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return CGRect(x: bounds.origin.x + 30, y: 0, width: bounds.size.width - 10, height: bounds.size.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return CGRect(x: bounds.origin.x + 30, y: 0, width: bounds.size.width - 10, height: bounds.size.height)
    }
}

/// This Class will decrease font size as well it will make intrinsiz content size 10 pixel bigger as we need padding on both side of label
@objc class PointsLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _widthRatio)
        self.layer.cornerRadius = ((self.bounds.size.height + 5) * _widthRatio)/2
        self.layer.masksToBounds = true
    }
    
    override var intrinsicContentSize : CGSize {
        let asize = super.intrinsicContentSize
        return CGSize(width: asize.width + 8, height: asize.height + 5)
    }
}
@objc class PointsLabelHeight: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _heighRatio)
        self.layer.cornerRadius = ((self.bounds.size.height) * _heighRatio)/2
        self.layer.masksToBounds = true
    }
    
    override var intrinsicContentSize : CGSize {
        let asize = super.intrinsicContentSize
        return CGSize(width: asize.width + 8, height: asize.height + 5)
    }
}
@objc class PointsLabelWidth: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _widthRatio)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    override var intrinsicContentSize : CGSize {
        let asize = super.intrinsicContentSize
        return CGSize(width: asize.width + 15, height: asize.height + 5)
    }
}
//MARK: - HorizontalLineLabel
@objc class HorizontalLineLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0.5))
    }
}
