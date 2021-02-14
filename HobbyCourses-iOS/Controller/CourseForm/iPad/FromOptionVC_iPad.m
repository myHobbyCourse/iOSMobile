//
//  FromOptionVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromOptionVC_iPad.h"
#import "FormAddAmenitiesVC.h"
#import "FromYouTubeURLsVC.h"
#import "FormAddCertVC.h"
#import "FromCourseReqVC_iPad.h"

@interface FromOptionVC_iPad (){
    NSInteger selectedRow;
}

@end

@implementation FromOptionVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    selectedRow = 0;
    [self addShaowForiPad:viewLeft];
    viewLeft.backgroundColor = __Light_Gray;
    [self hideAllview];
    viewAmenities.hidden = false;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    NSDate *lastDate = [UserDefault valueForKey:@"isPhoneDone"];
    if (lastDate) {
        if ([lastDate compare:[NSDate date]] == NSOrderedAscending) {
            [UserDefault removeObjectForKey:@"isPhoneDone"];
        }
    }
    [self updateToGoogleAnalytics:@"iPad Step 8 Submit From Screen"];

}
-(void)viewDidDisappear:(BOOL)animated {
    [DefaultCenter postNotificationName:@"updateChecker" object:self];
}
-(void) hideAllview{
    viewYoutube.hidden = true;
    viewCertificates.hidden = true;
    viewAmenities.hidden = true;
    viewRequirements.hidden = true;
}
#pragma mark - UIButton
-(IBAction)btnSelectTutor:(UIButton*)sender {
    TutorListVC *vc = [[UIStoryboard storyboardWithName:@"Tutor" bundle:nil] instantiateViewControllerWithIdentifier:@"TutorListVC"];
    vc.isSelectTutor = true;
    [vc getRefreshBlock:^(id anyValue) {
        dataClass.crsTutor = anyValue;
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[anyValue] feildName:FeildNameTutor];
        [tblParent reloadData];
    }];
    vc.preferredContentSize = CGSizeMake(414, 600);
    vc.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:vc animated:YES completion:nil];
    [self configuraModalPopOver:sender controller:vc];
    
}
-(IBAction)btnNext:(UIButton*)sender {
    if ([UserDefault valueForKey:@"isPhoneDone"] == nil) {
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
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = (indexPath.row == 4) ? @"Cell1" :  @"Cell0";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UILabel *lblCaption = [cell viewWithTag:12];
    UIImageView *imgV = [cell viewWithTag:11];
    switch (indexPath.row) {
        case 0:{
            lblCaption.text = @"Amenities";
            imgV.image = [UIImage imageNamed:@"ic_f_amenities"];
        }   break;
        case 1:{
            lblCaption.text = @"Course Video";
            imgV.image = [UIImage imageNamed:@"ic_f_video"];
        }   break;
        case 2:{
            lblCaption.text = @"Your Certificates";
            imgV.image = [UIImage imageNamed:@"ic_f_certf"];
        }   break;
        case 3:{
            lblCaption.text = @"Course Requirements";
            imgV.image = [UIImage imageNamed:@"ic_f_req"];
        }   break;
        case 4:{
            imgV.image = [UIImage imageNamed:@"ic_s_tutors"];
            UITextField *tfTutor = [cell viewWithTag:333];
            tfTutor.text = dataClass.crsTutor;
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Enter Tutor Name" attributes:@{ NSForegroundColorAttributeName : __THEME_GRAY }];
            tfTutor.attributedPlaceholder = str;
        }   break;
           
        default:
            break;
    }
    if (selectedRow == indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:251.0/255.0 blue:250.0/255.0 alpha:1.0];
        lblCaption.textColor = __THEME_lightGreen;
    }else{
        cell.backgroundColor = [UIColor clearColor];
        lblCaption.textColor = __THEME_GRAY;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideAllview];
    switch (indexPath.row) {
        case 0:{
            viewAmenities.hidden = false;
            FormAddAmenitiesVC *vc = self.childViewControllers[0];
            [vc viewWillAppear:true];
        } break;
        case 1:{
            viewYoutube.hidden = false;
            FromYouTubeURLsVC *vc = self.childViewControllers[1];
            [vc viewWillAppear:true];
        }   break;
        case 2:{
            viewCertificates.hidden = false;
            FormAddCertVC *vc = self.childViewControllers[3];
            [vc viewWillAppear:true];
        }   break;
        case 3:
            viewRequirements.hidden = false;
            break;
        default:
            break;
    }
    selectedRow = indexPath.row;
    [tableView reloadData];
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
