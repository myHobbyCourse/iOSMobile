//
//  BatchDisplay.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 25/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAWeekView.h"
#import "MAEvent.h"
#import "MAGridView.h"

@class MAWeekView;
@interface BatchDisplay : UITableViewCell<MAWeekViewDataSource,MAWeekViewDelegate>

@property (strong, nonatomic) IBOutlet MAWeekView *weekView;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentWeek;
@property (strong, nonatomic) IBOutlet UILabel *lblBatchMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblBatchCaption;

@property(strong,nonatomic) NSMutableArray * weekStartDates;
@property (strong, nonatomic) NSString *rowID;
@property (strong, nonatomic) NSString *courseStartDate;
@property (strong, nonatomic) NSString *courseEndDate;
@property (strong, nonatomic) NSMutableArray *arrTimes;
@property (strong, nonatomic) NSString *courseName;

-(void)setData;


@end
