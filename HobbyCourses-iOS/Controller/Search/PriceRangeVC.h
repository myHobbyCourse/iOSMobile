//
//  PriceRangeVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceRangeVC : ParentViewController<TTRangeSliderDelegate>{
    IBOutlet UILabel *lblPrice;
    IBOutlet NSLayoutConstraint *_leftPos;
    IBOutlet NSLayoutConstraint *_rightPos;
    IBOutlet UIView *viewContainer;

}
@property (weak, nonatomic) IBOutlet TTRangeSlider *rangeSliderCustom;
@property(strong,nonatomic) Search *searchObj;

@end
