//
//  StudentAttendaceVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentAttendaceVC : ParentViewController
{
    IBOutlet UITableView *tableview;
}
@property(strong,nonatomic) ProductEntity *product;
@property(strong,nonatomic) CourseSchedule *courseSchedule;
@property(strong,nonatomic) TimeBatch *selectedSession;

-(void) getAttendance;
@end
