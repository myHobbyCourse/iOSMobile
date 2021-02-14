//
//  CourseSummaryVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 01/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseSummaryVC.h"

@interface CourseSummaryVC (){
}

@end

@implementation CourseSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course summary Screen"];
}
-(IBAction)btnNext:(UIButton*)sender {
    if ([self checkStringValue:dataClass.crsSummary]) {
        showAletViewWithMessage(@"Enter Course Summary ");
        return;
    }else if (dataClass.crsSummary.length < 50){
        showAletViewWithMessage(@"Keep it snappy, but don’t get sappy. Course Introduction must be between 50 to 250 letters.");
        return;
    }
    [self.view endEditing:true];
    CourseLocationVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CourseLocationVC"];
    [self.navigationController pushViewController:vc animated:true];
  
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UIView *viewBorder = [cell viewWithTag:11];
    viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
    viewBorder.layer.borderWidth = 1.0;
    viewBorder.layer.cornerRadius = 8;
    UITextView *txtView = [cell viewWithTag:111];
    [self updateLable:txtView];
    UILabel *lblCaption = [cell viewWithTag:555];
    txtView.text = dataClass.crsSummary;
    if ([self checkStringValue:dataClass.crsSummary]) {
        lblCaption.hidden = false;
    }else{
        lblCaption.hidden = true;
    }
    return cell;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    UITableViewCell * cell  =[tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *lblCaption = [cell viewWithTag:555];
    lblCaption.hidden = true;

}
- (void)textViewDidEndEditing:(UITextView *)textView {
   
    [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[textView.text] feildName:FeildNameIntroduction];
    
    dataClass.crsSummary = textView.text;
    
    UITableViewCell * cell  = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *lblCaption = [cell viewWithTag:555];
    if ([self checkStringValue:dataClass.crsSummary]) {
        lblCaption.hidden = false;
    }else{
        lblCaption.hidden = true;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 111) {
        return [AppUtils txtLengthValidation:textView shouldChangeCharactersInRange:range replacementString:text length:1000];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    [self updateLable:textView];
}
-(void) updateLable:(UITextView*) txtView {
    UITableViewCell * cell  =[tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *lblCaption = [cell viewWithTag:112];
   
    NSInteger length = txtView.text.length;
    NSString* charCountStr = [NSString stringWithFormat:@"%li / 1000 charaters", (long)length];
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
