//
//  CellCalenderBatch.h
//  HobbyCourses
//
//  Created by iOS Dev on 01/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FormBatchesVC;

@interface CellCalenderBatch : UITableViewCell<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>


@property(weak,nonatomic) IBOutlet FSCalendar *calenderView;
@property(nonatomic,strong) FormBatchesVC *controller;
-(void) refreshCalender;

@end
