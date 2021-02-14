//
//  ShoppingCartViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShoppingCartViewController : ParentViewController < UITableViewDelegate, UITableViewDataSource,PaypalPaymentBlockDelegate>
{
    IBOutlet UILabel *lblTotalPrice;
    IBOutlet UITableView *tblCart;
    IBOutlet UIView *viewEmptyCart;
}
@property(strong,nonatomic) NSMutableArray* arrData;
@end
