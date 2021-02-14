//
//  CourseBatchDisplayVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 24/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseBatchDisplayVC.h"
#import "NSDate+NSDateUtility.h"
@interface CourseBatchDisplayVC (){
    IBOutlet UIButton *btnBack;
}
@end

@implementation CourseBatchDisplayVC
@synthesize isExpand;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 70;

    [self initData];
    
    btnBack.hidden = !self.isDetail;
    if (self.isDetail) {
        [self sectionButtonTouchUpInside:nil];
    }
}
-(void) initData{
    if (self.timing) {
        [self insertTimesFromOrder];
    }else{
        [self insertTimes];
    }
    [tblParent reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course batch calender view Screen"];
}
-(void)viewDidDisappear:(BOOL)animated {
    NSLog(@"Delete tempStore");
}

#pragma mark - UITableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isExpand){
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isHideFirstSection) {
        return 0;
    }else{
        return (is_iPad()) ? 245 : 270;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!is_iPad()) {
        return 435; //53
    }
    return 866;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"BatchHeader" owner:self options:nil];
    UIView *view = [viewArray objectAtIndex:(is_iPad()) ? 4: 0];
    UIButton *btn = [view viewWithTag:101];
    UIButton *btnBook = [view viewWithTag:102];
    
    UILabel *lblStart = [view viewWithTag:11];
    UILabel *lblEnd = [view viewWithTag:12];
    UILabel *lblSession = [view viewWithTag:13];
    UILabel *lblBatch = [view viewWithTag:14];
    UILabel *lblPrice = [view viewWithTag:15];
    UILabel *lblSold = [view viewWithTag:16];
    UILabel *lblQyt = [view viewWithTag:17];

    lblStart.text = self.product.course_start_date;
    lblEnd.text = self.product.course_end_date;
    lblSession.text = self.product.sessions_number;
    lblBatch.text = self.product.batch_size;
    lblPrice.text = self.product.initial_price;
    lblSold.text = self.product.sold;
    lblQyt.text = self.product.quantity;
    
    btnBook.hidden = self.isDetail;
    [btn addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    //[btnBook addTarget:self action:@selector(bookCourse:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = section;
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        BatchDisplay *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        cell.rowID = self.rowID;
        cell.courseStartDate = self.product.course_start_date;
        cell.courseEndDate = self.product.course_end_date;
        cell.lblBatchCaption.text = @" Session Week ";
        [cell setData];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(void)sectionButtonTouchUpInside:(UIButton*)sender {
    isExpand = !isExpand;
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:0];
    [tblParent reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void) batchesOnCalender:(FSCalendar*) calender{
    for (TimeBatch *obj in self.timing) {
        [calender selectDate:obj.batch_start_date];
    }
}

-(void) insertTimes {
    
    NSDateFormatter *format11 = [[NSDateFormatter alloc]init];
    [format11 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateFormatter *format33 = [[NSDateFormatter alloc]init];
    [format33 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSDateFormatter *format22 = [[NSDateFormatter alloc]init];
    [format22 setDateFormat:@"yyyy-MM-dd"];
    self.rowID = GetTimeStampString;
    for(NSDictionary *d in self.arrTimes) {
        if (d[@"value"] != nil && d[@"value2"] != nil) {
            NSString *start = d[@"value"];
            NSString *end = d[@"value2"];
            
            NSDate *date = [format11 dateFromString:start]; // For the compare
            NSDate *s1 = [format11 dateFromString:start];
            NSDate *e2 = [format11 dateFromString:end];
            if (s1 && e2) {
                NSString  *startDate = [format33 stringFromDate:s1];
                NSString *endDate = [format33 stringFromDate:e2];
                if (date) {
                    NSString *compare = [format22 stringFromDate:date];
                    [TempStore insertTimesFrom:startDate to:endDate Compare:compare UUID:self.rowID];
                }
            }
        }
    }
}
-(void) insertTimesFromOrder {
    
    NSDateFormatter *format11 = [[NSDateFormatter alloc]init];
    [format11 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateFormatter *format33 = [[NSDateFormatter alloc]init];
    [format33 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSDateFormatter *format22 = [[NSDateFormatter alloc]init];
    [format22 setDateFormat:@"yyyy-MM-dd"];
    self.rowID = GetTimeStampString;
    for(TimeBatch *obj in self.timing) {
        if (obj.batch_start_date && obj.batch_end_date) {
            NSString  *startDate = [format33 stringFromDate:obj.batch_start_date];
            NSString *endDate = [format33 stringFromDate:obj.batch_end_date];
            NSString *compare = [format22 stringFromDate:obj.batch_start_date];
            [TempStore insertTimesFrom:startDate to:endDate Compare:compare UUID:self.rowID];
        }
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
