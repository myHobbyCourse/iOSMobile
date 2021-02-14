//
//  SoldCourseCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 10/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoldCourseCell : UITableViewCell
{
    IBOutlet UILabel *lblTittle;
    IBOutlet UILabel *lblIdStatus;
    IBOutlet UILabel *lblCreated;
    IBOutlet UILabel *lblBuyerName;
    IBOutlet UILabel *lblBuyerEmail;
    IBOutlet UILabel *lblBuyerland;
    IBOutlet UILabel *lblBuyerMobile;
    IBOutlet UILabel *lblBillinfo;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *lblCoupon;
    IBOutlet UILabel *lblSum;
    IBOutlet UILabel *lblBillerName;
}
@property(strong,nonatomic) IBOutlet UILabel *lblCreated;
@property(strong,nonatomic) IBOutlet UILabel *lblIdStatus;

-(void) setData:(SoldCourses*) course;
@end
