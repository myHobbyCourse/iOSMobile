//
//  BatchCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 04/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAWeekView.h"
#import "MAEvent.h"
#import "MAGridView.h"
@class MAWeekView;


@interface BatchCell : UITableViewCell<MAWeekViewDataSource,MAWeekViewDelegate,CalenderPickerDelegate>

@property (readonly) MAEvent *event;
@property (strong, nonatomic) IBOutlet MAWeekView *weekView;
@property(weak,nonatomic) CreateCourseiPadViewController * controller;
@property(weak,nonatomic) CourseFrom * dataSet;
@property(strong,nonatomic) NSMutableArray * weekStartDates;
-(void)setData:(CourseFrom *)courseFrom;
-(void)copyUntill:(NSString*)untillDate startDate:(NSString*) copyFromDate;
@end
