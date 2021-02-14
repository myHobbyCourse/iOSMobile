//
//  BatchCell.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 04/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "BatchCell.h"

@implementation BatchCell

//static int counter = 7 * 5;

- (NSArray *)weekView:(MAWeekView *)weekView eventsForDate:(NSDate *)startDate {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString1 = [format stringFromDate:startDate];
    
    NSMutableArray *events = [NSMutableArray array];
    NSArray * arr = [BatchTimeTable getobjectbyStartDate:dateString1 identifier:self.dataSet.courseBatchId];
    
    for (BatchTimeTable * obj in arr) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        
        MAEvent *event = [[MAEvent alloc] init];
        event.allDay =  NO;
        event.textColor = [UIColor whiteColor];
        event.backgroundColor = [[UIColor colorFromHexString:@"F52375"] colorWithAlphaComponent:0.7];
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
        
        event.title = [NSString stringWithFormat:@"%@ - %@",[format stringFromDate:dStart],[format stringFromDate:dEnd]];
        if (![obj.mStartTime isEqualToString:obj.mEndTime]) {
            [events addObject:event];
        }
        
        
    }
    return events;
}

/* Implementation for the MAWeekViewDelegate protocol */

- (void)weekView:(MAWeekView *)weekView eventTapped:(MAEvent *)event TapAtPoint:(CGPoint)tapPoint{
    
    TimePopUp  *vc =(TimePopUp*) [(!is_iPad())?getStoryBoardDeviceBased(StoryboardPop):self.controller.storyboard instantiateViewControllerWithIdentifier: @"TimePopUp"];
    vc.date = event.start;
    vc.startDate = event.start;
    vc.endDate = event.end;
    vc.uuid = self.dataSet.courseBatchId;
    vc.delegate = self.controller;
    vc.isDelete = true;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    if (is_iPad())
    {
        id openTo;
        for (id view in self.weekView.gridView.subviews) {
            if (![NSStringFromClass([view class])isEqualToString:@"MAEventView"]) {
                continue;
            }
            MAEventView *maEventView = (MAEventView*) view;
            if ([maEventView.event.start compare:event.start] != NSOrderedSame){
                continue;
            }
            openTo = view;
            break;
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:CGRectMake(tapPoint.x,tapPoint.y,1,1) inView:openTo permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }];
    }else{
        [self.controller presentViewController:vc animated:false completion:nil];
    }
    
    
    //    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
    //    NSString *eventInfo = [NSString stringWithFormat:@"Event tapped: %02i:%02i. Userinfo: %@", [components hour], [components minute], [event.userInfo objectForKey:@"test"]];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
    //                                                    message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
}
-(BOOL)weekView:(MAWeekView *)weekView eventDraggingEnabled:(MAEvent *)event
{
    [self.controller.scrollView setScrollEnabled:false];
    return true;
}
-(void)weekView:(MAWeekView *)weekView eventDraggedCancel:(MAEvent *)event {
    [self.controller.scrollView setScrollEnabled:true];
}
- (void)weekView:(MAWeekView *)weekView eventDragged:(MAEvent *)event {
    [self.controller.scrollView setScrollEnabled:true];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dValue = [event.userInfo objectForKey:@"test"];
    
    NSString *mCompare = [format stringFromDate:event.start]; // New compare date of event
    NSArray * arr = [BatchTimeTable getobjectbyStartDate:dValue identifier:self.dataSet.courseBatchId];
    if (arr && arr.count > 0) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [outputFormatter setTimeZone:timeZone];
        BatchTimeTable *obj;
        NSDate * dStart = event.userInfo[@"dStart"];
        NSString * checkDate = [outputFormatter stringFromDate:dStart];
        for (BatchTimeTable * entity in arr) {
            if ([checkDate isEqual:entity.mStartTime]) {
                obj = entity;
                break;
            }
        }
        if (obj == nil) {
            obj = arr[0];
        }
        NSDateFormatter *outputFormatter1 = [[NSDateFormatter alloc] init];
        [outputFormatter1 setDateFormat:@"yyyy-MM-dd hh:mm a"];
        NSString *sdateString = [outputFormatter1 stringFromDate:event.start];
        NSString *edateString = [outputFormatter1 stringFromDate:event.end];
        
        obj.mStartTime = sdateString;
        obj.mEndTime = edateString;
        obj.mCompareDate = mCompare;
        NSError *mocSaveError = nil;
        NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
        if (![moc save:&mocSaveError])
        {
            NSLog(@"Save did not complete successfully. Error: %@",
                  [mocSaveError localizedDescription]);
        }
        
    }
    [format setDateFormat:@"hh:mm a"];
    event.title = [NSString stringWithFormat:@"%@ - %@",[format stringFromDate:event.start],[format stringFromDate:event.end]];
    [self.weekView reloadData];
    
    /*NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
     NSString *eventInfo = [NSString stringWithFormat:@"Event dragged to %02i:%02i. Userinfo: %@", [components hour], [components minute], [event.userInfo objectForKey:@"test"]];
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
     message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];*/
}
- (void)weekView:(MAWeekView *)weekView gridTapped:(NSValue*) touches {
    
    if ([self checkStringValue:self.dataSet.coursestartDate]  || [self checkStringValue:self.dataSet.courseEndDate]) {
        showAletViewWithMessage(@"Don’t fear commitment, please enter Course Start and End Dates.");
        return;
    }
    
    CGPoint touch = [touches CGPointValue];
    const double posX = touch.x / self.weekView.gridView.cellWidth;
    const double posY = touch.y / self.weekView.gridView.cellHeight;
    
    // Current date
    int count = (int)floor(posX);
    NSDate *weekday;
    if (self.weekView.weekdayBarView.weekdays.count > count) {
        weekday = [self.weekView.weekdayBarView.weekdays objectAtIndex:count];
    }else{
        weekday = [self.weekView.weekdayBarView.weekdays lastObject];
    }
    double hours;
    double minutes;
    minutes = modf(posY, &hours) * 30;
    
    NSDateComponents *startComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:weekday];
    [startComponents setHour:(int)hours];
    [startComponents setMinute:minutes];
    [startComponents setSecond:0];
    
    NSDate *currentDate = [CURRENT_CALENDAR dateFromComponents:startComponents];
    NSLog(@"%@", currentDate);
    
    NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
    [format1 setDateFormat:@"dd-MMM-yyyy"];
    
    // validate date between give course dates
    NSDate *CSDate =  [format1 dateFromString:self.dataSet.coursestartDate];
    NSDate *CEDate =  [format1 dateFromString:self.dataSet.courseEndDate];
    
    if ([CSDate compare:currentDate] == NSOrderedDescending) {
        showAletViewWithMessage([NSString stringWithFormat:@"Before you go, please select a Class Date between Course Start (%@) and End Date (%@)",self.dataSet.coursestartDate,self.dataSet.courseEndDate]);
        return;
    }
    if ([CEDate compare:currentDate] == NSOrderedAscending && [CEDate compare:currentDate] != NSOrderedSame ) {
        showAletViewWithMessage([NSString stringWithFormat:@"Before you go, please select a Class Date between Course Start (%@) and End Date (%@)",self.dataSet.coursestartDate,self.dataSet.courseEndDate]);
        return;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSString *mCompare = [format stringFromDate:currentDate];
    NSDate *existingSDate,*existingEDate;
    NSArray * arr = [BatchTimeTable getobjectbyStartDate:mCompare identifier:self.dataSet.courseBatchId];
    if (arr && arr.count > 0) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [outputFormatter setTimeZone:timeZone];
        BatchTimeTable *obj = arr[0];
        existingSDate = [outputFormatter dateFromString:obj.mStartTime];
        existingEDate = [outputFormatter dateFromString:obj.mEndTime];
    }
    
    TimePopUp  *vc =(TimePopUp*) [(!is_iPad())?getStoryBoardDeviceBased(StoryboardPop):self.controller.storyboard instantiateViewControllerWithIdentifier: @"TimePopUp"];
    vc.date = currentDate;
    vc.uuid = self.dataSet.courseBatchId;
    vc.delegate = self.controller;
    if (existingEDate && existingSDate) {
        vc.startDate = existingSDate;
        vc.endDate = existingEDate;
        vc.isDelete = true;
    }
        vc.selectedEndDate = CEDate;
    
    
    if (is_iPad())
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:CGRectMake(touch.x,touch.y,1,1) inView:self.weekView.gridView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }];
    }else{
        [self.controller presentViewController:vc animated:false completion:nil];
    }
}
-(void)copyUntill:(NSString*)untillDate startDate:(NSString*) copyFromDate{
    
    //Validation
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd-MMM-yyyy"];
    
    NSDate *lastDate = [f dateFromString:untillDate];
    NSDate *startDate = [global12Formatter() dateFromString:copyFromDate];
    if (startDate == nil || copyFromDate == nil) {
        return;
    }
    
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitDay fromDate:startDate toDate:lastDate options:NSCalendarWrapComponents];
    int days = floor([components day]/7);
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray  *weekDays = [[NSMutableArray alloc] initWithArray:self.weekView.weekdayBarView.weekdays];
    
    NSDateFormatter *outformat = [[NSDateFormatter alloc]init];
    [outformat setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [self.controller startActivity];
    NSManagedObjectContext *moc = APPDELEGATE.managedObjectContext;
    BOOL isFail = false;
    NSArray * arr = [BatchTimeTable getobjectbyStartDate:[format stringFromDate:startDate] identifier:self.dataSet.courseBatchId];
    if (arr.count > 0) {
        BatchTimeTable  *obj = arr[0];
        for (int i = 0; i < days; i++) { // For number of week
            for (int j = 0; j < 7 ; j++) { // 7 day of week
                
                NSDate *newEndDate = [outformat dateFromString:obj.mEndTime];
                NSDate *nextEndDate = [newEndDate dateByAddingTimeInterval:60*60*24*7];
                NSLog(@"%@",nextEndDate);
                
                NSDate *newStartDate = [outformat dateFromString:obj.mStartTime];
                NSDate *nextStartDate = [newStartDate dateByAddingTimeInterval:60*60*24*7];
                NSLog(@"%@",nextStartDate);
                NSString *compare =  [format stringFromDate:nextStartDate];
                if ([lastDate compare:nextEndDate] == NSOrderedDescending ) {
                    
                    NSArray * objArr = [BatchTimeTable getobjectbyStartDate:compare identifier:self.dataSet.courseBatchId];
                    BatchTimeTable * newObj;
                    if (objArr == nil || objArr.count == 0) { // First time 1464506040397.090820
                        newObj = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"BatchTimeTable"
                                  inManagedObjectContext:moc];
                    }else {
                        newObj = [objArr firstObject];
                    }
                    
                    newObj.mStartTime = [outformat stringFromDate:nextStartDate];
                    newObj.mEndTime = [outformat stringFromDate:nextEndDate];
                    newObj.mCompareDate = compare;
                    newObj.mUid = obj.mUid;
                    NSError *mocSaveError = nil;
                    if (![moc save:&mocSaveError])
                    {
                        NSLog(@"Save did not complete successfully. Error: %@",
                              [mocSaveError localizedDescription]);
                        isFail = true;
                    }else{
                        isFail = false;
                    }
                        NSArray * arr = [BatchTimeTable getobjectbyStartDate:newObj.mCompareDate identifier:self.dataSet.courseBatchId];
                    if (arr.count > 0) {
                        obj = arr[0];
                    }
                }
            }
            NSDate *d = [weekDays lastObject];
            [weekDays removeAllObjects];
            weekDays = [self getWeekDateFrom:d];
        }
    }
    [self.controller stopActivity];
}
-(IBAction)btnCopyCalenderData:(UIButton*)sender {
    
    //Validation
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd-MMM-yyyy"];
    NSDate *startDate = [f dateFromString:self.dataSet.coursestartDate];
    NSDate *endDate = [f dateFromString:self.dataSet.courseEndDate];
    if ([startDate compare:endDate] == NSOrderedSame || [startDate compare:endDate] == NSOrderedDescending) {
        showAletViewWithMessage(@"Let’s clarify that class session with a valid session Startand End time.");
        return;
    }
    
    //Alert pop up
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAppName message:@"Please confirm the dates!! \n If you alter the course start and end dates later will delete it." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             
                             NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:NSCalendarWrapComponents];
                             int days = floor([components day]/7);
                             NSDateFormatter *format = [[NSDateFormatter alloc]init];
                             [format setDateFormat:@"yyyy-MM-dd"];
                             NSMutableArray  *weekDays = [[NSMutableArray alloc] initWithArray:self.weekView.weekdayBarView.weekdays];
                             
                             NSDateFormatter *outformat = [[NSDateFormatter alloc]init];
                             [outformat setDateFormat:@"yyyy-MM-dd hh:mm a"];
                             [self.controller startActivity];
                             NSManagedObjectContext *moc = APPDELEGATE.managedObjectContext;
                             BOOL isFail = false;
                             for (int i = 0; i < days; i++) { // For number of week
                                 for (int j = 0; j < 7 ; j++) { // 7 day of week
                                     NSString *mCompare = [format stringFromDate:weekDays[j]];
                                     NSArray * arr = [BatchTimeTable getobjectbyStartDate:mCompare identifier:self.dataSet.courseBatchId];
                                     if (arr && arr.count > 0) {
                                         for (BatchTimeTable *obj in arr) {
                                             
                                             NSDate *newEndDate = [outformat dateFromString:obj.mEndTime];
                                             NSDate *nextEndDate = [newEndDate dateByAddingTimeInterval:60*60*24*7];
                                             NSLog(@"%@",nextEndDate);
                                             
                                             NSDate *newStartDate = [outformat dateFromString:obj.mStartTime];
                                             NSDate *nextStartDate = [newStartDate dateByAddingTimeInterval:60*60*24*7];
                                             NSLog(@"%@",nextStartDate);
                                             NSString *compare =  [format stringFromDate:nextStartDate];
                                             if ([endDate compare:nextEndDate] == NSOrderedDescending ) {
                                                 
                                                 NSArray * objArr = [BatchTimeTable getobjectbyStartDate:compare identifier:self.dataSet.courseBatchId];
                                                 BatchTimeTable * newObj;
                                                 if (objArr == nil || objArr.count == 0) { // First time 1464506040397.090820
                                                     newObj = [NSEntityDescription
                                                               insertNewObjectForEntityForName:@"BatchTimeTable"
                                                               inManagedObjectContext:moc];
                                                 }else {
                                                     newObj = [objArr firstObject];
                                                 }
                                                 
                                                 newObj.mStartTime = [outformat stringFromDate:nextStartDate];
                                                 newObj.mEndTime = [outformat stringFromDate:nextEndDate];
                                                 newObj.mCompareDate = compare;
                                                 newObj.mUid = obj.mUid;
                                                 NSError *mocSaveError = nil;
                                                 if (![moc save:&mocSaveError])
                                                 {
                                                     NSLog(@"Save did not complete successfully. Error: %@",
                                                           [mocSaveError localizedDescription]);
                                                     isFail = true;
                                                 }else{
                                                     isFail = false;
                                                 }
                                             }
                                         }
                                     }
                                 }
                                 NSDate *d = [weekDays lastObject];
                                 [weekDays removeAllObjects];
                                 weekDays = [self getWeekDateFrom:d];
                             }
                             [self.controller stopActivity];
                             if (!isFail) {
                                 showAletViewWithMessage(@"Victory is yours! Session copied successfully");
                             }else{
                                 showAletViewWithMessage(@"Flying Frisbees…The Course failed to copy.");
                             }
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self.controller presentViewController:alertController animated:YES completion:nil];
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



-(void)setData:(CourseFrom *)courseFrom
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date = [dateFormatter dateFromString:courseFrom.coursestartDate];
    NSDate *date1 = [dateFormatter dateFromString:courseFrom.courseEndDate];
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
            NSInteger weekCount = ceil(components.day/7);
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
    self.weekView.batchId = self.dataSet.courseBatchId;
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
