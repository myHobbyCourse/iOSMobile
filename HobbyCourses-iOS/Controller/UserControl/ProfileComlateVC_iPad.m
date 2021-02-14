//
//  ProfileComlateVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ProfileComlateVC_iPad.h"

@interface ProfileComlateVC_iPad ()

@end

@implementation ProfileComlateVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 200;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [userINFO updateSectionStatus];
    [userINFO getProfileSatus];
    [tblParent reloadData];
    if (!APPDELEGATE.isOpenProfile) {
        [self performSelector:@selector(btnBackNav:) withObject:nil afterDelay:0.2];
    }
    int progress = 0;
    if (APPDELEGATE.userCurrent.isVendor) {
        if (!userINFO.isBasic) {progress += 20;}
        if (!userINFO.isProfilePic) {progress += 20;}
        if (!userINFO.isContact) {progress += 15;}
        if (!userINFO.isAddress) {progress += 15;}
        if (!userINFO.isHooby) {progress += 20;}
        if (!userINFO.isCompany) {progress += 20;}
        
    }else{
        if (!userINFO.isBasic) {progress += 20;}
        if (!userINFO.isProfilePic) {progress += 20;}
        if (!userINFO.isContact) {progress += 20;}
        if (!userINFO.isAddress) {progress += 20;}
        if (!userINFO.isHooby) {progress += 20;}
    }
    imgVCircle.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_",progress]];
    [self updateToGoogleAnalytics:@"iPad Profile completeness Screen"];

}
#pragma mark- Button
-(IBAction)btnSelectInfo:(UIButton*)sender {
    NSInteger tapSection = -1;
    switch (sender.tag) {
        case 11:
            tapSection = 1;
            break;
        case 12:
            tapSection = 0;
            break;
        case 13:
            tapSection = 4;
            break;
        case 14:
            tapSection = 6;
            break;
        case 15:
            tapSection = 5;
            break;
        case 16:
            tapSection = 7;
            break;
            
        default:
            break;
    }
    EditProfileVC *vc = [getStoryBoardDeviceBased(StoryboardProfile) instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    vc.moveToIndexPath = tapSection;
    [vc getRefreshBlock:^(NSString *anyValue) {
        [self btnBackNav:nil];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark- Custom
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
-(IBAction)btnBackNav:(id)sender {
    if (_refreshBlock) {
        _refreshBlock(@"");
    }
    [self.navigationController popViewControllerAnimated:false];
}

#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:(APPDELEGATE.userCurrent.isVendor) ? @"Cell1" : @"Cell2"  forIndexPath:indexPath];
    UIImageView *imgV1 = [cell viewWithTag:21];
    UIImageView *imgV2 = [cell viewWithTag:22];
    UIImageView *imgV3 = [cell viewWithTag:23];
    UIImageView *imgV4 = [cell viewWithTag:24];
    UIImageView *imgV5 = [cell viewWithTag:25];
    UIImageView *imgV6 = [cell viewWithTag:26];
    
    if (userINFO.isBasic) {
        imgV1.image = [UIImage imageNamed:@"ic_p_unfill_circle"];
    }else{
        imgV1.image = [UIImage imageNamed:@"ic_p_fill_circle"];
    }
    
    if (userINFO.isProfilePic) {
        imgV2.image = [UIImage imageNamed:@"ic_p_unfill_circle"];
    }else{
        imgV2.image = [UIImage imageNamed:@"ic_p_fill_circle"];
    }
    
    if (userINFO.isContact) {
        imgV3.image = [UIImage imageNamed:@"ic_p_unfill_circle"];
    }else{
        imgV3.image = [UIImage imageNamed:@"ic_p_fill_circle"];
    }
    
    if (userINFO.isAddress) {
        imgV4.image = [UIImage imageNamed:@"ic_p_unfill_circle"];
    }else{
        imgV4.image = [UIImage imageNamed:@"ic_p_fill_circle"];
    }
    if (APPDELEGATE.userCurrent.isVendor) {
        if (userINFO.isCompany) {
            imgV5.image = [UIImage imageNamed:@"ic_p_unfill_circle"];
        }else{
            imgV5.image = [UIImage imageNamed:@"ic_p_fill_circle"];
        }
    }
    
    if (userINFO.isHooby) {
        imgV6.image = [UIImage imageNamed:@"ic_p_unfill_circle"];
    }else{
        imgV6.image = [UIImage imageNamed:@"ic_p_fill_circle"];
    }
    return cell;
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
