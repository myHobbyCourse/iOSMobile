//
//  AllowLocationVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 30/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AllowLocationVC.h"

@interface AllowLocationVC ()

@end

@implementation AllowLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Location Permistion Screen"];
}
-(IBAction)btnLocateMe:(UIButton*)sender {
    [[UserLocation sharedInstance] fetchUserLocationForOnce:self block:^(CLLocation * loc, NSError * errror) {
        _refreshBlock(@"REquested");
        [[MyLocationManager sharedInstance] getCurrentLocation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
-(void)parentDismiss:(UIButton *)sender{
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Are you sure!!" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            _refreshBlock(@"REquested");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
    
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
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
