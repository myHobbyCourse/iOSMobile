//
//  AttendanceVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 10/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AttendanceVC.h"

@interface AttendanceVC ()
{
    NSMutableArray<Attendance*> *arrAttendance;
    NSString *sessionsBW;
}
@end

@implementation AttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tableview.estimatedRowHeight = 100;
    tableview.rowHeight = UITableViewAutomaticDimension;
    if (!is_iPad()) {
        [self getAttendanceInfo];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Attendance Screen"];
}
#pragma mark - API Calls
-(void) getAttendanceInfo {
    [self startActivity];
    arrAttendance = [NSMutableArray new];
    NSMutableArray *arr = [NSMutableArray new];
    for (TimeBatch *tb in self.product.timingsDate) {
        if ([self weekIsEqual:self.session.batch_start_date and:tb.batch_start_date]) {
            double startTime = [tb.batch_start_date timeIntervalSince1970];
            NSNumber *num = [NSNumber numberWithDouble:startTime];
            [arr addObject:num];
        }
    }
    double startTime = [[arr firstObject] doubleValue];
    NSDate *wDate1 = [NSDate dateWithTimeIntervalSince1970:startTime];
    double endTime = [[arr lastObject] doubleValue];
    NSDate *wDate2 = [NSDate dateWithTimeIntervalSince1970:endTime];
    sessionsBW = [NSString stringWithFormat:@"%@ to %@",[global2DIGItYearFormatter() stringFromDate:wDate1],[global2DIGItYearFormatter() stringFromDate:wDate2]];
    
    
    [[NetworkManager sharedInstance] postRequestUrl:apiAttendance paramter:@{@"product_id":self.product.product_id} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                NSMutableArray<Attendance*> *arrTemp = [NSMutableArray new];
                for (NSDictionary *dict in jsonData) {
                    Attendance *obj = [[Attendance alloc]initWith:dict];
                    NSNumber *startTime = [NSNumber numberWithInt:[obj.course_time_start intValue]];
                    if ([arr containsObject:startTime]) {
                        [arrTemp addObject:obj];
                    }
                }
                NSMutableSet *sets = [NSMutableSet new];
                for (Attendance *obj in arrTemp) {
                    [sets addObject:obj.uid_student];
                }
                
                for (NSString *uid in sets) {
                    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.uid_student == %@",uid];
                    NSArray<Attendance*> * test = [arrTemp filteredArrayUsingPredicate:predicate];
                    if (test.count > 0) {
                        [arrAttendance addObject:test];
                    }
                }
                
            }
            
            [tableview reloadData];
        }
    }];
}
- (BOOL) weekIsEqual:(NSDate *)date and:(NSDate *)otherDate {
    NSDateComponents *dateComponents      = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    NSDateComponents *otherDateComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:otherDate];
    
    return [dateComponents week] == [otherDateComponents week] && [dateComponents year] == [otherDateComponents year];
}
-(IBAction)btnDetails:(UIButton*)sender {
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:tableview];
    NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:touchPoint];
    NSString * days;
    switch (sender.tag) {
        case 1:
            days = @"Mon";
            break;
        case 2:
            days = @"Tue";
            break;
        case 3:
            days = @"Wed";
            break;
        case 4:
            days = @"Thu";
            break;
        case 5:
            days = @"Fri";
            break;
        case 6:
            days = @"Sat";
            break;
        case 7:
            days = @"Sun";
            break;
        default:
            break;
    }
    NSArray * arr =  arrAttendance[indexPath.section -1];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.strDay == %@",days];
    NSArray<Attendance*> * test = [arr filteredArrayUsingPredicate:predicate];
    if (test.count >0 ) {
        Attendance * obj = [test firstObject];
        StudeInfo *info = [StudeInfo instanceFromNib:@[obj.uid_student,obj.student_name,@"",_isStringEmpty(obj.comment) ? @"": obj.comment,obj.student_avatar] controller:self];
        [APPDELEGATE.window addSubview:info];
    }
    
    
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrAttendance.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StudentAttCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellHeader" forIndexPath:indexPath];
        cell.lblCourse.text = self.courseTitle;
        cell.lblStartDate.text = self.product.course_start_date;
        cell.lblEndDate.text = self.product.course_end_date;
        cell.lblBatchDateTime.text = sessionsBW;
        return cell;
    }else{
        AttendanceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell setWeekAttendacen:arrAttendance[indexPath.section - 1]];
        return cell;
    }
}

@end
