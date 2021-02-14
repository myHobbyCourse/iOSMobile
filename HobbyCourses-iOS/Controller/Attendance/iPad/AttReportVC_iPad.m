//
//  AttReportVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AttReportVC_iPad.h"

@interface AttReportVC_iPad (){
    IBOutlet UIView *viewShadow;
    NSMutableArray<CourseSchedule*> *arrSchedule;
    NSMutableArray<CourseSchedule*> *arrScheduleCopy;

}
@end

@implementation AttReportVC_iPad
@synthesize selectedSession;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSchedule = [NSMutableArray new];
    arrScheduleCopy = [NSMutableArray new];

    
    [self.view layoutIfNeeded];
    [self addShaowForiPad:viewShadow];

    /*AttendanceVC *vc =  self.childViewControllers[0];
    vc.session = self.session;
    vc.courseTitle = self.courseSchedule.title;
    vc.product = self.product;
    [vc getAttendanceInfo];
    [tblParent reloadData];*/
    [self getSchdeuleInfo];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Attendance Report Screen"];
}
#pragma mark - UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrSchedule.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:18], NSFontAttributeName, nil];
    int courseTitleHeight = [arrSchedule[section].title boundingRectWithSize:CGSizeMake(tblParent.frame.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    int tutorHeight = 0;
    if (arrSchedule[section].arrProducts.count>0 && !_isStringEmpty(arrSchedule[section].arrProducts[0].tutor)) {
        tutorHeight = [arrSchedule[section].arrProducts[0].tutor boundingRectWithSize:CGSizeMake((tblParent.frame.size.width - 50)/2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    }
    return  tutorHeight + courseTitleHeight + 40;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell * header = [tableView dequeueReusableCellWithIdentifier:@"CellHeader"];
    header.backgroundColor = [UIColor lightGrayColor];
    UILabel *lbl1 = [header viewWithTag:11];
    UILabel *lbl2 = [header viewWithTag:12];
    UILabel *lblTitle = [header viewWithTag:10];
    UILabel *lblNo = [header viewWithTag:100];
    lblNo.text = [NSString stringWithFormat:@"%ld.",section + 1];
    
    lblTitle.text = arrSchedule[section].title;
    lbl1.text = [NSString stringWithFormat:@"Tutor: %@",arrSchedule[section].arrProducts[0].tutor];
    lbl2.text = [NSString stringWithFormat:@"Location : %@",arrSchedule[section].city];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrSchedule[section].arrProducts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    CourseSchedule * obj = arrSchedule[indexPath.section];
    ProductEntity * product = obj.arrProducts[indexPath.row];
    UILabel *lbl1 = [cell viewWithTag:11];
    UILabel *lbl2 = [cell viewWithTag:12];
    UILabel *lbl3 = [cell viewWithTag:13];
    UILabel *lbl4 = [cell viewWithTag:14];
    UILabel *lblSession = [cell viewWithTag:15];
    
    
    lbl1.text = [NSString stringWithFormat:@"%@",product.course_start_date];
    lbl2.text = [NSString stringWithFormat:@"%@",product.course_end_date];
    lbl3.text = [NSString stringWithFormat:@"%@",product.price];
    lbl4.text = [NSString stringWithFormat:@"%@",product.batch_size];
    lblSession.text = product.sessions_number;
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toAttMarkiPad" sender:indexPath];
}


#pragma mark API Calls
-(void) getSchdeuleInfo {
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiGetSchedule paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        HCLog(@"%@",jsonData);
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in jsonData) {
                    NSMutableDictionary *d = [dict mutableCopy] ;
                    [d handleNullValue];
                    CourseSchedule * obj = [[CourseSchedule alloc]initWith:d];
                    if (obj.arrProducts.count >0) {
                        [arrSchedule addObject:obj];
                        [arrScheduleCopy addObject:obj];
                    }
                }
                [tblParent reloadData];
            }
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toAttMarkiPad"]) {
        AttMarkVC_iPad *vc = segue.destinationViewController;
        NSIndexPath * index = sender;
        CourseSchedule * obj = arrSchedule[index.section];
        ProductEntity * product = obj.arrProducts[index.row];
        vc.product = product;
        vc.courseSchedule = obj;
        [vc refreshBlock:^(NSString *anyValue) {
            AttendanceVC *vc =  self.childViewControllers[0];
            vc.session = anyValue;
            vc.courseTitle = self.courseSchedule.title;
            vc.product = product;
            [vc getAttendanceInfo];
            [tblParent reloadData];
        }];
        
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
