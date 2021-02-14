//
//  MyCouponsViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "MyCouponsViewController.h"

#import "CouponTableViewCell.h"

@interface MyCouponsViewController ()
{
    IBOutlet UITableView *tblCoupon;
    IBOutlet UILabel *lblCaption;
}
@end

@implementation MyCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    tblCoupon.tableFooterView = [[UIView alloc]init];
    [self getMyCoupan] ;
    
    [self hideShowLabel];

    tblCoupon.rowHeight =UITableViewAutomaticDimension;
    tblCoupon.estimatedRowHeight = 50;
    [tblCoupon reloadData];
    self.title = @"My Coupons";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"My Coupon Screen"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tblCoupon reloadData];
}
-(void) getMyCoupan
{
    if (![self isNetAvailable])
    {
        [self getCouponOffline];
        return;
    }

    [self startActivity];
    [[NetworkManager sharedInstance] getRequestUrl:apiCoupanUrl paramter:nil isToken:true withCallback:^(id jsonData, WebServiceResult result)
    {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                NSArray *arr = [jsonData valueForKey:@"coupons"];
                if ([arr isKindOfClass:[NSArray class]])
                {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kUserCouponKey];
                    [UserDefault synchronize];
                    [_arrData removeAllObjects];
                    for (NSDictionary *dict in arr)
                    {
                        if ([dict isKindOfClass:[NSDictionary class]])
                        {
                            NSMutableDictionary *d = [dict[@"coupon"] mutableCopy];
                            [d handleNullValue];
                            Coupon *myCoupon = [[Coupon alloc]initWith:d];
                            [_arrData addObject:myCoupon];
                        }
                        
                    }
                    NSArray *arrKeys = [_arrData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                        //                     [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                        [df setDateFormat:@"dd-MMM-yyyy"];
                        Coupon *a = obj1;
                        Coupon *b = obj2;
                        NSDate *d1 = [df dateFromString:a.Created_date];
                        NSDate *d2 = [df dateFromString:b.Created_date];
                        return [d2 compare: d1];
                    }];
                    if (arrKeys && arrKeys.count > 0)
                    {
                        [_arrData removeAllObjects];
                        [_arrData addObjectsFromArray:arrKeys];
                        
                        [self hideShowLabel];

                    }else{
                        [self hideShowLabel];

                    }
                    [tblCoupon reloadData];
                }
            }
        }else{
            showAletViewWithMessage(kFailAPI);
        }
    }];
}
-(void) getCouponOffline
{
    NSData *data = [UserDefault objectForKey:kUserCouponKey];
    if (data)
    {
        id jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([jsonData isKindOfClass:[NSDictionary class]])
        {
            NSArray *arr = [jsonData valueForKey:@"coupons"];
            if ([arr isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dict in arr)
                {
                    if ([dict valueForKey:@"coupon"])
                    {
                        Coupon *myCoupon = [[Coupon alloc]initWith:[dict valueForKey:@"coupon"]];
                        [_arrData addObject:myCoupon];
                    }
                    
                }
                NSArray *arrKeys = [_arrData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    //                     [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    Coupon *a = obj1;
                    Coupon *b = obj2;
                    NSDate *d1 = [df dateFromString:a.Created_date];
                    NSDate *d2 = [df dateFromString:b.Created_date];
                    return [d2 compare: d1];
                }];
                if (arrKeys && arrKeys.count > 0)
                {
                    [_arrData removeAllObjects];
                    [_arrData addObjectsFromArray:arrKeys];
                    [self hideShowLabel];

                }else
                {
                    [self hideShowLabel];

                }
                [tblCoupon reloadData];
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
    if (self.arrData.count > 0 ) {
        lblCaption.hidden = true;
        tblCoupon.hidden = false;
    }else{
        lblCaption.hidden = false;
        tblCoupon.hidden = true;
    }
}
- (void) initData {
    _arrData = [[NSMutableArray alloc]init];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponTableViewCell"];
    
    Coupon* coupon = [_arrData objectAtIndex:indexPath.row];
    [cell setData:coupon];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

@end
