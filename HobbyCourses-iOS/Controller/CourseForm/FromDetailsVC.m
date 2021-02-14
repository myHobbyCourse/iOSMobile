//
//  FromDetailsVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 19/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromDetailsVC.h"

@interface FromDetailsVC (){
    NSString *places;
}

@end

@implementation FromDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"From details Screen"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tblParent reloadData];
}
-(IBAction)btnPlace:(UIButton*)sender {
    if (dataClass.crsStock.intValue > 50 || [dataClass.crsBatch isEqualToString:@"1"]) {
        return;
    }
    if (sender.tag == 51) {
        dataClass.crsStock = [NSString stringWithFormat:@"%d",dataClass.crsStock.intValue + 1];
    }else if (dataClass.crsStock.intValue != 1) {
        dataClass.crsStock = [NSString stringWithFormat:@"%d",dataClass.crsStock.intValue - 1];
    }
    [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsStock] feildName:FeildNamePlaceA];
    
    [tblParent reloadData];}
-(IBAction)valueChangedSwitch:(UISwitch*)sender{
    if (sender.tag == 31) {
        dataClass.isMoneyBack = (sender.on) ? @"1" : @"0";
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.isMoneyBack] feildName:FeildNameIsMoney];
    }else{
        dataClass.isTrail = (sender.on) ? @"1" : @"0";
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.isTrail] feildName:FeildNameIsTrial];
    }
}
-(IBAction)btnNext:(UIButton*)sender {
    if([self checkStringValue:dataClass.crsAgeGroup]){
        showAletViewWithMessage(@"Please select age group");
        return;
    }
    CourseDescVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CourseDescVC"];
    [self.navigationController pushViewController:vc animated:true];

}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (is_iPad()) ? 3 : 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 1) {
        UIView *viewBorder = [cell viewWithTag:11];
        viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
        viewBorder.layer.borderWidth = 1.0;
        viewBorder.layer.cornerRadius = 8;
        UILabel * lblCount = [cell viewWithTag:111];
        lblCount.text = (dataClass.crsStock) ? dataClass.crsStock : @"1";
        lblCount.layer.cornerRadius = 3;
        lblCount.layer.borderColor = __THEME_GRAY.CGColor;
        lblCount.layer.borderWidth = 1.0;
        
        UISwitch *sw1 = [cell viewWithTag:31];
        UISwitch *sw2 = [cell viewWithTag:32];
        sw1.on = ([dataClass.isMoneyBack isEqualToString:@"1"]) ? true : false;
        sw2.on = ([dataClass.isTrail isEqualToString:@"1"]) ? true : false;
    }else if(indexPath.row == 0){
        UITextField *tf = [cell viewWithTag:11];
        tf.text = dataClass.crsAgeGroup;
    }else{
        UITextField *tf = [cell viewWithTag:11];
        tf.text = dataClass.crsCancellation;
    }
    if(indexPath.row == 2) {
        UISwitch *sw1 = [cell viewWithTag:31];
        UISwitch *sw2 = [cell viewWithTag:32];
        sw1.on = ([dataClass.isMoneyBack isEqualToString:@"1"]) ? true : false;
        sw2.on = ([dataClass.isTrail isEqualToString:@"1"]) ? true : false;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AgeSelectionVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"AgeSelectionVC"];
        Search *search = [Search new];
        vc.searchObj = search;
        [vc refreshBlock:^(NSString *anyValue) {
            dataClass.crsAgeGroup = anyValue;
            dataClass.crsAgeGroupIndex = [search.arrAgeValue indexOfObject:anyValue];
            
            NSNumber *num = [NSNumber numberWithInteger:((dataClass.crsAgeGroupIndex > 9) ? 0 : dataClass.crsAgeGroupIndex)];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[num,anyValue] feildName:FeildNameAgeGp];
            [tblParent reloadData];
        }];
        if (is_iPad()) {
            UITableViewCell *sender = [tblParent cellForRowAtIndexPath:indexPath];
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
            [popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        }else{
            [self presentViewController:vc animated:YES completion:nil];
        }
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
