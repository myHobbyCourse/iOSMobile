//
//  FromOptionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromOptionVC.h"

@interface FromOptionVC ()

@end

@implementation FromOptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    NSDate *lastDate = [UserDefault valueForKey:@"isPhoneDone"];
    if (lastDate) {
        if ([lastDate compare:[NSDate date]] == NSOrderedAscending) {
            [UserDefault removeObjectForKey:@"isPhoneDone"];
        }
    }
    [self updateToGoogleAnalytics:@"Step 8 Submit From Screen"];

}
-(void)viewDidDisappear:(BOOL)animated {
    [DefaultCenter postNotificationName:@"updateChecker" object:self];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - UIButton
-(IBAction)btnSelectTutor:(UIButton*)sender {
    TutorListVC *vc = [getStoryBoardDeviceBased(StoryboardTutor) instantiateViewControllerWithIdentifier:@"TutorListVC"];
    vc.isSelectTutor = true;
    [vc getRefreshBlock:^(id anyValue) {
        dataClass.crsTutor = anyValue;
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[anyValue] feildName:FeildNameTutor];
        [tblParent reloadData];
    }];
    [self.navigationController pushViewController:vc animated:true];
    
}
-(IBAction)btnNext:(UIButton*)sender {
    if (dataClass.crsAmenities.count == 0) {
        showAletViewWithMessage(@"Please select atleast one amenities");
        return;
    }
    if (_isStringEmpty(dataClass.crsTutor)) {
        showAletViewWithMessage(@"Please select tutor");
        return;
    }
    
    if ([UserDefault valueForKey:@"isPhoneDone"] != nil) {
        PhoneVerifyVC *vc = [getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"PhoneVerifyVC"];
        [vc getRefreshBlock:^(NSString *anyValue) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [UserDefault setObject:[NSDate dateWithTimeIntervalSinceNow:(60*60*24*7)] forKey:@"isPhoneDone"];
                ReadyToPublishCourseVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ReadyToPublishCourseVC"];
                [self.navigationController pushViewController:vc animated:true];
            });
        }];
        [self presentViewController:vc animated:true completion:nil];
    }else{
        ReadyToPublishCourseVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ReadyToPublishCourseVC"];
        [self.navigationController pushViewController:vc animated:true];
    }

}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 1) {
        UIView *viewBorder = [cell viewWithTag:11];
        viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
        viewBorder.layer.borderWidth = 1.0;
        viewBorder.layer.cornerRadius = 8;
        UITextField *tfTutor = [cell viewWithTag:333];
        tfTutor.text = dataClass.crsTutor;
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Enter Tutor Name" attributes:@{ NSForegroundColorAttributeName : __THEME_GRAY }];
        tfTutor.attributedPlaceholder = str;
    }else if (indexPath.row == 2){
        UIView *viewBorder = [cell viewWithTag:11];
        viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
        viewBorder.layer.borderWidth = 1.0;
        viewBorder.layer.cornerRadius = 8;

        UILabel *lblCaption = [cell viewWithTag:555];
        UITextView *txt = [cell viewWithTag:1];
        [self updateLable:txt];
        txt.text = dataClass.crsRequirements;
        if ([self checkStringValue:dataClass.crsRequirements]) {
            lblCaption.hidden = false;
        }else{
            lblCaption.hidden = true;
        }
    }
    return cell;
}
#pragma mark - UItextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    dataClass.crsTutor = textField.text;
    [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[textField.text] feildName:FeildNameTutor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.tag == 1) {
        UITableViewCell * cell  =[tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UILabel *lblCaption = [cell viewWithTag:555];
        lblCaption.hidden = true;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 1) {
        dataClass.crsRequirements = textView.text;
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[textView.text] feildName:FeildNameCourseReq];
        UITableViewCell * cell  = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UILabel *lblCaption = [cell viewWithTag:555];
        if ([self checkStringValue:dataClass.crsRequirements]) {
            lblCaption.hidden = false;
        }else{
            lblCaption.hidden = true;
        }
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if (textView.tag == 1) {
        return [AppUtils txtLengthValidation:textView shouldChangeCharactersInRange:range replacementString:text length:3500];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [self updateLable:textView];
}
-(void) updateLable:(UITextView*) txtView {
    UITableViewCell * cell  = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UILabel *lblCaption = [cell viewWithTag:112];
    
    NSInteger length = txtView.text.length;
    NSString* charCountStr = [NSString stringWithFormat:@"%li / 3500 charaters", (long)length];
    lblCaption.text = charCountStr;
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
