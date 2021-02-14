//
//  CourseDetailsVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 04/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailsVC_iPad : ParentViewController
{
    IBOutlet UIView *viewTop;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnSendMessage,*btnFav;
}
@property(strong,nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic) CourseDetail *courseEntity;
@property(strong,nonatomic) NSMutableArray *similerCourses;
@property(strong,nonatomic) NSString *NID;

-(void) getCourseDetails:(NSString *) courseNID;
@end
