//
//  StudentAttCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentAttCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UIButton * btnPresent;
@property(strong,nonatomic) IBOutlet UIButton * btnAbsent;
@property(strong,nonatomic) IBOutlet UIButton * btnLate;
@property(strong,nonatomic) IBOutlet UIButton * btnComment;
@property(strong,nonatomic) IBOutlet UILabel * lblName;
@property(strong,nonatomic) IBOutlet UIImageView * imgV;
@property(strong,nonatomic) IBOutlet UILabel * lblCourse;
@property(strong,nonatomic) IBOutlet UILabel * lblStartDate;
@property(strong,nonatomic) IBOutlet UILabel * lblEndDate;
@property(strong,nonatomic) IBOutlet UILabel * lblBatchDateTime;


@property(weak,nonatomic) StudentAttendaceVC *controller;
@property(weak,nonatomic) Student *student;
-(void) setStudentDate:(Student*) stud;
@end
