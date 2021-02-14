//
//  CourseTypeVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseTypeVC_iPad.h"

@interface CourseTypeVC_iPad ()

@end

@implementation CourseTypeVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad step 1 from Screen"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tblParent reloadData];
}
-(IBAction)btnNext:(UIButton*)sender {
    if([self checkStringValue:dataClass.crsTitle]){
        showAletViewWithMessage(@"Enter Course Title");
        return;
    }
    if(dataClass.crsCategoryTbl == nil){
        showAletViewWithMessage(@"Let’s make some sense of this…Select Course Category");
        return;
    }
    if(dataClass.crsSubCategoryTbl == nil){
        showAletViewWithMessage(@"Flying fish or fishing flies? Please select a Sub-Category for your Course");
        return;
    }
    if([self checkStringValue:dataClass.crsBatch]){
        showAletViewWithMessage(@"How many eggs are in your carton? Please select number of learners in a Class");
        return;
    }
    
    CourseSummaryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CourseSummaryVC"];
    [self.navigationController pushViewController:vc animated:true];
    
    
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = (indexPath.row == 0) ? @"Cell0" : @"Cell1";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UILabel *lblCaption = [cell viewWithTag:12];
    UIImageView *imgV = [cell viewWithTag:21];

    switch (indexPath.row) {
        case 0:{
            UITextField *tf = [cell viewWithTag:15];
            UIView *viewBorder = [cell viewWithTag:12];
            viewBorder.layer.borderWidth = 1;
            viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
            tf.text = dataClass.crsTitle;
        }   break;
        case 1:{
            if(dataClass.crsCategoryTbl != nil){
                lblCaption.text = dataClass.crsCategoryTbl.categoryName;
                [imgV sd_setImageWithURL:[NSURL URLWithString:dataClass.crsCategoryTbl.categoryImgUrl]];
            }else{
                lblCaption.text = @"Category";
                imgV.image = [UIImage imageNamed:@"ic_f_category"];
            }
        }   break;
        case 2:{
            if(dataClass.crsSubCategoryTbl != nil){
                lblCaption.text = dataClass.crsSubCategoryTbl.subCategoryName;
                [imgV sd_setImageWithURL:[NSURL URLWithString:dataClass.crsSubCategoryTbl.subCategoryImgUrl]];
            }else{
                lblCaption.text = @"Sub Category";
                imgV.image = [UIImage imageNamed:@"ic_f_category"];
            }
        }   break;
        case 3:{
            if (_isStringEmpty(dataClass.crsBatch)) {
                lblCaption.text = @"Batch Size";
            }else{
                lblCaption.text = dataClass.crsBatch;
            }
            imgV.image = [UIImage imageNamed:@"ic_f_stud_no"];

        }   break;
        case 4:{
            if (_isStringEmpty(dataClass.crsCancellation)) {
                lblCaption.text = @"Cancellation Term";
            }else{
                lblCaption.text = dataClass.crsCancellation;
            }
            imgV.image = [UIImage imageNamed:@"ic_f_cancellation"];

        }
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tblParent cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 1:{
            SelectCategorySubPopVC_iPad  *vc =(SelectCategorySubPopVC_iPad*) [getStoryBoardDeviceBased(StoryboardPop) instantiateViewControllerWithIdentifier: @"SelectCategorySubPopVC_iPad"];
            //vc.screenTitle = @"Select Category";
            vc.arrTittle = _arrCategoryC;
            vc.screenTitle = @"SELECT CATEGORY";
            vc.type = SelectionTypeCategory;
            [vc getRefreshBlock:^(NSString *anyValue) {
                [tblParent reloadData];
            }];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 2:{
            SelectCategorySubPopVC_iPad  *vc =(SelectCategorySubPopVC_iPad*) [getStoryBoardDeviceBased(StoryboardPop) instantiateViewControllerWithIdentifier: @"SelectCategorySubPopVC_iPad"];

            vc.screenTitle = dataClass.crsCategory.category;
            vc.arrTittle = [[CategoryTbl getCategorybyID:dataClass.crsCategoryTbl.categoryId].subcategorys allObjects];
            vc.type = SelectionTypeSubCateogy;
            [vc getRefreshBlock:^(NSString *anyValue) {
                [tblParent reloadData];
            }];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:nil];

        }
            
            break;
        case 3:{
            ClassSelectionVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier: @"ClassSelectionVC"];
            vc.searchObj = [Search new];
            [vc getRefreshBlock:^(NSString *anyValue) {
                if ([anyValue isEqualToString:@"1-to-1"]) {
                    dataClass.crsBatch = @"1";
                }else if ([anyValue isEqualToString:@"2 - 5"]) {
                    dataClass.crsBatch = @"5";
                }else if ([anyValue isEqualToString:@"5 - 10"]) {
                    dataClass.crsBatch = @"10";
                }else if ([anyValue isEqualToString:@"10 - 20"]) {
                    dataClass.crsBatch = @"20";
                }else{
                    dataClass.crsBatch = @"100";
                }
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsBatch] feildName:FeildNameBatchSize];
                [tblParent reloadData];
            }];
            [self present:cell control:vc];
        }
            break;
        case 4:{
            ValueSelectorVC  *vc =(ValueSelectorVC*) [getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"ValueSelectorVC"];
            vc.screenTitle = @"Select Cancellation Term";
            vc.arrTittle =  [[NSMutableArray alloc]initWithObjects:@"Open",@"Mild",@"Rigid",@"Firm", nil];
            [vc getRefreshBlock:^(NSString *anyValue) {
                dataClass.crsCancellation = anyValue;
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[anyValue] feildName:FeildNameCancellation];
                [tblParent reloadData];
            }];
            vc.type =  SelectionTypeCancellation;
            [self present:cell control:vc];
        }
            break;
        default:
            break;
    }
    
}
-(void) present:(UIView*) sender control:(UIViewController*) vc{
    if (is_iPad()) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        [popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }else{
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark - UItextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 15) {
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[textField.text] feildName:FeildNameTitle];
        dataClass.crsTitle = textField.text;
    }else{
        dataClass.crsBatch = textField.text;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 15) {
        return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:60 withSpace:YES];
    }
    return YES;
}



@end
