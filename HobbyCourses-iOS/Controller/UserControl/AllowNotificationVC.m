//
//  AllowNotificationVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AllowNotificationVC.h"

@interface AllowNotificationVC ()

@end

@implementation AllowNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    btnSkip.layer.borderColor = [UIColor whiteColor].CGColor;
    btnSkip.layer.borderWidth = 1.0;
    [DefaultCenter addObserver:self selector:@selector(registerPushAPI) name:@"pushCallBack" object:nil];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Allow Notification Screen"];
}

-(void) registerPushAPI {
    if (![self checkStringValue:APPDELEGATE.deviceTokenReg]) {
        NSDictionary *dict = @{@"type":@"ios",@"token":APPDELEGATE.deviceTokenReg};
        if (![UserDefault boolForKey:@"isPushSet"])
        {
            [self startActivity];
            [[NetworkManager sharedInstance] postRequestUrl:apiPush paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
                [self stopActivity];
                if (result == WebServiceResultSuccess)
                {
                    [UserDefault setBool:true forKey:@"isPushSet"];
                }
                [self parentDismiss:nil];
            }];
        }else{
            [self parentDismiss:nil];
        }
    }

}


-(IBAction)btnNotifiy:(UIButton*)sender {
    [APPDELEGATE registerPushNotification];
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
