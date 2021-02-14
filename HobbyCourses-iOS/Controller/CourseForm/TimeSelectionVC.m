//
//  TimeSelectionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 28/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TimeSelectionVC.h"

@interface TimeSelectionVC ()

@end

@implementation TimeSelectionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Start & End date picker Screen"];
}

-(void) updateUI{
    [pickerStart setValue:[UIColor blackColor] forKey:@"textColor"];
    pickerStart.subviews[0].subviews[1].backgroundColor = [UIColor clearColor];
    pickerStart.subviews[0].subviews[2].backgroundColor = [UIColor clearColor];
    viewPicker1.layer.cornerRadius = 10;
    viewPicker1.layer.masksToBounds = YES;
    lblRound1.layer.borderWidth = 1;
    lblRound1.layer.borderColor = __THEME_GRAY.CGColor;
    lblRound2.layer.borderWidth = 1;
    lblRound2.layer.borderColor = __THEME_GRAY.CGColor;
    lblRound2.layer.cornerRadius = 10;
    lblRound2.layer.masksToBounds = YES;
    lblRound1.layer.cornerRadius = 10;
    lblRound1.layer.masksToBounds = YES;
    
    [pickerEnd setValue:[UIColor blackColor] forKey:@"textColor"];
    pickerEnd.subviews[0].subviews[1].backgroundColor = [UIColor clearColor];
    pickerEnd.subviews[0].subviews[2].backgroundColor = [UIColor clearColor];
    viewPicker11.layer.cornerRadius = 10;
    viewPicker11.layer.masksToBounds = YES;
    lblRound11.layer.borderWidth = 1;
    lblRound11.layer.borderColor = __THEME_GRAY.CGColor;
    lblRound21.layer.borderWidth = 1;
    lblRound21.layer.borderColor = __THEME_GRAY.CGColor;
    lblRound21.layer.cornerRadius = 10;
    lblRound21.layer.masksToBounds = YES;
    lblRound11.layer.cornerRadius = 10;
    lblRound11.layer.masksToBounds = YES;
    
    NSMutableAttributedString *a1 = [AppUtils getAttributeString:@"Start " withFont:[UIFont systemFontOfSize:17] withColor:__THEME_lightGreen];
    NSMutableAttributedString *a2 = [AppUtils getAttributeString:@"Time" withFont:[UIFont systemFontOfSize:17] withColor:__THEME_GRAY];
    NSMutableAttributedString *aa = [[NSMutableAttributedString alloc] initWithAttributedString:a1];
    [aa appendAttributedString:a2];
    lblStart.attributedText = aa;
    
    NSMutableAttributedString *b1 = [AppUtils getAttributeString:@"End " withFont:[UIFont systemFontOfSize:17] withColor:__THEME_COLOR];
    NSMutableAttributedString *b2 = [AppUtils getAttributeString:@"Time" withFont:[UIFont systemFontOfSize:17] withColor:__THEME_GRAY];
    NSMutableAttributedString *bb = [[NSMutableAttributedString alloc] initWithAttributedString:b1];
    [bb appendAttributedString:b2];
    lblEnd.attributedText = bb;
    
    lblScreenTitle.text =  [NSString stringWithFormat:@"%@ %@",[globalDateOnlyFormatter() stringFromDate:_selectedDate],[dayNameFormatter() stringFromDate:_selectedDate]];
    pickerStart.date = _selectedDate;
    if (_sessionEndDate) {
        pickerEnd.date = _sessionEndDate;
    }else{
        pickerEnd.date = [_selectedDate dateByAddingTimeInterval:60*60];
    }

    [btnCopyTill setTitle:@"Select Date" forState:UIControlStateNormal];
 
    pickerEnd.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    pickerStart.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [self valueChabged:pickerStart];
    
}
#pragma mark- Button
-(IBAction)btnClearAction:(id)sender{
    [AppUtils actionWithMessage:kAppName withMessage:@"Do you want to delete a Daily session" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            _refreshBlock(@"");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
-(void)parentDismiss:(UIButton *)sender {
    self.timeSelectionBlock(@"",@"",@"");

    [self dismissViewControllerAnimated:false completion:nil];

}
-(IBAction)btnSaveTime:(UIButton*)sender {
    
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:pickerStart.date];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:pickerEnd.date];
    if (components1.hour > 20 || components1.hour < 7) {
        ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Please enter start time between 7am to 8pm" bgColor:__THEME_YELLOW button:@[@"OK"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
            [alert removeFromSuperview];
        }];
        [APPDELEGATE.window addSubview:alert];
        return;
    }
    if (components2.hour > 21 || components2.hour < 9) {
        ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Please enter end time before 8pm" bgColor:__THEME_YELLOW button:@[@"OK"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
            [alert removeFromSuperview];
        }];
        [APPDELEGATE.window addSubview:alert];
        return;
    }
    
    if ([pickerStart.date compare:pickerEnd.date] == NSOrderedDescending || [pickerStart.date compare:pickerEnd.date] == NSOrderedSame) {
        showAletViewWithMessage(@"Please enter valid time");
        return;
    }
    
    NSTimeInterval distanceBetweenDates = [pickerEnd.date timeIntervalSinceDate:pickerStart.date];
    
    NSInteger min = distanceBetweenDates / 60;
    if (min < 45) {
        showAletViewWithMessage(@"Please enter valid time duration min 45 minutes");
        return;
    }
    NSDateFormatter *outputFormatter = global12Formatter();
    NSString *start = [outputFormatter stringFromDate:pickerStart.date];
    NSString *end = [outputFormatter stringFromDate:pickerEnd.date];
    if ([btnCopyTill.titleLabel.text isEqualToString:@"Select Date"]) {
        self.timeSelectionBlock(start,end,@"");
    }else{
        self.timeSelectionBlock(start,end,btnCopyTill.titleLabel.text);
    }
    
    [self dismissViewControllerAnimated:false completion:nil];
}
-(void) getRefreshBlock:(TimeSelectionBlock)timeSelectionBlock {
    self.timeSelectionBlock = timeSelectionBlock;
}
-(void) deleteBlock:(RefreshBlock)deleteBlock {
    self.refreshBlock = deleteBlock;
}
-(IBAction)valueChabged:(UIDatePicker*)sender{
    if ([pickerStart.date compare:pickerEnd.date] == NSOrderedAscending) {
        NSTimeInterval seconds = [pickerEnd.date timeIntervalSinceDate:pickerStart.date];
        int days           = floor(seconds/24/60/60);
        int hoursLeft   = floor((seconds) - (days*86400));
        int hours           = floor(hoursLeft/3600);
        int minutesLeft = floor((hoursLeft) - (hours*3600));
        int minutes         = floor(minutesLeft/60);
        lblDuration.text = [NSString stringWithFormat:@"%d hour %d min",hours,minutes];
    }else{
        lblDuration.text = @"End time must bigger then start";
    }
}

#pragma mark-
-(IBAction)btnSelectDateForCopy:(UIButton*)sender{
    DateCalenderPickerVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"DateCalenderPickerVC"];
    vc.strTitle = @"Select Date";
    [vc getRefreshBlock:^(NSString *anyValue) {
        [self setDate:anyValue];
    }];
    if (is_iPad()) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        [popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }else{
        [self presentViewController:vc animated:true completion:nil];
    }
}
-(void) setDate:(NSString*) anyValue{
    if ([self.endDate compare:[globalDateOnlyFormatter() dateFromString:anyValue]] == NSOrderedAscending) {
        showAletViewWithMessage([NSString stringWithFormat:@"Please select date smaller then batch %@ end dates",[globalDateOnlyFormatter() stringFromDate:self.endDate]]);
    }else{
        [btnCopyTill setTitle:anyValue forState:UIControlStateNormal];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
