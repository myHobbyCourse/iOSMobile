//
//  AttScheduleVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AttScheduleVC.h"

@interface AttScheduleVC ()
{
    NSMutableArray<CourseSchedule*> *arrSchedule;
    NSMutableArray<CourseSchedule*> *arrScheduleCopy;

    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
}
@end

@implementation AttScheduleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSchedule = [NSMutableArray new];
    arrScheduleCopy = [NSMutableArray new];
    [self getSchdeuleInfo];
    tableview.estimatedRowHeight = 100;
    tableview.rowHeight = UITableViewAutomaticDimension;
    tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [txtSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];
    _heightSearch.constant = 0;
    txtSearch.placeholder = @"Search by tittle,dates(dd-MMM-yy)";
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    [self updateToGoogleAnalytics:@"Attendence Course List Screen"];
}
-(void)viewDidAppear:(BOOL)animated{
    [tableview reloadData];
}

#pragma mark Search
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title contains[c] %@ OR post_date contains[c] %@ OR ANY arrProducts.course_end_date contains[c] %@ OR ANY arrProducts.course_start_date contains[c] %@",textFiled.text,textFiled.text,textFiled.text,textFiled.text];
        arrSchedule = [[arrScheduleCopy filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        [arrSchedule removeAllObjects];
        [arrSchedule addObjectsFromArray:arrScheduleCopy];
    }
    [tableview reloadData];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self searchTextValueChange:textField];
    return true;
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
                [tableview reloadData];
            }
        }
    }];
}

#pragma mark - UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrSchedule.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:16], NSFontAttributeName, nil];
    int courseTitleHeight = [arrSchedule[section].title boundingRectWithSize:CGSizeMake(tableview.frame.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    int tutorHeight = 0;
    if (arrSchedule[section].arrProducts.count>0 && !_isStringEmpty(arrSchedule[section].arrProducts[0].tutor)) {
        tutorHeight = [arrSchedule[section].arrProducts[0].tutor boundingRectWithSize:CGSizeMake((tableview.frame.size.width - 50)/2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
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
    if (is_iPad()) {
        [self performSegueWithIdentifier:@"toAttMarkiPad" sender:indexPath];
    }else{
        [self performSegueWithIdentifier:@"segueAttCalender" sender:indexPath];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueAttCalender"]) {
        AttCalenderVC *vc = segue.destinationViewController;
        NSIndexPath * index = sender;
        CourseSchedule * obj = arrSchedule[index.section];
        ProductEntity * product = obj.arrProducts[index.row];
        vc.product = product;
        vc.courseSchedule = obj;
        
    }
    if ([segue.identifier isEqualToString:@"toAttMarkiPad"]) {
        AttMarkVC_iPad *vc = segue.destinationViewController;
        NSIndexPath * index = sender;
        CourseSchedule * obj = arrSchedule[index.section];
        ProductEntity * product = obj.arrProducts[index.row];
        vc.product = product;
        vc.courseSchedule = obj;
        
    }
}


@end
