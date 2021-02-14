//
//  ConstrainedSubclasses.swift
//  TableShare
//
//  Created by Yudiz Solutions Pvt. Ltd. on 10/02/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//MARK: - WidthButton
class JPWidthButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = titleLabel?.font {
            if UIDevice.current.userInterfaceIdiom == .pad {
            
            }else{
                titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
            }
        }
    }
}

class JPWidthTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = font {
            if UIDevice.current.userInterfaceIdiom == .pad {
                
            }else{
                font = afont.withSize(afont.pointSize * _widthRatio)
            }
        }
    }
}

//MARK: - HeightButton
class JPHeightButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = titleLabel?.font {
            if UIDevice.current.userInterfaceIdiom == .pad {
                
            }else{
                titleLabel?.font = afont.withSize(afont.pointSize * _heighRatio)
            }
        }
    }
}

//MARK: - WidthLabel
class JPWidthLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            
        }else{
            font = font.withSize(font.pointSize * _widthRatio)
        }
    }
}

//MARK: - HeightLabel
class JPHeightLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.current.userInterfaceIdiom == .pad {
            
        }else{
            font = font.withSize(font.pointSize * _heighRatio)
        }
    }
}

//MARK: - WidthRoundLabel
class JPWidthRoundLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _widthRatio)
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
    }
}

//MARK: - HeightRoundLabel
class JPHeightRoundLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _heighRatio)
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
    }
}

//MARK: TSWidthTextField
class TSWidthTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font!.withSize(font!.pointSize * _widthRatio)
    }
}

//MARK: TSHeightTextField
class TSHeightTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font!.withSize(font!.pointSize * _heighRatio)
    }
}

//MARK: TSWidthTextView
class TSWidthTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font!.withSize(font!.pointSize * _widthRatio)
    }
}

//MARK: - ConstrainedCollectionViewCell
class ConstrainedCollectionViewCell: UICollectionViewCell {

    //MARK: Outlets
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?

    //MARK: Awaken
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
class ConstrainedControl: UIControl {
    
    // MARK: Outlets
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    // MARK: Awaken
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
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
