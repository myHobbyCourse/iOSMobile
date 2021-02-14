//
//  SoldCourseCell.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 10/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SoldCourseCell.h"

@implementation SoldCourseCell
@synthesize lblCreated,lblIdStatus;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(SoldCourses *)course
{
    lblBuyerName.text = course.buyer;
    lblTittle.text = course.title;
    lblIdStatus.text = course.order_id;
    lblCreated.text = course.created;
    lblBillinfo.text = course.billing_info;
    lblQuantity.text = course.quantity;
    lblCoupon.text =course.coupon;
    lblPrice.text =course.price;
    lblSum.text = course.sum;
    lblBillerName.text = course.buyer;
    lblBuyerEmail.text = course.buyer_mail;
    lblBuyerland.text = @"";
    if(course.paypal_payment_id){
        lblBuyerland.text = [NSString stringWithFormat:@"Paypal ID: %@",course.paypal_payment_id];
    }
    
    
}
@end
