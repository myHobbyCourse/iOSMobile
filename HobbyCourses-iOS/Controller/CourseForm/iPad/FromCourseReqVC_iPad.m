//
//  FromCourseReqVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 09/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromCourseReqVC_iPad.h"

@interface FromCourseReqVC_iPad ()

@end

@implementation FromCourseReqVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course requirement Screen"];
}

#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UIView *viewBorder = [cell viewWithTag:11];
    viewBorder.layer.borderColor = [UIColor whiteColor].CGColor;
    viewBorder.layer.borderWidth = 1.0;
    viewBorder.layer.cornerRadius = 8;
    UILabel *lblCaption = [cell viewWithTag:555];
    
    if(indexPath.row == 0){
        UITextView *txt = [cell viewWithTag:111];
        txt.text = dataClass.crsRequirements;
        if ([self checkStringValue:dataClass.crsRequirements]) {
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
        dataClass.crsRequirements = textView.text;
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsRequirements] feildName:FeildNameCourseReq];
        UITableViewCell * cell  = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *lblCaption = [cell viewWithTag:555];
        if ([self checkStringValue:dataClass.crsRequirements]) {
            lblCaption.hidden = false;
        }else{
            lblCaption.hidden = true;
        }
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 111) {
        return [AppUtils stringOnlyValidation:textView shouldChangeCharactersInRange:range replacementString:text length:3500 withSpace:YES];
    }
    
    return YES;
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
