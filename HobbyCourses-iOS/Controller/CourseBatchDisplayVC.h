//
//  CourseBatchDisplayVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 24/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAWeekView.h"
#import "MAEvent.h"
#import "MAGridView.h"
@interface CourseBatchDisplayVC : ParentViewController<MAWeekViewDataSource,MAWeekViewDelegate>

@property(strong,nonatomic) NSMutableArray *arrTimes;
@property(strong,nonatomic) NSMutableArray <TimeBatch>*timing;
@property(strong,nonatomic) NSString *rowID;
@property(strong,nonatomic) NSString *courseEnd;
@property(strong,nonatomic) NSString *courseStart;
@property(assign) BOOL isDetail;
@property(strong,nonatomic) CourseDetail *courseEntity;
@property(strong,nonatomic) ProductEntity *product;
@property(assign) BOOL isExpand;
@property(assign) BOOL isHideFirstSection;

-(void) initData;
@end
