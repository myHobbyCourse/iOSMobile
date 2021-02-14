//
//  PopUpViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 26/04/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()
{
    IBOutlet UIButton *btnClose;
    IBOutlet UILabel *lblTittle;
    IBOutlet UITableView *tbl;
    NSMutableArray *arrData,*arrCategory;
    NSString *strSelectedValue;
    NSIndexPath *selIndex;
    IBOutlet NSLayoutConstraint *widthConstraints;
}
@end

@implementation PopUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc]init];
    arrCategory = [[NSMutableArray alloc]init];
    NSData *data = [UserDefault objectForKey:kCategoryKey];
    if (data)
    {
        NSArray *arrCat = [NSKeyedUnarchiver unarchiveObjectWithData:data];    for (NSDictionary *dict in arrCat)
        {
            CategoryEntity *entity = [[CategoryEntity alloc]initWithDictionary:dict];
            [arrCategory addObject:entity];
        }
    }
    [arrData removeAllObjects];

}
-(void)viewWillAppear:(BOOL)animated
{
    widthConstraints.constant = self.frame;
    if (self.isTypeCat)
    {
        lblTittle.text = @"Category";
        for (CategoryEntity *entity in arrCategory)
        {
            [arrData addObject:entity.category];
        }
    }else
    {
        lblTittle.text = @"SubCategory";
        CategoryEntity *catEntity = [arrCategory objectAtIndex:self.selectedCatIndex.row];
        for (SubCategoryEntity *entity in catEntity.subCategories)
        {
            [arrData addObject:entity.subCategory];
        }
    }
    [tbl reloadData];
}
#pragma mark
-(IBAction)btnClose:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - UITableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (is_iPad()) {
        return 50;
    }
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.lblCity.text = arrData[indexPath.row];
    
    if (strSelectedValue == arrData[indexPath.row])
    {
        cell.btnSelection.selected = true;
        
    }else
    {
        cell.btnSelection.selected = false;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    strSelectedValue = arrData[indexPath.row];
    selIndex = indexPath;
    [tbl reloadData];
}
-(void)btnAppyCity:(id)sender
{
    if (self.isTypeCat)
    {
        if ([self checkStringValue:strSelectedValue])
        {
            showAletViewWithMessage(@"Please select category.");
            return;
        }
        [self.delegate selectedValue:strSelectedValue selectedCatIndex:selIndex type:true];
        
    }else
    {
        [self.delegate selectedValue:strSelectedValue selectedCatIndex:selIndex type:false];

    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
