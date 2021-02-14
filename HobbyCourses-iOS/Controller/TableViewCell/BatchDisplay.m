//
//  BatchDisplay.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 25/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "BatchDisplay.h"

@implementation BatchDisplay

- (void)awakeFromNib {
    // Initialization code
    self.lblBatchCaption.layer.cornerRadius = 8;
    self.lblBatchMonth.layer.cornerRadius = 8;
    self.lblCurrentWeek.layer.cornerRadius = 8;
    
    
    self.lblCurrentWeek.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lblBatchMonth.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lblBatchCaption.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lblCurrentWeek.layer.borderWidth = 1.0;
    self.lblBatchMonth.layer.borderWidth = 1.0;
    self.lblBatchCaption.layer.borderWidth = 1.0;
    
    self.lblCurrentWeek.layer.masksToBounds = true;
    self.lblBatchMonth.layer.masksToBounds = true;
    self.lblBatchCaption.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)btnChangeWeekBatch:(UIButton*)sender {
    [self.weekView changeWeek:sender];
    if (![self checkStringValue:self.weekView.strBatchMonth]) {
        self.lblBatchMonth.text = self.weekView.strBatchMonth;
        self.lblCurrentWeek.text = self.weekView.strbatchStatus;
    }
    
}
- (NSArray *)weekView:(MAWeekView *)weekView eventsForDate:(NSDate *)startDate {
    
    NSMutableArray *events = [NSMutableArray array];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString1 = [format stringFromDate:startDate];
    
    NSArray * arr = [TempStore getobjectbyRowID:self.rowID compareDate:dateString1];
    
    for (TempStore * obj in arr) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        
        MAEvent *event = [[MAEvent alloc] init];
        event.allDay =  NO;
        event.textColor = [UIColor whiteColor];
        
        [format setDateFormat:@"yyyy-MM-dd hh:mm a"];
        NSDate *dStart = [format dateFromString:obj.mStartTime];
        NSDate *dEnd = [format dateFromString:obj.mEndTime];
        
        NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:dStart];
        NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:dEnd];
        
        event.start =  [CURRENT_CALENDAR dateFromComponents:components1];
        event.displayDate = event.start;
        event.end =   [CURRENT_CALENDAR dateFromComponents:components2];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setValue:obj.mCompareDate forKey:@"test"];
        [dict setValue:event.start forKey:@"dStart"];
        [dict setValue:event.end forKey:@"dEnd"];
        event.userInfo = dict;
        [format setDateFormat:@"hh:mm a"];
        
        event.backgroundColor = [UIColor colorFromHexString:getBatchColor(event.start)];
        
        event.title = [NSString stringWithFormat:@"%@ - %@",[format stringFromDate:dStart],[format stringFromDate:dEnd]];
        if (![obj.mStartTime isEqualToString:obj.mEndTime]) {
            [events addObject:event];
        }
    }
    return events;
}

/* Implementation for the MAWeekViewDelegate protocol */

- (void)weekView:(MAWeekView *)weekView eventTapped:(MAEvent *)event TapAtPoint:(CGPoint)tapPoint{
    
    //    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
    
    NSDate *dd = [globalDateFormatter() dateFromString:[event.userInfo objectForKey:@"test"]];
    NSString *eventInfo = [NSString stringWithFormat:@"%@ \n\n Session: %@ %@ \n %@",self.courseName,[dayNameFormatter() stringFromDate:dd],[globalDateOnlyFormatter() stringFromDate:dd],event.title];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:eventInfo
                                                    message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(BOOL)weekView:(MAWeekView *)weekView eventDraggingEnabled:(MAEvent *)event {
    return false;
}
-(void)weekView:(MAWeekView *)weekView eventDraggedCancel:(MAEvent *)event {
}
- (void)weekView:(MAWeekView *)weekView eventDragged:(MAEvent *)event {
}
- (void)weekView:(MAWeekView *)weekView gridTapped:(NSValue*) touches {
}
- (void)weekView:(MAWeekView *)weekView weekDidChange:(NSDate *)week{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (![self checkStringValue:self.weekView.strBatchMonth]) {
            self.lblBatchMonth.text = self.weekView.strBatchMonth;
            self.lblCurrentWeek.text = self.weekView.strbatchStatus;
        }
    });
    
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

-(void)setData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.courseStartDate];
    NSDate *date1 = [dateFormatter dateFromString:self.courseEndDate];
    self.weekView.courseStartDate = date;
    self.weekView.courseEndDate = date1;
    
    if(date) {
        [self.weekView setWeek:date];
        
        if (date1) {
            if (self.weekStartDates == nil) {
                self.weekStartDates = [[NSMutableArray alloc]init];
            }else{
                [self.weekStartDates removeAllObjects];
            }
            NSMutableArray *weekDays = [[NSMutableArray alloc]initWithArray:self.weekView.weekdayBarView.weekdays];
            NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitDay fromDate:date toDate:date1 options:NSCalendarWrapComponents];
            //            NSInteger weekCount = ceil(components.day/7);
            float  ff =  components.day/7.0f;
            NSInteger weekCount = ceil(ff);
            for (int i = 0; i < weekCount; i++) {
                [self.weekStartDates addObject:[weekDays firstObject]];
                NSDate *d = [weekDays lastObject];
                [weekDays removeAllObjects];
                weekDays = [self getWeekDateFrom:d];
            }
            weekDays = nil;
        }
        self.weekView.myDatesWeek = self.weekStartDates;
        [self.weekView setWeek:date];
    }
    self.lblBatchMonth.text = self.weekView.strBatchMonth;
    self.lblCurrentWeek.text = self.weekView.strbatchStatus;
    [self.weekView reloadData];
    
}

-(BOOL) checkStringValue:(NSString*) str
{
    if ([str isKindOfClass:[NSNull class]] || str == nil || [str isEqualToString:@""] || str.length == 0)
    {
        return true;
    }
    return false;
    
}


@end
