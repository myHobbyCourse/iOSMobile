//
//  AttendanceViewCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 10/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UIImageView *imgMon;
@property(strong,nonatomic) IBOutlet UIImageView *imgTue;
@property(strong,nonatomic) IBOutlet UIImageView *imgWed;
@property(strong,nonatomic) IBOutlet UIImageView *imgThu;
@property(strong,nonatomic) IBOutlet UIImageView *imgFri;
@property(strong,nonatomic) IBOutlet UIImageView *imgSat;
@property(strong,nonatomic) IBOutlet UIImageView *imgSun;

@property(strong,nonatomic) IBOutlet UIView *viewMon;
@property(strong,nonatomic) IBOutlet UIView *viewTue;
@property(strong,nonatomic) IBOutlet UIView *viewWed;
@property(strong,nonatomic) IBOutlet UIView *viewThu;
@property(strong,nonatomic) IBOutlet UIView *viewFri;
@property(strong,nonatomic) IBOutlet UIView *viewSat;
@property(strong,nonatomic) IBOutlet UIView *viewSun;

-(void) setWeekAttendacen:(NSArray<Attendance*>*) arrData;
@end
