//
//  TimePopUp.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 12/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TimePopUp.h"

@interface TimePopUp ()<CalenderPickerDelegate>
{
    NSDateFormatter *format;
}
@end

@implementation TimePopUp

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *dateString1 = [globalDateOnlyFormatter() stringFromDate:self.date];
    self.lblDate.text = dateString1;
    self.preferredContentSize = CGSizeMake(400, 320);
    if (self.isDelete) {
        self.btnDelete.hidden = false;
        if (self.startDate) {
            self.datePicker1.date = self.startDate;
        }else{
            self.datePicker1.date = self.date;

        }
        if (self.endDate) {
            self.datePicker2.date = self.endDate;
        }else{
            self.datePicker2.date = self.date;

        }
    }else{
        self.btnDelete.hidden = true;
        self.widthDeleteButton.constant  = 0;
        self.datePicker1.date = self.date;
        self.datePicker2.date = [self.date dateByAddingTimeInterval:60*60];
    }
    self.datePicker1.minuteInterval = 15;
    self.datePicker2.minuteInterval = 15;
    tfCopy.text = [globalDateOnlyFormatter() stringFromDate:self.selectedEndDate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Calender picker Screen"];
}

-(IBAction)btnSelectDate:(UIButton*)sender
{
    DateCalenderPickerVC  *vc =(DateCalenderPickerVC*) [(!is_iPad())?getStoryBoardDeviceBased(StoryboardPop): self.storyboard instantiateViewControllerWithIdentifier: @"DateCalenderPickerVC"];
    vc.delegate = self;
    vc.selectTxt = 44;
    vc.setDate = self.selectedEndDate;
        if (is_iPad()) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:tfCopy.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }];
        
    }else{
        [self presentViewController:vc animated:true completion:nil];
    }
}
#pragma mark CalenderPicker Delegate
-(void)selectedCalenderDate:(NSString *)date index:(NSInteger)pos
{
    tfCopy.text = date;
}

-(IBAction)btnSaveTime:(UIButton*)sender {
    
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.datePicker1.date];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.datePicker2.date];
    if (components1.hour > 20 || components1.hour < 8 || components2.hour > 20 || components2.hour < 8) {
        showAletViewWithMessage(@"Please enter time between 8am to 8pm");
        return;
    }

    if ([self.datePicker1.date compare:self.datePicker2.date] == NSOrderedDescending || [self.datePicker1.date compare:self.datePicker2.date] == NSOrderedSame) {
        showAletViewWithMessage(@"Please enter valid time");
        return;
    }
    
    NSTimeInterval distanceBetweenDates = [self.datePicker2.date timeIntervalSinceDate:self.datePicker1.date];
    
    NSInteger min = distanceBetweenDates / 60;
    if (min < 45) {
        showAletViewWithMessage(@"Please enter valid time duration min 45 minutes");
        return;
    }    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"]; //24hr time format
    NSString *dateString = [outputFormatter stringFromDate:self.datePicker1.date];
    NSString *dateString1 = [outputFormatter stringFromDate:self.datePicker2.date];
    NSLog(@"%@ AND %@",dateString,dateString1);
    [self.delegate selectedDatesTime:dateString EndTime:dateString1 copy:tfCopy.text];
    [self dismissViewControllerAnimated:false completion:nil];
}
-(IBAction)btnDeleteCourseTime:(UIButton*)sender {
    if (![self checkStringValue:[globalDateFormatter() stringFromDate:self.date]]) {
        NSArray * arr = [BatchTimeTable getobjectbyStartDate:[globalDateFormatter() stringFromDate:self.date] identifier:self.uuid];
        if (arr.count > 0) {
            [APPDELEGATE.managedObjectContext deleteObject:arr[0]];
            [APPDELEGATE saveContext];
            [self.delegate reloadBatchesAfterDelete];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}
-(IBAction)btnClosePopUp:(UIButton*)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
