//
//  AttendanceVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 10/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceVC : ParentViewController
{
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *lblHeader;
}
@property(strong,nonatomic) TimeBatch *session;
@property(strong,nonatomic) ProductEntity *product;
@property(strong,nonatomic) NSString *courseTitle;
@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;
@property (nonatomic, strong)	id	currentPopTipViewTarget;
-(void) getAttendanceInfo;
@end
