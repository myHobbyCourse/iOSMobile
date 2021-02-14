//
//  OrderBySelectionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "OrderBySelectionVC.h"

@interface OrderBySelectionVC (){
    NSInteger selectedRow;
}

@end

@implementation OrderBySelectionVC
@synthesize searchObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Sort by Screen"];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (searchObj == nil) ? self.arrOrder.count : searchObj.arrOrderBy.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblCaption = [cell viewWithTag:11];
    lblCaption.text = (searchObj == nil) ? self.arrOrder[indexPath.row] : searchObj.arrOrderBy[indexPath.row];
    if (indexPath.row == selectedRow) {
        lblCaption.textColor = (is_iPad()) ? [UIColor whiteColor] :[UIColor blackColor];
    }else{
        lblCaption.textColor = (is_iPad()) ? [UIColor darkGrayColor] : [UIColor lightGrayColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
    [tblParent reloadData];
}
-(IBAction)btnSave:(id)sender{
    if (searchObj) {
        searchObj.orderBy = searchObj.arrOrderBy[selectedRow];
        [DefaultCenter postNotificationName:@"searchAdvanceAPI" object:self];
    }else{
        if(_refreshBlock)
            _refreshBlock([NSString stringWithFormat:@"%ld",(long)selectedRow]);
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
