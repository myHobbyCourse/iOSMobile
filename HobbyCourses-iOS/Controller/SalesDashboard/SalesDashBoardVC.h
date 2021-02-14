//
//  SalesDashBoardVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesDashBoardVC : ParentViewController
{
    IBOutlet UILabel *lblMyClasses;
    IBOutlet UILabel *lblMyReview;
    IBOutlet UILabel *lblMyBookings;
    IBOutlet UILabel *lblMyTotalRevenue;
    
    IBOutlet UIButton *btnBack;
}
@property(assign) BOOL isHideBackBtn;

@end
