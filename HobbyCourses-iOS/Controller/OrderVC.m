//
//  OrderVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "OrderVC.h"
#import "OrderCourseTableViewCell.h"
#import "OrderDetailCell.h"

@interface OrderVC ()
{
    IBOutlet UITableView *tblOrder;
    IBOutlet UILabel *lblCaption;
    IBOutlet UIView *viewShadow;
    IBOutlet UIView *viewRight;

    NSInteger selectedRow;
    NSMutableArray *arrSelectedSection;
    NSString *UUIDString;
    
    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
    NSMutableArray * arrDataCopy;
    
}
@end

@implementation OrderVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedRow = 0;
    tblOrder.tableFooterView = [[UIView alloc] init];
    arrDataCopy = [[NSMutableArray alloc]init];
    [self initData];
    [self getOrder];
    tblOrder.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tblOrder.estimatedRowHeight = 100;
    tblOrder.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    [self addShaowForiPad:viewShadow];
    
    [txtSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];
    _heightSearch.constant = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad View Order Screen"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tblOrder reloadData];
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY line_items.price contains[c] %@ OR ANY line_items.title contains[c] %@ OR ANY line_items.start_date contains[c] %@ OR ANY line_items.end_date contains[c] %@ OR self.coupon BEGINSWITH[cd] %@ OR self.status contains[c] %@",textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text];
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
                    [tblParent reloadData];
                    [self hideShowLabel];
                    
                }else
                {
                    [self hideShowLabel];
                    
                }
            }
        }
        else
        {
            showAletViewWithMessage(kFailAPI);
            
        }
    }];
}
-(void) deleteOrder:(NSString*) orderID
{
    if (![self isNetAvailable])
    {
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:apiDeletePendingOrder paramter:@{@"order_id":orderID} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            [self getOrder];
        }
        else
        {
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
        if ([jsonData isKindOfClass:[NSArray class]])
        {
            NSArray *arr = jsonData;
            if (arr && arr.count>0)
            {
                for (NSDictionary *dict in arr)
                {
                    UserOrder *order = [[UserOrder alloc] initWith:dict];
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
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:(is_iPad()) ? tblParent :tblOrder];
    NSIndexPath *indexPath = [(is_iPad()) ? tblParent :tblOrder indexPathForRowAtPoint:buttonPosition];
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
    product.product_id = GetTimeStampString;
    
    product.sessions_number = detail.sessions_number;
    product.sold = detail.sold;
    product.batch_size = detail.batch_size;
    
    vc.product = product;
    vc.isDetail = true;
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.preferredContentSize = CGSizeMake(_screenSize.width * 0.8, _screenSize.height *0.9);
    [self presentViewController:vc animated:false completion:nil];
}
-(IBAction)btnBankInfo:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblOrder];
    NSIndexPath *indexPath = [tblOrder indexPathForRowAtPoint:buttonPosition];
    UserOrder * obj = [_arrData objectAtIndex:indexPath.section];
    
    BankTransferVC  *vc =(BankTransferVC*) [self.storyboard instantiateViewControllerWithIdentifier: @"BankTransferVC"];
    vc.transfer_ref = obj.coupon;
    vc.isViewMode = true;
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.preferredContentSize = CGSizeMake(_screenSize.width * 0.8, _screenSize.height *0.8);
    [self presentViewController:vc animated:false completion:nil];
}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblOrder) {
        return _arrData.count;
    }else{
        return (_arrData.count) ? 4 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == tblOrder)
    {
        OrderCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCourseTableViewCell"];
        UserOrder *order = [_arrData objectAtIndex:indexPath.row];
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
        if (indexPath.row == selectedRow) {
            cell.backgroundColor = __THEME_lightGreen;
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
        
    }else{
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
        OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        UILabel *lblCourseCaption = [cell viewWithTag:111];
        lblCourseCaption.text = [NSString stringWithFormat:@"%ld.Course",(long)indexPath.row];
        UserOrder* order = [_arrData objectAtIndex:selectedRow];
        if(order.line_items.count > 0){
            OrderDetail *detail = [order.line_items objectAtIndex:0];
            [cell setData:detail summery:order];
            cell.hidden = false;
        }else{
            cell.hidden = true;
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblOrder) {
        UserOrder* order = [_arrData objectAtIndex:indexPath.row];
        if(order.line_items.count > 0){
            selectedRow = indexPath.row;
            [tblOrder reloadData];
            [tblParent reloadData];
        }else{
            showAletViewWithMessage(@"No order details found.");
        }
        
        
    }
}


@end
