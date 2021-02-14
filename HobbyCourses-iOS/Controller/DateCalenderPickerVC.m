//
//  DateCalenderPickerVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 18/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "DateCalenderPickerVC.h"

@interface DateCalenderPickerVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
{
    NSDateFormatter *format;
}
@end

@implementation DateCalenderPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(400, 400);
    self.calenderView.layer.cornerRadius = 5;
    self.calenderView.layer.masksToBounds = true;
    self.calenderView.dataSource = self;
    self.calenderView.delegate = self;
    
    format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"dd-MMM-yyyy"];
    if (self.setDate) {
        [self.calenderView selectDate:self.setDate];
    }
    [self.calenderView reloadData];
  
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    screenTitle.text = _strTitle;
    [self updateToGoogleAnalytics:@"Calender Date Picker Screen"];

}

#pragma mark - FSCalenderDelegate
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date {
    if (self.endDate) { //Batch end date validation setDate == Start Date
        NSDate * validDate =[NSDate dateWithTimeInterval:(24*60*60*180) sinceDate:self.endDate];
        if ([date compare:self.endDate] == NSOrderedAscending) {
            return false;
        }else  if ([date compare:validDate] == NSOrderedDescending){
            return false;
        }
    }else{
        if ([date compare:[NSDate dateWithTimeIntervalSinceNow:(24*60*60*2)]] == NSOrderedAscending && self.isBeforeToday) {
            ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Please select a Class starting after 48 hours from now. This is done to avoid fraud" bgColor:__THEME_YELLOW button:@[@"OK"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
                [alert removeFromSuperview];
            }];
            [APPDELEGATE.window addSubview:alert];
            return false;
        }else if ([date compare:[NSDate dateWithTimeIntervalSinceNow:(24*60*60*90)]] == NSOrderedDescending && self.isBeforeToday){
            ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Please select a Class starting before 3 months from now. This is done to avoid fraud" bgColor:__THEME_YELLOW button:@[@"OK"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
                [alert removeFromSuperview];
            }];
            [APPDELEGATE.window addSubview:alert];

            return false;
        }
    }
    return true;
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    [self.calenderView selectDate:date];
    self.setDate = date;
}

-(IBAction)btnSave:(id)sender {
    NSString *dateString1 = [format stringFromDate:self.setDate];
    if (_isStringEmpty(dateString1)) {
        showAletViewWithMessage(@"Please select start date first");
        return;
    }
    if (_refreshBlock) {
        _refreshBlock(dateString1);
    }
    
    [self.delegate selectedCalenderDate:dateString1 index:self.selectTxt];
    [self dismissViewControllerAnimated:false completion:nil];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
@end
