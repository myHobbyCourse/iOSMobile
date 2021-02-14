//
//  AttMarkVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AttMarkVC_iPad.h"

@interface AttMarkVC_iPad () {
    
    IBOutlet UIView *viewShadow;
    IBOutlet UILabel *lblCourseName;
}

@end

@implementation AttMarkVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addShaowForiPad:viewShadow];
    lblCourseName.text = self.courseSchedule.title;
    AttCalenderVC *vc = self.childViewControllers[1];
    vc.product = self.product;
    vc.courseSchedule = self.courseSchedule;
    [vc initData];
    StudentAttendaceVC *studentAttendaceVC = self.childViewControllers[0];
    studentAttendaceVC.product = self.product;
    studentAttendaceVC.courseSchedule = self.courseSchedule;
    studentAttendaceVC.selectedSession = (self.product.timingsDate.count > 0) ? self.product.timingsDate[0] : nil;
    [studentAttendaceVC getAttendance];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Mark Attendance Screen"];
}
-(void) refreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}

@end
