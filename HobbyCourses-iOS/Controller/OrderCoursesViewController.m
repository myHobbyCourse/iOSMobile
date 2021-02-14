//
//  OrderCoursesViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "OrderCoursesViewController.h"

#import "OrderCourseTableViewCell.h"
#import "OrderDetailCell.h"
@interface OrderCoursesViewController ()
{
    IBOutlet UITableView *tblOrder;
    IBOutlet UILabel *lblCaption;
    NSInteger selectedCell;
    NSMutableArray *arrSelectedSection;
    NSString *UUIDString;
    
    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
    NSMutableArray * arrDataCopy;
}
@end

@implementation OrderCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedCell = -1;
    tblOrder.tableFooterView = [[UIView alloc] init];
    arrDataCopy = [[NSMutableArray alloc]init];
    [self initData];
    [self getOrder];
    self.navigationItem.title = @"My Orders";
    tblOrder.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [txtSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];
    _heightSearch.constant = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"View Order Screen"];
}

-(BOOL)hidesBottomBarWhenPushed {
    return false;
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY line_items.price contains[c] %@ OR ANY line_items.title contains[c] %@ OR ANY line_items.seller_mail contains[c] %@ OR ANY line_items.start_date contains[c] %@ OR ANY line_items.end_date contains[c] %@ OR self.coupon BEGINSWITH[cd] %@ OR self.status contains[c] %@ OR self.order_id contains[c] %@ OR self.order_total contains[c] %@",textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text];
        self.arrData = [[arrDataCopy filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        [self.arrData removeAllObjects];
        [self.arrData addObjectsFromArray:arrDataCopy];
    }
    [tblOrder reloadData];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self searchTextValueChange:textField];
    return true;
}
#pragma mark  - API Calls
-(void) getOrder
{
    if (![self isNetAvailable]) {
        [self getOfflineCourse];
        return;
    }
    
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:apiOrderNewURL paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = jsonData;
                if (arr && arr.count>0)
                {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kUserOrderKey];
                    [UserDefault synchronize];
                    [_arrData removeAllObjects];
                    for (NSDictionary *dict in arr)
                    {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        UserOrder *order = [[UserOrder alloc] initWith:d];
                        if (order) {
                            [_arrData addObject:order];
                            [arrDataCopy addObject:order];
                        }
                    }
                    [tblOrder reloadData];
                    [self hideShowLabel];

                }else
                {
                    [self hideShowLabel];
                    
                }
            }
        } else {
            showAletViewWithMessage(kFailAPI);
        }
    }];
}
-(void) deleteOrder:(NSString*) orderID
{
    if (![self isNetAvailable]) {
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:apiDeletePendingOrder paramter:@{@"order_id":orderID} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [self getOrder];
        } else {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (NSArray*) jsonData;
                if (arr.count > 0)
                {
                    showAletViewWithMessage(arr[0]);
                    
                }
            }else{
                showAletViewWithMessage(@"Fail to delete order,Please try again.");}
        }
    }];
}
-(void)getOfflineCourse
{
    NSData *data = [UserDefault objectForKey:kUserOrderKey];
    if (data)
    {
        id jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([jsonData isKindOfClass:[NSArray class]]) {
            NSArray *arr = jsonData;
            if (arr && arr.count>0)
            {
                for (NSDictionary *dict in arr) {
                    NSMutableDictionary *d = [dict mutableCopy];
                    [d handleNullValue];
                    UserOrder *order = [[UserOrder alloc] initWith:d];
                    [self.arrData addObject:order];
                }
                [tblOrder reloadData];
                [self hideShowLabel];
                
            }else{
                showAletViewWithMessage(@"No order found.");
                [self hideShowLabel];
                
            }
        }
        else
        {
            showAletViewWithMessage(kFailAPI);
        }
        
    }else{
        [self hideShowLabel];
        
    }
    
}
- (void) hideShowLabel
{
    if (self.arrData.count > 0) {
        lblCaption.hidden = true;
        tblOrder.hidden = false;
    }else{
        lblCaption.hidden = false;
        tblOrder.hidden = true;
    }
}

- (void) initData {
    self.arrData = [[NSMutableArray alloc]init];
    tblOrder.rowHeight = UITableViewAutomaticDimension;
    tblOrder.estimatedRowHeight = 100;
    arrSelectedSection = [[NSMutableArray alloc]init];
    self.arrData = [[NSMutableArray alloc]init];
    lblCaption.hidden = true;
}
-(IBAction)btnCourseDetail:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblOrder];
    NSIndexPath *indexPath = [tblOrder indexPathForRowAtPoint:buttonPosition];
    OrderDetailCell *cell = (OrderDetailCell*)[tblOrder cellForRowAtIndexPath:indexPath];
    UserOrder * obj = [_arrData objectAtIndex:indexPath.section];
    OrderDetail *detail =  obj.line_items[0];
    CourseBatchDisplayVC  *vc =(CourseBatchDisplayVC*) [self.storyboard instantiateViewControllerWithIdentifier: @"CourseBatchDisplayVC"];
    CourseDetail *courseEntity = [CourseDetail new];
    courseEntity.address_1 = detail.seller_address;
    vc.courseEntity = courseEntity;
    vc.timing = detail.timing;;
    NSDate *sDate = [dateSimpleFormatter() dateFromString:detail.start_date];
    NSDate *eDate = [dateSimpleFormatter() dateFromString:detail.end_date];
    vc.courseStart = [globalDateOnlyFormatter() stringFromDate:sDate];
    vc.courseEnd = [globalDateOnlyFormatter() stringFromDate:eDate];
    ProductEntity *product = [ProductEntity new];
    product.course_end_date = vc.courseEnd;
    product.course_start_date = vc.courseStart;
    product.initial_price = detail.price;
    product.quantity = detail.quantity;
    product.sessions_number = detail.sessions_number;
    product.sold = detail.sold;
    product.batch_size = detail.batch_size;
    
    product.product_id = GetTimeStampString;
    vc.product = product;
    vc.isDetail = true;
    if (is_iPad())
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:cell.btnDetails.frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        }];
    }else{
        [self presentViewController:vc animated:false completion:nil];
    }
}
-(IBAction)btnBankInfo:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblOrder];
    NSIndexPath *indexPath = [tblOrder indexPathForRowAtPoint:buttonPosition];
    OrderDetailCell *cell = (OrderDetailCell*)[tblOrder cellForRowAtIndexPath:indexPath];
    UserOrder * obj = [_arrData objectAtIndex:indexPath.section];
    
    BankTransferVC  *vc =(BankTransferVC*) [self.storyboard instantiateViewControllerWithIdentifier: @"BankTransferVC"];
    vc.transfer_ref = obj.coupon;
    vc.isViewMode = true;
    if (is_iPad())
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:cell.btnDetails.frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        }];
    }else{
        [self.navigationController pushViewController:vc animated:false];
    }

}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:section];
    if ([arrSelectedSection containsObject:index])
    {
        UserOrder *order = [_arrData objectAtIndex:section];
        if (order.line_items.count > 0) {
            return 5;
        }
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        OrderCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCourseTableViewCell"];
        UserOrder *order = [_arrData objectAtIndex:indexPath.section];
        [cell setData:order];
        if ([order.status.lowercaseString isEqualToString:@"pending"]) {
            cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
                [AppUtils actionWithMessage:kAppName withMessage:@"Are you sure want to delete order?" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
                    if ([tapped isEqualToString:@"YES"]) {
                        [self deleteOrder:order.order_id];
                    }
                }];

                return YES;
            }]];
            cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        }
        return cell;
        
    }else{
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
        OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        UILabel *lblCourseCaption = [cell viewWithTag:111];
        lblCourseCaption.text = [NSString stringWithFormat:@"%ld.Course",(long)indexPath.row];
        UserOrder* order = [_arrData objectAtIndex:indexPath.section];
        
        OrderDetail *detail = [order.line_items objectAtIndex:0];
        [cell setData:detail summery:order];
        cell.backgroundColor = __THEME_lightGreen;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0)
    {
        if ([arrSelectedSection containsObject:indexPath]) {
            [arrSelectedSection removeObject:indexPath];
        }else {
            UserOrder *order = [_arrData objectAtIndex:indexPath.section];
            if (order.line_items.count > 0) {
                [arrSelectedSection addObject:indexPath];
            }else{
                showAletViewWithMessage(@"No order detail from server,Please contact to admin.");
            }

        }
//        [tblOrder reloadData];
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:indexPath.section];
        [tblOrder reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}
-(void) setOrder:(NSDictionary*) dict
{
    if (![self isNetAvailable])
    {
        [self getOrder];
        return;
    }
    
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiPostOrder paramter:dict withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         if (result == WebServiceResultSuccess) {
             [self deleteEntityFromDatabase];
             [self syncOrder];
         } else {
             showAletViewWithMessage(@"There seems to be server issue,Please try again.");
             [self getOrder];

         }
     }];
}
-(void) syncOrder
{
    NSArray *arr = [self getUnsubmittedCourseFromDatabase];
    if (arr.count > 0) {
        NSDictionary* courseDataDic = [NSKeyedUnarchiver unarchiveObjectWithData:[[arr firstObject] valueForKey:@"courseJson"]];
        UUIDString = [[arr firstObject] valueForKey:@"uid"];
        [self setOrder:courseDataDic];
    } else {
        [self getOrder];
    }
}

-(NSArray*)getUnsubmittedCourseFromDatabase{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CourseOrderSync" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    [request setEntity:entity];
    NSArray *results = [APPDELEGATE.managedObjectContext executeFetchRequest:request error:nil];
    if (results != nil && [results count] > 0)
    {
        return results;
    }
    return [[NSArray alloc] init];
}
-(void)deleteEntityFromDatabase
{
    NSArray* course = [self getUnsubmittedCourseFromDatabase];
    for (NSManagedObject* courseObject in course)
    {
        if ([[courseObject valueForKey:@"uid"] isEqual:UUIDString])
        {
            [APPDELEGATE.managedObjectContext deleteObject:courseObject];
            [APPDELEGATE saveContext];
            break;
        }
    }
}



@end
