//
//  CourseDetailsVC.h
//  AirbnbClone
//
//  Created by iOS Dev on 25/08/16.
//  Copyright © 2016 iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailsVC : ParentViewController
{
    IBOutlet UIView *viewTop;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnSendMessage,*btnFav;
    IBOutlet UIButton *btnAvailability;
    IBOutlet UILabel *lblPriceBottom;
    IBOutlet UILabel *lblRateBottom;
    IBOutlet UIImageView *imgVRate;

}
@property (nonatomic, weak) IBOutlet UIImageView *mainImageView;
@property (nonatomic, strong) NSData *imgVSource;

@property(strong,nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic) CourseDetail *courseEntity;
@property(strong,nonatomic) NSMutableArray *similerCourses;
@property(assign) int isDescSize;
@property(strong,nonatomic) NSString *NID;

-(void) getCourseDetails:(NSString *) courseNID;
@end
