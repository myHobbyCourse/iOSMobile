//
//  ReminderVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 04/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ReminderVC.h"

@interface ReminderVC (){
    NSMutableArray *arrData;
    NSInteger days,hours,minutes;
    NSDate *reminderDate;
    OrderDetail *objEntity;
    NSString *latDest1;
    NSString *lngDest1;
}

@end

@implementation ReminderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 500;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    arrData = [NSMutableArray new];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self getOrder];
    [self updateToGoogleAnalytics:@"Reminder Screen"];

}
-(void) getLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:[NSString stringWithFormat:@"%@",objEntity.course_address] completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks)
        {
            // Process the placemark.
            latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
            lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
            [tblParent reloadData];
        }
    }];
}
-(void) updateTime{
    
    NSTimeInterval seconds = [reminderDate timeIntervalSinceNow];
    days           = floor(seconds/24/60/60);
    int hoursLeft   = floor((seconds) - (days*86400));
    hours           = floor(hoursLeft/3600);
    int minutesLeft = floor((hoursLeft) - (hours*3600));
    minutes         = floor(minutesLeft/60);
    [tblParent reloadData];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:60];
}
-(IBAction)btnDirection:(UIButton*)sender{
    if (_isStringEmpty(lngDest1)) {
        showAletViewWithMessage(@"Location co-oridanate is not proper");
        return;
    }
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%@,%@&daddr=%@,%@",latDest1, lngDest1, latDest1, lngDest1];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UIButton *lblDays = [cell viewWithTag:11];
        UIButton *lblHour = [cell viewWithTag:12];
        UIButton *lblMin = [cell viewWithTag:13];
        
        UILabel *lblCouseName = [cell viewWithTag:14];
        UILabel *lblDayName = [cell viewWithTag:15];
        UILabel *lblDate = [cell viewWithTag:16];
        UILabel *lblTime = [cell viewWithTag:17];
        UILabel *lblAddress = [cell viewWithTag:18];
        
        if (objEntity) {
            lblCouseName.text = objEntity.title;
            lblDayName.text = [dayNameFormatter() stringFromDate:reminderDate];
            lblDate.text = [globalDateOnlyFormatter() stringFromDate:reminderDate];
            
            lblTime.text = [NSString stringWithFormat:@"%@ - %@",[_timeFormatter() stringFromDate:reminderDate],[_timeFormatter() stringFromDate:objEntity.nearestDateEnd]];
            lblAddress.text = [NSString stringWithFormat:@"%@",objEntity.course_address];
            
        }
        
        [lblDays setTitle:[NSString stringWithFormat:@"%ld",(long)days] forState:UIControlStateNormal];
        [lblHour setTitle:[NSString stringWithFormat:@"%ld",(long)hours] forState:UIControlStateNormal];
        [lblMin setTitle:[NSString stringWithFormat:@"%ld",(long)minutes] forState:UIControlStateNormal];
        if (is_iPad()) {
            if (lngDest1) {
                NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",latDest1,lngDest1,@"zoom=15&size=450x300"];
                NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                UIImageView *imgV = [cell viewWithTag:111];
                [imgV sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
            }
        }
    }else{
        if (!is_iPad()) {
            if (lngDest1) {
                NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",latDest1,lngDest1,@"zoom=15&size=450x300"];
                NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                UIImageView *imgV = [cell viewWithTag:11];
                [imgV sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
            }
        }
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!is_iPad() && indexPath.row == 1) {
        [self btnDirection:nil];
    }
}
#pragma mark  - API Calls
-(void) getOrder
{
    if (![self isNetAvailable])
    {
        [self getOfflineCourse];
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:apiOrderNewURL paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [self findBatchSession:jsonData];
        }else{
            [self updateUI];
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
            [self findBatchSession:jsonData];
        } else {
            showAletViewWithMessage(kFailAPI);
        }
    }
    [self updateUI];
    
    
}
-(void) findBatchSession:(id) jsonData {
    if ([jsonData isKindOfClass:[NSArray class]]) {
        NSArray *arr = jsonData;
        if (arr && arr.count>0) {
            [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kUserOrderKey];
            [UserDefault synchronize];
            [arrData removeAllObjects];
            for (NSDictionary *dict in arr) {
                NSMutableDictionary *d = [dict mutableCopy];
                [d handleNullValue];
                UserOrder *order = [[UserOrder alloc] initWith:d];
                if (order) {
                    [arrData addObject:order];
                }
            }
            
            UserOrder *last;
            NSArray* reversedArray = [[arrData reverseObjectEnumerator] allObjects];

            for (UserOrder *order in reversedArray) {
                if (order.line_items.count > 0) {
                    last = order;
                    break;
                }
            }

            if (last && last.line_items.count > 0) {
                OrderDetail *obj = [last.line_items firstObject];
                objEntity = obj;
                if(obj.nearestDate){
                    NSDate *minDate = obj.nearestDate;
                    NSTimeInterval minTimeInterval = [minDate timeIntervalSince1970];
                    
                    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
                    for (UserOrder *last in arrData) {
                        if (last.line_items.count > 0) {
                            OrderDetail *obj = [last.line_items firstObject];
                            if(obj.nearestDate){
                                if( [obj.nearestDate timeIntervalSinceDate:[NSDate date]] > 0 ) {
                                    NSTimeInterval interval = [obj.nearestDate timeIntervalSince1970];
                                    if (fabs(minTimeInterval - current) > fabs(interval - current)) {
                                        minDate = obj.nearestDate;
                                        minTimeInterval = interval;
                                        objEntity = obj;
                                    }
                                }
                            }
                        }
                    }
                    reminderDate = minDate;
                    [self updateTime];
                    [self getLocation];
                    
                }
            }
        }
        [self updateUI];
    }
}
-(void) updateUI {
    [tblParent reloadData];
    if (objEntity == nil) {
        tblParent.hidden = true;
        showAletViewWithMessage(@"Did you subscribe to a Course? No Class session found");
    }else{
        tblParent.hidden = false;
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
