//
//  SalesStatVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SalesStatVC_iPad.h"

@interface SalesStatVC_iPad ()
{
    NSMutableArray *arrData,*arrDataCopy;
    NSInteger selectedRow;
    NSString *tempSortBy;
    NSArray *arrFilter;
    int pageIndex;
    
    IBOutlet UIView *viewShadow;
    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
    
}
@end

@implementation SalesStatVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc]init];
    arrDataCopy = [[NSMutableArray alloc]init];
    [self performSelector:@selector(getUserSales) withObject:self afterDelay:0.5];
    selectedRow = 0;
    pageIndex = 0;
    arrData = [[NSMutableArray alloc]init];
    arrFilter = [[NSArray alloc]initWithObjects:@"Course date(desc)",@"Course date(ACS)",@"Course price(desc)",@"Course price(asc)", nil];
    
    tempSortBy = @"0";
    [txtSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];
    _heightSearch.constant = 0;
    tblSales.estimatedRowHeight = 100;
    tblSales.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 200;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    txtSearch.layer.borderColor = __THEME_lightGreen.CGColor;
    txtSearch.layer.borderWidth = 1;
    txtSearch.layer.cornerRadius = 5;
    txtSearch.layer.masksToBounds = true;
    
    [self addShaowForiPad:viewShadow];
    viewShadow.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad Sales dashboard Screen"];
}

-(IBAction)btnSearchOpen:(UIButton*)sender{
    [self.view endEditing:true];
    if (_heightSearch.constant == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 50;
            [self.view layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 0;
            [self.view layoutIfNeeded];
            
        }];
        txtSearch.text = @"";
        [self searchTextValueChange:txtSearch];
    }
}
-(void)searchTextValueChange:(UITextField *)textFiled
{
    if (textFiled.text.tringString.length > 1) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@ OR price contains[c] %@ OR buyer contains[c] %@ OR coupon BEGINSWITH[cd] %@",textFiled.text,textFiled.text,textFiled.text,textFiled.text];
        arrData = [[arrDataCopy filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        [arrData removeAllObjects];
        [arrData addObjectsFromArray:arrDataCopy];
    }
    [tblSales reloadData];
}

-(void) getUserSales
{
    [self startActivity];
    [[NetworkManager sharedInstance]postRequestFullUrl:apiMysalesUrl paramter:@{@"sorting":tempSortBy} withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         if (result == WebServiceResultSuccess) {
             if ([jsonData isKindOfClass:[NSArray class]]) {
                 NSArray *arr = jsonData;
                 if (arr.count>0) {
                     [arrData removeAllObjects];
                     [arrDataCopy removeAllObjects];
                     for (NSDictionary *dict in arr)
                     {
                         SoldCourses *course = [[SoldCourses alloc]initWith:dict];
                         [arrData addObject:course];
                         [arrDataCopy addObject:course];
                     }
                     if (arrData.count>0) {
                         [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kVendorSalesKey];
                         [UserDefault synchronize];
                     }
                     [tblSales reloadData];
                     [tblParent reloadData];
                 } else{
                     showAletViewWithMessage(@"No data found.");
                 }
             }
             else
             {
                 pageIndex = -1;
                 showAletViewWithMessage(@"No data found.");
             }
         }
         else
         {
             
             NSData *data = [UserDefault objectForKey:kVendorSalesKey];
             if (data)
             {
                 id jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                 if ([jsonData isKindOfClass:[NSArray class]])
                 {
                     NSArray *arr = jsonData;
                     if (arr.count>0)
                     {
                         [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kVendorSalesKey];
                         [UserDefault synchronize];
                         
                         for (NSDictionary *dict in arr)
                         {
                             SoldCourses *course = [[SoldCourses alloc]initWith:dict];
                             [arrData addObject:course];
                         }
                         [tblSales reloadData];
                     }
                     else
                     {
                         showAletViewWithMessage(@"No data found.");
                     }
                 }
                 else
                 {
                     showAletViewWithMessage(kFailAPI);
                 }
                 
             }else
             {
                 showAletViewWithMessage(kFailAPI);
             }
         }
     }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self searchTextValueChange:textField];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self searchTextValueChange:textField];
    return true;
}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == tblParent)
        return 1;
    
    return arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblParent){
        if (selectedRow < arrData.count) {
            return 1;
        }else{
            return 0;
        }
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblSales)
    {
        SoldCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        [cell setData:[arrData objectAtIndex:indexPath.section]];
        UILabel *lblNo = [cell viewWithTag:112];
        lblNo.text = [NSString stringWithFormat:@"%ld",indexPath.section + 1];
        NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        if (selectedRow == index.section) {
            cell.backgroundColor = __THEME_lightGreen;
            cell.lblIdStatus.textColor = [UIColor whiteColor];
            cell.lblCreated.textColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.lblIdStatus.textColor = __THEME_GRAY;
            cell.lblCreated.textColor = __THEME_GRAY;
        }
        return cell;
    }else{
        SoldCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        [cell setData:[arrData objectAtIndex:selectedRow]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblSales)
        selectedRow = indexPath.section;
    
    [tblSales reloadData];
    [tblParent reloadData];
}

#pragma mark - Other method
- (IBAction)btnFilterAction:(UIButton*)sender
{
    OrderBySelectionVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"OrderBySelectionVC"];
    vc.arrOrder = [arrFilter mutableCopy];
    [vc getRefreshBlock:^(NSString *anyValue) {
        tempSortBy = anyValue;
        [self getUserSales];
    }];
    [self presentViewController:vc animated:true completion:nil];
}


@end
