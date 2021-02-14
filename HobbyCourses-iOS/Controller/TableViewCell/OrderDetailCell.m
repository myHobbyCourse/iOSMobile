//
//  OrderDetailCell.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 18/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    btnBatchDetails.layer.cornerRadius = 5.0;
    btnBankInfo.layer.cornerRadius = 5.0;
    btnBatchDetails.layer.masksToBounds = YES;
    btnBankInfo.layer.masksToBounds = YES;
    lblBorder_iPad.layer.cornerRadius = 10.0;
    lblBorder_iPad.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(OrderDetail *)oderDetail summery:(UserOrder *)headerOrder
{
    lblbilling_info.text = [NSString stringWithFormat:@"%@ %@ %@ %@",headerOrder.billing_name_line,headerOrder.billing_city,headerOrder.billing_thoroughfare,headerOrder.billing_premise];
    lblorder_total.text = headerOrder.order_total;
    lblCourseTittle.text = oderDetail.title;
    lblstart_date.text = oderDetail.start_date;
    lblend_date.text = oderDetail.end_date;
    lblquantity.text = oderDetail.quantity;
    lblprice.text = oderDetail.price;
    lblCoupon.text = headerOrder.coupon;
    lblsum.text = oderDetail.sum;
    lblseller.text = oderDetail.seller;
    lblseller_info.text = oderDetail.course_address;

    lblSellerName.text = oderDetail.seller;
    lblSellerLand.text = oderDetail.seller_landline_number;
    lblSellerMobile.text =oderDetail.seller_phone;
    lblSellerAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@",oderDetail.seller_address,oderDetail.seller_address_2,oderDetail.seller_city,oderDetail.seller_postal_code];
    lblSellerEmail.text = oderDetail.seller_mail;
    
    if ([headerOrder.payment_method.lowercaseString isEqualToString:@"bank_transfer"]) {
        btnBankInfo.hidden = false;
    }else{
        btnBankInfo.hidden = true;
    }
}
@end
