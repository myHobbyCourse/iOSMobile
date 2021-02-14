//
//  OrderCourseTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "OrderCourseTableViewCell.h"

@implementation OrderCourseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(UserOrder*) order {
    lblOrder_number.text = order.order_id;
    if ([order.status.lowercaseString isEqualToString:@"pending"]) {
        lblOrder_status.textColor = [UIColor redColor];
        lblOrder_status.text = @"pending";
    }else if([order.status.lowercaseString isEqualToString:@"completed"]){
        lblOrder_status.textColor = __THEME_GREEN;
        lblOrder_status.text = @"complete";
    }else{
        lblOrder_status.text = order.status;
    }
    //lblOrder_status.text = order.status;
    lblTotal.text = order.order_total;
    lblUpdated_date.text = order.created;
  
    
    
    
}

@end
