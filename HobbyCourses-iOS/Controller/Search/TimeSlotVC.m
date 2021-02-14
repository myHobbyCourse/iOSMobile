//
//  TimeSlotVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 30/04/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "TimeSlotVC.h"

@interface TimeSlotVC (){
    NSInteger selectedRow;
}

@end

@implementation TimeSlotVC
@synthesize searchObj;
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedRow = -1;
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    
    if (self.searchObj) {
        selectedRow = [self.searchObj getTimesValue];
        if (selectedRow == 5) {
            selectedRow = 4;
        }
    }
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Class Time Screen"];
}
//-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
//    self.refreshBlock = refreshBlock;
//}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (searchObj == nil) ? 0 : searchObj.arrTimes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblCaption = [cell viewWithTag:11];
    lblCaption.text = searchObj.arrTimes[indexPath.row];
    if (indexPath.row == selectedRow) {
        lblCaption.textColor = (is_iPad()) ? [UIColor whiteColor] :[UIColor blackColor];
    }else{
        lblCaption.textColor = (is_iPad()) ? [UIColor blackColor] : [UIColor lightGrayColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
    [tblParent reloadData];
}
-(IBAction)btnSave:(id)sender{
    if (searchObj && selectedRow != -1) {
        searchObj.timesValue = searchObj.arrTimes[selectedRow];
        [DefaultCenter postNotificationName:@"searchCoursesAPI" object:self];
    }else{
        showAletViewWithMessage(@"Please select class time first");
//        if(_refreshBlock)
//            _refreshBlock([NSString stringWithFormat:@"%ld",(long)selectedRow]);
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
