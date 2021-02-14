//
//  CellCalenderBatch.m
//  HobbyCourses
//
//  Created by iOS Dev on 01/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CellCalenderBatch.h"

@implementation CellCalenderBatch

- (void)awakeFromNib {
    [super awakeFromNib];
    self.calenderView.delegate = self;
    self.calenderView.dataSource = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) refreshCalender {
    for (NSDate *d in self.calenderView.selectedDates) {
        [self.calenderView deselectDate:d];
    }
    for (TimeBatch *obj in dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes) {
        [self.calenderView selectDate:obj.batch_start_date];
    }
    [self.calenderView reloadData];
}
#pragma mark - FSCalenderDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date {
    if ([date compare:[NSDate date]] == NSOrderedAscending) {
        return false;
    }
    return true;
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    [calendar deselectDate:date];
    [self handleCalenderTap:date];

}
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date{
    [self handleCalenderTap:date];
}
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    if (dataClass.arrCourseBatches[self.controller.currentIndex].startDate != nil && dataClass.arrCourseBatches[self.controller.currentIndex].endDate != nil) {
        if ([[globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.controller.currentIndex].startDate] compare:date] == NSOrderedDescending || [[globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.controller.currentIndex].endDate] compare:date] == NSOrderedAscending) {
            return  [UIColor darkGrayColor];
        }else{
            return [UIColor blackColor];
        }
    }
    return [UIColor blackColor];
}
#pragma mark- UIButton
-(IBAction)btnPreview:(UIButton*)sender{
    if (dataClass.arrCourseBatches[self.controller.currentIndex].startDate == nil) {
        showAletViewWithMessage(@"Please select batch start date");
        return;
    }
    if (dataClass.arrCourseBatches[self.controller.currentIndex].endDate == nil) {
        showAletViewWithMessage(@"We won’t keep you too long, please Select Class End date");
        return;
    }
    
    CourseBatchDisplayVC  *vc =(CourseBatchDisplayVC*) [getStoryBoardDeviceBased(StoryboardMain) instantiateViewControllerWithIdentifier: @"CourseBatchDisplayVC"];
    vc.timing = dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes;
    vc.courseStart = dataClass.arrCourseBatches[self.controller.currentIndex].startDate;
    vc.courseEnd = dataClass.arrCourseBatches[self.controller.currentIndex].endDate;
    vc.isHideFirstSection = true;
    vc.isExpand = YES;
    ProductEntity *product = [ProductEntity new];
    product.course_end_date = dataClass.arrCourseBatches[self.controller.currentIndex].endDate;
    product.course_start_date = dataClass.arrCourseBatches[self.controller.currentIndex].startDate;
    vc.product = product;
    [self.controller presentViewController:vc animated:true completion:nil];
    
}
#pragma mark- Other
-(void) handleCalenderTap:(NSDate *)date {
    if ([self dateChecker:date]) {
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sDate == %@",[globalDateFormatter() dateFromString:[globalDateFormatter() stringFromDate:date]]];
    NSArray *arr = [dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes filteredArrayUsingPredicate:predicate];
    for (TimeBatch *ii in dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes) {
        HCLog(@"%@",ii.batch_start_date);
    }
    __block TimeBatch *batch;
    if (arr.count>0) {
        batch = [arr firstObject];
        date = batch.batch_start_date;
    }
    TimeSelectionVC *vc = [self.controller.storyboard instantiateViewControllerWithIdentifier:@"TimeSelectionVC"];
    vc.selectedDate = date;
    vc.sessionEndDate = batch.batch_end_date;
    vc.endDate = [globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.controller.currentIndex].endDate];
    [vc getRefreshBlock:^(NSString *start, NSString *end, NSString *copy) {
        if (_isStringEmpty(start)) {
            [self refreshCalender];
            return;
        }
        NSDateFormatter *format = global12Formatter();
        NSDate *startDate = [format dateFromString:start];
        NSDate *endDate = [format dateFromString:end];
        NSString *compare = [globalDateFormatter() stringFromDate:date];
        NSLog(@"Compare : %@",compare);
        if (batch == nil) {
            batch = [[TimeBatch alloc] init];
            batch.sessionId = GetTimeStampString;
        }
        
        batch.batch_start_date = startDate;
        batch.batch_end_date = endDate;
        batch.sDate = [globalDateFormatter() dateFromString:compare];

        [ScheduleList insertOrUpdate:batch classRow:dataClass.arrCourseBatches[self.controller.currentIndex].batchID];
        
        if(dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes == nil){
            dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes = [NSMutableArray new];
        }
        [dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes addObject:batch];
        if (![self.controller checkStringValue:copy]) {
            [self copyBatchesupTo:copy timeBatch:batch];
        }
        [self refreshCalender];
    }];
    [vc deleteBlock:^(NSString *anyValue) {
        __block TimeBatch *batch;
        if (arr.count>0) {
            batch = [arr firstObject];
            ;
            [ScheduleList deleteSchedule:batch.sessionId];
            [dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes removeObject:batch];
            
        }
    }];
    if (is_iPad()) {
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.controller presentViewController:vc animated:true completion:nil];
//        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
//        [popover presentPopoverFromRect:self.calenderView.bounds inView:self.calenderView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }else{
        [self.controller presentViewController:vc animated:true completion:nil];
    }

}
-(BOOL) dateChecker:(NSDate*) date {
    
    if (dataClass.arrCourseBatches[self.controller.currentIndex].startDate == nil) {
        showAletViewWithMessage(@"Please select batch start date");
        return true;
    }
    if (dataClass.arrCourseBatches[self.controller.currentIndex].endDate == nil) {
        showAletViewWithMessage(@"We won’t keep you too long, please Select Class End date");
        return true;
    }
    if ([[globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.controller.currentIndex].startDate] compare:date] == NSOrderedDescending) {
        showAletViewWithMessage([NSString stringWithFormat:@"Before you go, please select a Class Date between Course Start (%@) and End Date (%@)",dataClass.arrCourseBatches[self.controller.currentIndex].startDate,dataClass.arrCourseBatches[self.controller.currentIndex].endDate]);
        return true;
    }
    if ([[globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.controller.currentIndex].endDate] compare:date] == NSOrderedAscending && [[globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.controller.currentIndex].endDate] compare:date] != NSOrderedSame ) {
        showAletViewWithMessage([NSString stringWithFormat:@"Before you go, please select a Class Date between Course Start (%@) and End Date (%@)",dataClass.arrCourseBatches[self.controller.currentIndex].startDate,dataClass.arrCourseBatches[self.controller.currentIndex].endDate]);
        return true;
    }
    return false;
}

-(void) copyBatchesupTo:(NSString*) untillDate timeBatch:(TimeBatch*) selectedObj{
    //Validation
    NSDate *lastDate = [globalDateOnlyFormatter() dateFromString:untillDate];
    NSDate *startDate = selectedObj.batch_start_date;
    
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitDay fromDate:startDate toDate:lastDate options:NSCalendarWrapComponents];
    int days = floor([components day]/7);
    NSDateFormatter *format = globalDateFormatter();
    NSDateFormatter *outformat = global24Formatter();
    NSMutableArray  *weekDays = [[NSMutableArray alloc] init];
    weekDays = [self getWeekDateFrom:selectedObj.batch_end_date];
    
    [self.controller startActivity];
    
    for (int i = 0; i < days; i++) { // For number of week
        for (int j = 0; j < 7 ; j++) { // 7 day of week
            
            NSDate *newEndDate = selectedObj.batch_end_date;
            NSDate *nextEndDate = [newEndDate dateByAddingTimeInterval:60*60*24*7];
            NSLog(@"%@",nextEndDate);
            
            NSDate *newStartDate = selectedObj.batch_start_date;
            NSDate *nextStartDate = [newStartDate dateByAddingTimeInterval:60*60*24*7];
            NSLog(@"%@",nextStartDate);
            NSString *compare =  [format stringFromDate:nextStartDate];
            if ([lastDate compare:nextEndDate] == NSOrderedDescending ) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sDate == %@",[format dateFromString:compare]];
                NSArray *arr = [dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes filteredArrayUsingPredicate:predicate];
                TimeBatch *batch;
                if (arr.count>0) {
                    batch = [arr firstObject];
                }else{
                    batch = [TimeBatch new];
                    batch.sessionId = GetTimeStampString;
                }
                
                batch.batch_start_date = nextStartDate;
                batch.batch_end_date = nextEndDate;
                batch.sDate = [format dateFromString:compare];;
                
                if (batch) {
                    [dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes addObject:batch];
                     [ScheduleList insertOrUpdate:batch classRow:dataClass.arrCourseBatches[self.controller.currentIndex].batchID];
                    selectedObj = batch;
                }
            }
        }
        NSDate *d = [weekDays lastObject];
        [weekDays removeAllObjects];
        weekDays = [self getWeekDateFrom:d];
    }
    [self.controller stopActivity];
    [self refreshCalender];
}

- (NSMutableArray*)getWeekDateFrom:(NSDate *)week {
    
    NSDate *date = [self nextDayFromDate:week];
    NSDateComponents *components;
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    [components2 setDay:1];
    
    NSMutableArray *_weekdays = [[NSMutableArray alloc] init];
    
    for (register unsigned int i=0; i < 7; i++) {
        [_weekdays addObject:date];
        components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
        [components setDay:1];
        date = [CURRENT_CALENDAR dateByAddingComponents:components2 toDate:date options:0];
    }
    return _weekdays;
}
- (NSDate *)nextDayFromDate:(NSDate *)date {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    [components setDay:[components day] + 1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

@end
