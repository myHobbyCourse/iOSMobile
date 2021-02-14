//
//  CourseDescVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 18/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseDescVC.h"
#import "UploadPicVC.h"

@interface CourseDescVC ()

@end

@implementation CourseDescVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Submit form course description Screen"];
}

-(IBAction)btnNext:(UIButton*)sender {
    if ([self checkStringValue:dataClass.crsShortDesc]) {
        showAletViewWithMessage(@"You must enter a Course Description , tell me more on your course");
        return;
    }else if (dataClass.crsShortDesc.length < 50){
        showAletViewWithMessage(@"Make it good, but keep it snappy. Course description must be between 50 to 1000 letters");
        return;
    }else if (![self checkStringValue:dataClass.crsRequirements] && dataClass.crsShortDesc.length < 50){
        showAletViewWithMessage(@"Make it snappy, but enough to keep us happy. Course description must be between 50 to 1000 letters");
        return;
    }
    UploadPicVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"UploadPicVC"];
    [self.navigationController pushViewController:vc animated:true];
    
   
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UIView *viewBorder = [cell viewWithTag:11];
        viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
        viewBorder.layer.borderWidth = 1.0;
        viewBorder.layer.cornerRadius = 8;
    UILabel *lblCaption = [cell viewWithTag:555];

    if(indexPath.row == 0){
        UITextView *txt = [cell viewWithTag:111];
        [self updateLable:txt];
        txt.text = dataClass.crsShortDesc;
        if ([self checkStringValue:dataClass.crsShortDesc]) {
            lblCaption.hidden = false;
        }else{
            lblCaption.hidden = true;
        }
    }
    return cell;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.tag == 111) {
        UITableViewCell * cell  = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *lblCaption = [cell viewWithTag:555];
        lblCaption.hidden = true;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 111) {
        dataClass.crsShortDesc = textView.text;
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[textView.text] feildName:FeildNameDescription];
        UITableViewCell * cell  = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *lblCaption = [cell viewWithTag:555];
        
        if ([self checkStringValue:dataClass.crsShortDesc]) {
            lblCaption.hidden = false;
        }else{
            lblCaption.hidden = true;
        }
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
