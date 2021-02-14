//
//  AgeSelectionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AgeSelectionVC.h"

@interface AgeSelectionVC (){
    NSMutableArray *arrAgeTitle;
    NSInteger selectedRow;
}

@end

@implementation AgeSelectionVC
@synthesize searchObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrAgeTitle = [[NSMutableArray alloc] initWithObjects:@"Adult",@"Young Adult",@"Middle Age Adult",@"Older Adult",@"A Level",@"GCSE",@"Secondary School",@"Primary School", nil];
    
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    selectedRow = -1;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Age Selection Screen"];

}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchObj.arrAgeValue.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIView *viewBG = [cell viewWithTag:11];
    viewBG.layer.cornerRadius = viewBG.frame.size.height /2;
    viewBG.layer.masksToBounds = true;
    UILabel *lblCaption = [cell viewWithTag:12];
    UILabel *lblValue = [cell viewWithTag:13];
    if (indexPath.row == 0) {
        lblValue.text = @"";
    }else{
        lblValue.text = searchObj.arrAgeValue[indexPath.row];
    }
    lblCaption.text = arrAgeTitle[indexPath.row];

    if (indexPath.row == selectedRow) {
        viewBG.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    }else{
        viewBG.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRow = indexPath.row;
    [tblParent reloadData];
}

-(IBAction)btnSave:(id)sender {
    if (selectedRow == -1) {
        showAletViewWithMessage(@"Please select age first");
        return;
    }
    searchObj.ageGroup = searchObj.arrAgeValue[selectedRow];
    [self parentDismiss:nil];
    [DefaultCenter postNotificationName:@"searchAdvanceAPI" object:self];
    if (_refreshBlock) {
        _refreshBlock(searchObj.arrAgeValue[selectedRow]);
    }
}
-(void) refreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
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
