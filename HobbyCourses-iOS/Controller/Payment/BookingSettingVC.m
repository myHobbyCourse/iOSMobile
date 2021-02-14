//
//  BookingSettingVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 16/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "BookingSettingVC.h"

@interface BookingSettingVC (){
    NSMutableArray *attTitle;
    NSMutableArray *selectedIndexes;
    
    IBOutlet UIButton *btnNext;
}

@end

@implementation BookingSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 80;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    attTitle = [NSMutableArray new];
    selectedIndexes = [NSMutableArray new];
    [attTitle addObject:@"Confirmed email and phone number"];
    [attTitle addObject:@"Profile info"];
    [attTitle addObject:@"Agree to your class rules"];
    [attTitle addObject:@"Payent information"];
   // [attTitle addObject:@"Course Rules"];
    [selectedIndexes addObject:[NSIndexPath indexPathForRow:4 inSection:0]];

    [userINFO updateSectionStatus];
    if (!userINFO.isContact) {
        [selectedIndexes addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
    if (!userINFO.isAddress) {
        [selectedIndexes addObject:[NSIndexPath indexPathForRow:2 inSection:0]];
    }
    if (is_iPad()) {
        tblParent.layer.borderColor = __THEME_lightGreen.CGColor;
        tblParent.layer.borderWidth = 1.0;
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Booking Settings Screen"];
}
-(void) getUserProfile
{
    if (![self isNetAvailable]) {
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:@"http://myhobbycourses.com/myhobbycourses_endpoint/user_details_service/get_info" paramter:nil withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         NSLog(@"%@",jsonData);
         if (result == WebServiceResultSuccess) {
             if ([jsonData isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = jsonData;
                 NSMutableDictionary *d = [dict mutableCopy];
                 [d handleNullValue];
                 userINFO = [[UserDetail alloc]initWith:d];
                 NSData *data = [UserDefault objectForKey:kUserInformationKey];
                 NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                 NSDictionary *user = [retrievedDictionary[@"user"] mutableCopy];
                 id obj = user[@"picture"];
                 if ([obj isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *picDict = obj[@"picture"];
                     [picDict setValue:userINFO.user_picture forKey:@"url"];
                     [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:retrievedDictionary] forKey:kUserInformationKey];
                     [UserDefault synchronize];
                 }
                 [self.view layoutIfNeeded];
                 [userINFO updateSectionStatus];
                 if (!userINFO.isContact) {
                     [selectedIndexes addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
                 }
                 if (!userINFO.isAddress) {
                     [selectedIndexes addObject:[NSIndexPath indexPathForRow:2 inSection:0]];
                 }
                 [tblParent reloadData];
             }
         }
     }];
}

-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
-(IBAction)btnBackNav:(UIButton*)sender {
    if (sender.tag == 555) {
        if (userINFO.isContact) {
            [AppUtils actionWithMessage:kAppName withMessage:@"Please update your contact number" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
                EditProfileVC *vc = [getStoryBoardDeviceBased(StoryboardProfile) instantiateViewControllerWithIdentifier:@"EditProfileVC"];
                vc.moveToIndexPath = 4;
                [vc getRefreshBlock:^(NSString *anyValue) {
                    [self getUserProfile];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }else if(userINFO.isAddress){
            [AppUtils actionWithMessage:kAppName withMessage:@"Please update your Firstname,lastname and address" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
                EditProfileVC *vc = [getStoryBoardDeviceBased(StoryboardProfile) instantiateViewControllerWithIdentifier:@"EditProfileVC"];
                vc.moveToIndexPath = 5;
                [vc getRefreshBlock:^(NSString *anyValue) {
                    [self getUserProfile];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }];

        }else if(![selectedIndexes containsObject:[NSIndexPath indexPathForRow:3 inSection:0]]){
            showAletViewWithMessage(@"Let’s get along, you must agree to Tutor Class Rules.");
        } else{
            _refreshBlock(@"");
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else{
        [self.navigationController popViewControllerAnimated:NO];

    }
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (is_iPad()) {
        if (indexPath.row == 0 || indexPath.row == 5) {
            return 0;
        }
        return 70;
    }
    
    if (indexPath.row == 5) {
        return 80;
    }
    
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    if (indexPath.row == 0) {
        cellIdentifier = @"Cell0";
    }else{
        cellIdentifier = @"Cell1";
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row != 0) {
        UILabel *lbl = [cell viewWithTag:11];
        UIImageView *imgV = [cell viewWithTag:12];
        lbl.text = attTitle[indexPath.row - 1];
        if (indexPath.row == 5) {
            imgV.image = [UIImage imageNamed:@"ic_right_forward"];
            imgV.tintColor = __THEME_GRAY;
        }else{
            if ([selectedIndexes containsObject:indexPath]) {
                imgV.image = [UIImage imageNamed:(is_iPad()) ? @"ic_setting_tick":@"ic_p_tick"];
            }else{
                imgV.image = [UIImage imageNamed:(is_iPad()) ? @"ic_setting_cross": @"ic_p_close"];
            }
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if ([selectedIndexes containsObject:indexPath]) {
            [selectedIndexes removeObject:indexPath];
        }else{
            [selectedIndexes addObject:indexPath];
        }
        [tblParent reloadData];
    }else if(![selectedIndexes containsObject:indexPath] && indexPath.row == 1){
        [AppUtils actionWithMessage:kAppName withMessage:@"Please update your contact number" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
            EditProfileVC *vc = [getStoryBoardDeviceBased(StoryboardProfile) instantiateViewControllerWithIdentifier:@"EditProfileVC"];
            vc.moveToIndexPath = 4;
            [vc getRefreshBlock:^(NSString *anyValue) {
                [self getUserProfile];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else if(![selectedIndexes containsObject:indexPath] && indexPath.row == 2){
        [AppUtils actionWithMessage:kAppName withMessage:@"Please update your Firstname,lastname and address" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
            EditProfileVC *vc = [getStoryBoardDeviceBased(StoryboardProfile) instantiateViewControllerWithIdentifier:@"EditProfileVC"];
            vc.moveToIndexPath = 5;
            [vc getRefreshBlock:^(NSString *anyValue) {
                [self getUserProfile];
            }];
            [self.navigationController pushViewController:vc animated:YES];
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
