//
//  CouponTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

@interface CouponTableViewCell : UITableViewCell {
    IBOutlet UILabel*   lblTitle;
    IBOutlet UILabel*   lblOrder;
    IBOutlet UILabel*   lblCoupon;
    IBOutlet UILabel*   lbldate;
}

- (void) setData: (Coupon*) coupon;

@end
