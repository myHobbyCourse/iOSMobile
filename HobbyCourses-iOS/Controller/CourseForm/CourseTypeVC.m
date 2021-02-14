//
//  CourseTypeVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 18/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseTypeVC.h"

@interface CourseTypeVC ()

@end

@implementation CourseTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Step 1 from Screen"];
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
    
    if([self checkStringValue:dataClass.crsCancellation]){
        showAletViewWithMessage(@"Please select cancellation type");
        return;
    }
    
    CourseSummaryVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"CourseSummaryVC"];
    [self.navigationController pushViewController:vc animated:true];

    
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 1) {
        UIView *viewBorder = [cell viewWithTag:11];
        viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
        viewBorder.layer.borderWidth = 1.0;
        viewBorder.layer.cornerRadius = 8;
        
        UILabel *lblCate = [cell viewWithTag:12];
        UILabel *lblSub = [cell viewWithTag:13];
        UITextField *tfBatch = [cell viewWithTag:14];
        
        UIImageView *imgCate = [cell viewWithTag:21];
        UIImageView *imgSubCat= [cell viewWithTag:22];
//        ic_f_category
        if(dataClass.crsCategoryTbl != nil){
            lblCate.text = dataClass.crsCategoryTbl.categoryName;
            [imgCate sd_setImageWithURL:[NSURL URLWithString:dataClass.crsCategoryTbl.categoryImgUrl]];
        }else{
            lblCate.text = @"Category";
            imgCate.image = [UIImage imageNamed:@"ic_f_category"];
        }
        if(dataClass.crsSubCategoryTbl != nil){
            lblSub.text = dataClass.crsSubCategoryTbl.subCategoryName;
            [imgSubCat sd_setImageWithURL:[NSURL URLWithString:dataClass.crsSubCategoryTbl.subCategoryImgUrl]];
        }else{
            lblSub.text = @"Sub Category";
            imgSubCat.image = [UIImage imageNamed:@"ic_f_category"];
        }
        
        UITextField *tf = [cell viewWithTag:31];
        tf.text = dataClass.crsCancellation;

        tfBatch.text = dataClass.crsBatch;
    }else{
        UITextField *tf = [cell viewWithTag:15];
        tf.text = dataClass.crsTitle;
    }
    return cell;
}
#pragma mark - UIbuttom Method
-(IBAction)btnSelectValue:(UIButton*)sender {
    ValueSelectorVC  *vc =(ValueSelectorVC*) [getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"ValueSelectorVC"];
    switch (sender.tag) {
        case 51:
            vc.screenTitle = @"Select Category";
            vc.arrTittle = _arrCategoryC;
            vc.type = SelectionTypeCategory;
            
            break;
        case 52:
            vc.screenTitle = dataClass.crsCategoryTbl.categoryName;
            vc.arrTittle = [[CategoryTbl getCategorybyID:dataClass.crsCategoryTbl.categoryId].subcategorys allObjects];
            vc.type = SelectionTypeSubCateogy;
            break;
        case 53:{
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

            }];
            
        
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 54:{
            ValueSelectorVC  *vc =(ValueSelectorVC*) [getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"ValueSelectorVC"];
            vc.screenTitle = @"Select Cancellation Term";
            vc.arrTittle =  [[NSMutableArray alloc]initWithObjects:@"Open",@"Mild",@"Rigid",@"Firm", nil];
            [vc getRefreshBlock:^(NSString *anyValue) {
                dataClass.crsCancellation = anyValue;
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[anyValue] feildName:FeildNameCancellation];

                [tblParent reloadData];
            }];
            vc.type =  SelectionTypeCancellation;
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - UItextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 15) {
        dataClass.crsTitle = textField.text;
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[textField.text] feildName:FeildNameTitle];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
