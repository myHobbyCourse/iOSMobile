//
//  ValueSelectorVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 22/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ValueSelectorVC.h"

@interface ValueSelectorVC ()
{
    NSString *selectedValue;
    NSInteger selectedIndexPath;
}
@end

@implementation ValueSelectorVC
@synthesize arrTittle;

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndexPath = -1;
    lblScreenTitle.text = _screenTitle;
    tblParent.estimatedRowHeight = 70;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
    if (self.type == SelectionTypeSubCateogy) {
        lblScreenTitle.textColor = __THEME_lightGreen;
    }
}

-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
-(IBAction)btnSave:(UIButton*)sender {
    if (selectedIndexPath == -1) {
        return;
    }
    
    switch (self.type) {
        case SelectionTypeCategory: {
            CategoryEntity *obj = arrTittle[selectedIndexPath];
            dataClass.crsSubCategoryEntity = nil;
            dataClass.crsCategory = obj;
            dataClass.crsSubCategoryEntity = nil;
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[obj.tid] feildName:FeildNameCategory];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[@""] feildName:FeildNameSubCategory];
            [dataClass setCourseFromData:dataClass.rowID];
            if (is_iPad())
                _refreshBlock(@"");
                
            
        }
            break;
        case SelectionTypeSubCateogy: {
            SubCategoryTbl *obj = arrTittle[selectedIndexPath];
            dataClass.crsSubCategoryEntity = obj;
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[obj.subCategoryId] feildName:FeildNameSubCategory];
            [dataClass setCourseFromData:dataClass.rowID];
            if (is_iPad())
                _refreshBlock(@"");
        }
            break;
        case SelectionTypeVenue:{
            if ([arrTittle[selectedIndexPath] isEqualToString:selectedValue]) {
                selectedValue = @"";
                _refreshBlock(@"-1");
                
            }else{
                selectedValue = arrTittle[selectedIndexPath];
                _refreshBlock([NSString stringWithFormat:@"%ld",(long)selectedIndexPath]);
                [self btnBackNav:nil];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    if (_refreshBlock && self.type != SelectionTypeVenue)
        _refreshBlock(selectedValue);
    
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrTittle.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lbl = [cell viewWithTag:12];
    UIButton *btn = [cell viewWithTag:13];
    UIImageView *imgV = [cell viewWithTag:11];
    UIButton *btnInfo = [cell viewWithTag:22];
    cell.backgroundColor = [UIColor clearColor];
    btnInfo.hidden = YES;
    switch (self.type) {
        case SelectionTypeCategory:
        {
            CategoryEntity *obj = arrTittle[indexPath.row];
            lbl.text = obj.category;
            [imgV sd_setImageWithURL:[NSURL URLWithString:obj.image]];
        }
            break;
        case SelectionTypeSubCateogy:
        {
            SubCategoryTbl *obj = arrTittle[indexPath.row];
            lbl.text = obj.subCategoryName;
            [imgV sd_setImageWithURL:[NSURL URLWithString:obj.subCategoryImgUrl]];
        }
            break;
        case SelectionTypeCancellation:{
            btnInfo.hidden = false;
            lbl.text = arrTittle[indexPath.row];
        }break;
            
        case SelectionTypeNone:
        case SelectionTypeVenue:
        {
            lbl.text = arrTittle[indexPath.row];
        }
            break;
        default:
            break;
    }
    btn.hidden = YES;
    if ([lbl.text isEqualToString:selectedValue]) {
        lbl.textColor = [UIColor blackColor];
    }else{
        lbl.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndexPath == indexPath.row){
        selectedIndexPath = -1;
    }else{
        selectedIndexPath = indexPath.row;
    }
    switch (self.type) {
        case SelectionTypeCategory:
        {
            CategoryEntity *obj = arrTittle[indexPath.row];
            if ([obj.category isEqualToString:selectedValue]) {
                selectedValue = @"";
            }else{
                selectedValue = obj.category;
            }
        }
            break;
        case SelectionTypeSubCateogy:
        {
            SubCategoryTbl *obj = arrTittle[indexPath.row];
            if ([obj.subCategoryName isEqualToString:selectedValue]) {
                selectedValue = @"";
                
            }else{
                selectedValue = obj.subCategoryName;
            }
        }
            break;
            
        case SelectionTypeNone:
        case SelectionTypeCancellation:
        case SelectionTypeVenue:{
            if ([arrTittle[indexPath.row] isEqualToString:selectedValue]) {
                selectedValue = @"";
            }else{
                selectedValue = arrTittle[indexPath.row];
            }
        }
            break;
            
        default:
            break;
    }
    
    [tblParent reloadData];
    
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
