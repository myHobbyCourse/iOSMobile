//
//  ShoppingCartTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"

@implementation ShoppingCartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(ShoppingCart*) shoppingCart {
    lblTitle.text = shoppingCart.course.title;
    [btnCount setTitle:[NSString stringWithFormat:@"%d", shoppingCart.count] forState:UIControlStateNormal];
    //[btnPrice setTitle:[NSString stringWithFormat:@"$%d", shoppingCart.price] forState:UIControlStateNormal];
}
- (void) setCartData:(NSDictionary*) dict {
    lblName.text = dict[@"category"];
    lblTitle.text = dict[@"course_tittle"];
//    [btnCount setTitle:[NSString stringWithFormat:@"%d", shoppingCart.count] forState:UIControlStateNormal];
    
    lblPrice.text = [NSString stringWithFormat:@"£ %@",dict[@"price"]];
}

@end
