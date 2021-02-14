//
//  CouponTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData: (Coupon*) coupon {
    lblTitle.text = coupon.OrderTitle;
    lblOrder.text = coupon.Order_ID;
    lblCoupon.text = coupon.OrderCoupon;
    lbldate.text = coupon.Created_date;
}

@end
