//
//  AttReportVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 20/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttReportVC_iPad : ParentViewController
@property(strong,nonatomic) ProductEntity *product;
@property(strong,nonatomic) CourseSchedule *courseSchedule;
@property(strong,nonatomic) TimeBatch *session;
@property(assign) NSInteger selectedSession;



@end
