//
//  AttCalenderVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AttCalenderVC.h"
#import "FSCalendar.h"

@interface AttCalenderVC ()<FSCalendarDataSource,FSCalendarDelegate>{
    NSInteger selectedSession;
}
@end

@implementation AttCalenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.calenderView.allowsMultipleSelection = YES;
    if (!is_iPad()) {
        [self initData];
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Attendence Calender view Screen"];
}
-(void) initData{
    for (TimeBatch *obj in self.product.timingsDate) {
        [self.calenderView selectDate:obj.batch_start_date];
    }
    [self.calenderView setCurrentPage:(self.product.timingsDate.count > 0) ? self.product.timingsDate[0].batch_start_date : [NSDate date]];
    selectedSession = 0;
}

#pragma mark - FSCalenderDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date {
    return false;
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    [self hadnleTapped:date];
}
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date {
    [self hadnleTapped:date];
}
-(void) hadnleTapped:(NSDate*) date {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sDate == %@",[globalDateFormatter() dateFromString:[globalDateFormatter() stringFromDate:date]]];
    NSArray<TimeBatch*> *arr = [self.product.timingsDate filteredArrayUsingPredicate:predicate];
    if (arr.count > 0) {
        [self.calenderView selectDate:arr[0].batch_start_date];
    }else{
        [self.calenderView deselectDate:date];
    }
}
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    if (is_iPad()) {
        _heightCalendar.constant = 350;
    }
    [self.view layoutIfNeeded];
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (is_iPad()) {
        _heightCalendar.constant = 350;
    }
    [self.view layoutIfNeeded];
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.product.timingsDate.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    TimeBatch * obj = self.product.timingsDate[indexPath.row];
    
    UILabel *lbl1 = [cell viewWithTag:11];
    UILabel *lbl2 = [cell viewWithTag:12];
    UIButton *btn = [cell viewWithTag:13];
    UIButton *btnStud = [cell viewWithTag:14];
    
    lbl1.text = [NSString stringWithFormat:@"%@",[global2DIGItYearFormatter() stringFromDate:obj.batch_start_date]];
    lbl2.text = [NSString stringWithFormat:@"%@",[frmtDaysTimeFormatter() stringFromDate:obj.batch_start_date]];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = true;
    if (is_iPad()) {
        if (selectedSession == indexPath.row && is_iPad()) {
            btn.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:241.0/255.0 blue:240.0/255.0 alpha:1.0];
            cell.backgroundColor = __THEME_lightGreen;
            btn.titleLabel.textColor = __THEME_lightGreen;
            btnStud.titleLabel.textColor = [UIColor whiteColor];
        } else {
            btn.backgroundColor = __THEME_lightGreen;
            cell.backgroundColor = [UIColor clearColor];
            btn.titleLabel.textColor = [UIColor whiteColor];
            btnStud.titleLabel.textColor = __THEME_lightGreen;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (is_iPad()) {
        StudentAttendaceVC *studentAttendaceVC = self.parentViewController.childViewControllers[0];
        studentAttendaceVC.selectedSession = self.product.timingsDate[indexPath.row];
        [studentAttendaceVC getAttendance];
        selectedSession = indexPath.row;
        [tableView reloadData];
    }else{
        [self performSegueWithIdentifier:@"segueStudent" sender:indexPath];
    }
}
#pragma mark Custom method
-(IBAction)btnCheck:(UIButton*)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tableview];
    NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:touchPoint];
    if (is_iPad()) {
         AttMarkVC_iPad *vc = (AttMarkVC_iPad *)self.parentViewController;
        vc.refreshBlock(self.product.timingsDate[indexPath.row]);
        [self.parentViewController.navigationController popViewControllerAnimated:true];
    }else{
        [self performSegueWithIdentifier:@"segueAttendace" sender:indexPath];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueAttendace"]) {
        AttendanceVC *vc = segue.destinationViewController;
        NSIndexPath * index = sender;
        vc.session = self.product.timingsDate[index.row];
        vc.courseTitle = self.courseSchedule.title;
        vc.product = self.product;
    }else if ([segue.identifier isEqualToString:@"toReport"]) {
        AttReportVC_iPad *vc = segue.destinationViewController;
        vc.product = self.product;
        vc.courseSchedule = self.courseSchedule;
        NSIndexPath * index = sender;
        vc.session = self.product.timingsDate[index.row];
        vc.selectedSession = selectedSession;
    } else{
        StudentAttendaceVC *vc = segue.destinationViewController;
        NSIndexPath *index = sender;
        vc.product = self.product;
        vc.courseSchedule = self.courseSchedule;
        vc.selectedSession = self.product.timingsDate[index.row];
    }
}


@end
