//
//  ShoppingCartTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingCart.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

@interface ShoppingCartTableViewCell : MGSwipeTableCell {
    IBOutlet UILabel*   lblName;
    IBOutlet UILabel*   lblTitle;
    IBOutlet UIButton*  btnCount;
    IBOutlet UILabel*  lblPrice;
    
}

- (void) setData:(ShoppingCart*) shoppingCart;
- (void) setCartData:(NSDictionary*) dict;

@end
