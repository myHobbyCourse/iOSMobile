//
//  SelectCategorySubPopVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SelectCategorySubPopVC_iPad.h"

@interface SelectCategorySubPopVC_iPad (){
    NSInteger selectedRow;
}

@end

@implementation SelectCategorySubPopVC_iPad
@synthesize arrTittle;
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedRow = -1;
    self.lblTitle.text = self.screenTitle;
    
    self.viewBG.layer.shadowRadius  = 10.0f;
    self.viewBG.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.viewBG.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.viewBG.layer.shadowOpacity = 0.9f;
    self.viewBG.layer.masksToBounds = NO;
    self.viewBG.layer.cornerRadius = 20;
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.viewBG.bounds, shadowInsets)];
    self.viewBG.layer.shadowPath    = shadowPath.CGPath;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Category subcategory Screen"];
}
#pragma mark - UICollection View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrTittle.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/2,65);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:91];
    UILabel *lbl = [cell viewWithTag:92];
    UIView *viewBorder = [cell viewWithTag:93];
    
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
    }
    [viewBorder layoutIfNeeded];
    viewBorder.layer.cornerRadius = viewBorder.frame.size.height/2;
    if (indexPath.row == selectedRow) {
        viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
        viewBorder.layer.borderWidth = 1.0;
    }else{
        viewBorder.layer.borderColor = [UIColor clearColor].CGColor;
        viewBorder.layer.borderWidth = 0.0;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [collectionView reloadData];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}

-(IBAction)btnSave:(id)sender{
    if (selectedRow != -1) {
        switch (self.type) {
            case SelectionTypeCategory: {
                CategoryEntity *obj = arrTittle[selectedRow];
                dataClass.crsSubCategoryTbl = nil;
                dataClass.crsCategory = obj;
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[obj.tid] feildName:FeildNameCategory];
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[@""] feildName:FeildNameSubCategory];
                [dataClass setCourseFromData:dataClass.rowID];
                dataClass.crsSubCategoryTbl = nil;
                if (is_iPad())
                    _refreshBlock(obj.category);
                
                
            }
                break;
            case SelectionTypeSubCateogy: {
                SubCategoryTbl *obj = arrTittle[selectedRow];
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[obj.subCategoryId] feildName:FeildNameSubCategory];
                dataClass.crsSubCategoryTbl = obj;
                [dataClass setCourseFromData:dataClass.rowID];
                if (is_iPad())
                    _refreshBlock(obj.subCategoryName);
            }
                break;
            default:
                break;
        }
    }
    
    [self parentDismiss:nil];
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
