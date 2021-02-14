//
//  AttCalenderVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttCalenderVC : ParentViewController{
    IBOutlet UITableView *tableview;
    IBOutlet NSLayoutConstraint *_heightCalendar;
}
@property(weak,nonatomic) IBOutlet FSCalendar *calenderView;
@property(strong,nonatomic) ProductEntity *product;
@property(strong,nonatomic) CourseSchedule *courseSchedule;

-(void) initData;
@end
