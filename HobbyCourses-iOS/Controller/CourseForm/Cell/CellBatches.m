//
//  CellBatches.m
//  HobbyCourses
//
//  Created by iOS Dev on 01/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CellBatches.h"

@implementation CellBatches
@synthesize tblBatches,controller;

-(void)awakeFromNib{
    [super awakeFromNib];
    tblBatches.estimatedRowHeight = 80;
    tblBatches.rowHeight = UITableViewAutomaticDimension;
    tblBatches.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        CellCalenderBatch * cell = [tableView dequeueReusableCellWithIdentifier:@"CellCalender" forIndexPath:indexPath];
        cell.controller = controller;
        [cell refreshCalender];
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *lblCaption = [cell viewWithTag:11];
        UILabel *lblValue = [cell viewWithTag:12];
        UIImageView *imgV = [cell viewWithTag:111];
        imgV.hidden = true;
        switch (indexPath.row) {
                
            case 0:
                lblCaption.text = @"Price";
                HCLog(@"Price %@",dataClass.arrCourseBatches[self.controller.currentIndex].price);
                if ([self.controller checkStringValue:dataClass.arrCourseBatches[self.controller.currentIndex].price]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = [DataClass getInstance].arrCourseBatches[self.controller.currentIndex].price;
                    imgV.hidden = false;
                }
                break;
            case 1:
                lblCaption.text = @"Start Date";
                if ([self.controller checkStringValue:dataClass.arrCourseBatches[self.controller.currentIndex].startDate]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = dataClass.arrCourseBatches[self.controller.currentIndex].startDate;
                    imgV.hidden = false;
                }
                break;
            case 2:
                lblCaption.text = @"End Date";
                if ([self.controller checkStringValue:dataClass.arrCourseBatches[self.controller.currentIndex].endDate]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = dataClass.arrCourseBatches[self.controller.currentIndex].endDate;
                    imgV.hidden = false;
                }
                break;
            case 3:
                lblCaption.text = @"Number of sessions";
                if ([self.controller checkStringValue:dataClass.arrCourseBatches[self.controller.currentIndex].sessions]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = dataClass.arrCourseBatches[self.controller.currentIndex].sessions;
                    imgV.hidden = false;
                }
                break;
            case 4:
                lblCaption.text = @"Class Size";
                if ([self.controller checkStringValue:dataClass.arrCourseBatches[self.controller.currentIndex].classSize]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = dataClass.arrCourseBatches[self.controller.currentIndex].classSize;
                    imgV.hidden = false;
                }
                break;
                
            default:
                break;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            FormPriceVC *vc = [getStoryBoardDeviceBased(StoryboardCourseFrom) instantiateViewControllerWithIdentifier:@"FormPriceVC"];
            vc.price = dataClass.arrCourseBatches[self.controller.currentIndex].price;
            vc.discount = dataClass.arrCourseBatches[self.controller.currentIndex].discount;
            [vc getRefreshBlock:^(NSString *anyValue) {
                NSArray *arr = [anyValue componentsSeparatedByString:@":"];
                dataClass.arrCourseBatches[self.controller.currentIndex].price = arr[0];
                dataClass.arrCourseBatches[self.controller.currentIndex].discount = arr[1];
                [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.controller.currentIndex].batchID objects:@[arr[0]] feildName:BatchPrice];
                [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.controller.currentIndex].batchID objects:@[arr[1]] feildName:BatchDiscount];
            }];
            [self.controller presentViewController:vc animated:true completion:nil];
        }
            break;
        case 1:{
            DateCalenderPickerVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"DateCalenderPickerVC"];
            vc.strTitle = @"Start Date";
            vc.isBeforeToday = YES;
            [vc getRefreshBlock:^(NSString *anyValue) {
                [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.controller.currentIndex].batchID objects:@[anyValue] feildName:BatchStart];
                dataClass.arrCourseBatches[self.controller.currentIndex].startDate = anyValue;
                [self.tblBatches reloadData];
            }];
            [self.controller presentViewController:vc animated:true completion:nil];
        }
            break;
        case 2:
        {
            if (_isStringEmpty(dataClass.arrCourseBatches[self.controller.currentIndex].startDate)) {
                showAletViewWithMessage(@"First things first, when would you like your class to start?");
                return;
            }
            
            ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"You can select your class within 6 months of start date." bgColor:__THEME_YELLOW button:@[@"OK"] controller:self.controller block:^(Tapped tapped, ActionAlert *alert) {
                if (tapped == TappedOkay) {
                    DateCalenderPickerVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"DateCalenderPickerVC"];
                    vc.strTitle = @"End Date";
                    vc.isBeforeToday = YES;
                    vc.endDate = [globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.controller.currentIndex].startDate];
                    [vc getRefreshBlock:^(NSString *anyValue) {
                        dataClass.arrCourseBatches[self.controller.currentIndex].endDate = anyValue;
                        [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.controller.currentIndex].batchID objects:@[anyValue] feildName:BatchEnd];

                        [self.tblBatches reloadData];
                    }];
                    [self.controller presentViewController:vc animated:true completion:nil];
                }
                [alert removeFromSuperview];
            }];
            [APPDELEGATE.window addSubview:alert];
        }
            break;
        case 3:{
            
            SessionSelectionVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"SessionSelectionVC"];
            vc.strTitle = @"Number of sessions";
            vc.setSessions = [NSString stringWithFormat:@"%d",(dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes.count > 0) ? (int)dataClass.arrCourseBatches[self.controller.currentIndex].batchesTimes.count : 1];
            [vc getRefreshBlock:^(NSString *anyValue) {
                dataClass.arrCourseBatches[self.controller.currentIndex].sessions = anyValue;
                [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.controller.currentIndex].batchID objects:@[anyValue] feildName:BatchSession];

            }];
            [self.controller presentViewController:vc animated:true completion:nil];
            
        }
            break;
        case 4:{
            SessionSelectionVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"SessionSelectionVC"];
            vc.strTitle = @"Class Size";
            [vc getRefreshBlock:^(NSString *anyValue) {
                 [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.controller.currentIndex].batchID objects:@[anyValue] feildName:BatchSize];
                dataClass.arrCourseBatches[self.controller.currentIndex].classSize = anyValue;
            }];
            [self.controller presentViewController:vc animated:true completion:nil];
        }
            break;
            
            
        default:
            break;
    }
    
}

@end
