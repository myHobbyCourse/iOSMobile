//
//  StudentAttendaceVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "StudentAttendaceVC.h"

@interface StudentAttendaceVC ()

@end

@implementation StudentAttendaceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Student Attendance";
    tableview.estimatedRowHeight = 100;
    tableview.rowHeight = UITableViewAutomaticDimension;
    /*for (Student *stud in self.product.students) {
        stud.presence = nil;
        stud.comment = @"";
        stud.late = @"0";
    }*/
    if (!is_iPad()) {
        [self getAttendance];    
    }
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Attendance Screen"];
}

-(void) getAttendance{
    [self startActivity];
    for (Student *stud in self.product.students) {
        stud.presence = nil;
        stud.comment = @"";
        stud.late = @"0";
    }
    
    [[NetworkManager sharedInstance] postRequestUrl:apiAttendance paramter:@{@"product_id":self.product.product_id} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in jsonData) {
                    Attendance *obj = [[Attendance alloc]initWith:dict];
                    if ([self.selectedSession.batch_start_date timeIntervalSince1970] == [obj.course_time_start intValue]) {
                        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.uid == %@",obj.uid_student];
                        NSArray<Student*> * test = [self.product.students filteredArrayUsingPredicate:predicate];
                        if (test.count > 0) {
                            [test firstObject].comment = obj.comment;
                            [test firstObject].presence = obj.attendance;
                            [test firstObject].late = obj.late;
                        }
                    }
                }
            }
            
            [tableview reloadData];
        }
    }];
    
}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (is_iPad()) ? 0 : 1 ;
    }
    return self.product.students.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StudentAttCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellHeader" forIndexPath:indexPath];
        cell.lblCourse.text = self.courseSchedule.title.tringString;
        cell.lblStartDate.text = self.product.course_start_date;
        cell.lblEndDate.text = self.product.course_end_date;
        cell.lblBatchDateTime.text = [NSString stringWithFormat:@"%@ %@",[frmtDaysTimeFormatter() stringFromDate:_selectedSession.batch_start_date],[global2DIGItYearFormatter() stringFromDate:_selectedSession.batch_start_date]];
        
        return cell;
    }else{
        StudentAttCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.btnComment.layer.cornerRadius = 8;
        cell.btnComment.layer.masksToBounds = YES;
   
        Student * student = self.product.students[indexPath.row];
        cell.controller = self;
        cell.student = student;
        [cell setStudentDate:student];
//        if ([_selectedSession.batch_start_date compare:[NSDate date]] == NSOrderedDescending) {
//            cell.userInteractionEnabled = false;
//            cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
//        }else{
            cell.userInteractionEnabled = true;
            cell.backgroundColor = [UIColor clearColor];
//        }
        return cell;
    }
}

-(IBAction)btnComment:(UIButton*)sender {
    if ([self.selectedSession.batch_start_date compare:[NSDate date]] == NSOrderedDescending) {
        showAletViewWithMessage(@"Attendance is only available on the day of a session or later, Please visit later");
        return;
    }
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tableview];
    NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:touchPoint];
    UITableViewCell * cell = [tableview cellForRowAtIndexPath:indexPath];
    Student * student = self.product.students[indexPath.row];
    AttAddCommentVC  *vc =(AttAddCommentVC*) [getStoryBoardDeviceBased(StoryboardPop) instantiateViewControllerWithIdentifier: @"AttAddCommentVC"];
    vc.txt = student.comment;
    [vc getRefreshBlock:^(NSString *anyValue) {
        student.comment = anyValue;
    }];
    if (is_iPad())
    {
        vc.txtComment.font = [UIFont systemFontOfSize:20];
        vc.view.backgroundColor = [__THEME_lightGreen colorWithAlphaComponent:0.5];
        vc.preferredContentSize = CGSizeMake(350, 350);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:sender.frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        }];
    }else{
        [self presentViewController:vc animated:true completion:nil];
    }
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
