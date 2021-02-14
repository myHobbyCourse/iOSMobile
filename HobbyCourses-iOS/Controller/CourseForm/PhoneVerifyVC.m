//
//  PhoneVerifyVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PhoneVerifyVC.h"

@interface PhoneVerifyVC (){
    __weak IBOutlet UILabel * lblRemainingTime;
    __weak IBOutlet UITextField * tfMobile;
    __weak IBOutlet UITextField * tfOTP;
    __weak IBOutlet UIButton * btnEditNo;
    __weak IBOutlet UIButton * btnSave;
    __weak IBOutlet UIView * viewPin;
    __weak IBOutlet UIView * viewBorder;
    NSTimer *timerOTP;
    int counter;
    BOOL isActiveOTP;
}

@end

@implementation PhoneVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    lblCoutryCode.layer.cornerRadius = 5;
    lblCoutryCode.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    lblCoutryCode.layer.borderWidth = 1.0;
    lblRemainingTime.text = @"Confirm your phone number";
    tfMobile.text = userINFO.mobile;
    viewPin.hidden = true;
    btnEditNo.hidden = true;
    isActiveOTP = true;
    [btnSave setTitle:@"Send" forState:UIControlStateNormal];
    viewBorder.layer.borderColor = [UIColor darkGrayColor].CGColor;
    viewBorder.layer.borderWidth = 1.0;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Mobile no verify Screen"];
}

-(IBAction)btnEditNo:(UIButton*)sender {
    viewPin.hidden = true;
    lblRemainingTime.text = @"Confirm your phone number";
    isActiveOTP = true;
    [btnSave setTitle:@"Send" forState:UIControlStateNormal];
    btnEditNo.hidden = true;
    
}
-(IBAction)btnSendOTP:(UIButton*)sender {
    if (isActiveOTP) {
        if (!_isStringEmpty(userINFO.mobile) && ![tfMobile.text isEqualToString:userINFO.mobile]) {
                [AppUtils actionWithMessage:kAppName withMessage:@"Your profile Mobile contact number will be updated with this number. Do you agree?" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
                        [self sendOTP];
                }];
        }else{
            [self sendOTP];
        }
    }else{
        [self verifyOTP];
    }
}

#pragma mark- Other Method
-(void)countDown
{
    if (--counter == 0)
    {
        [timerOTP invalidate];
        lblRemainingTime.text = @"Enter Pin";
        btnEditNo.hidden = false;
    }
    else
        [self updateTimerLabel];
}

-(void)updateTimerLabel
{
    lblRemainingTime.text = [NSString stringWithFormat:@"Please wait for pin %02d:%02d seconds",
                             (int)round(counter/60),counter%60];
}
#pragma mark- API CAll
-(void) sendOTP {
    
    if (_isStringEmpty(tfMobile.text) || tfMobile.text.length < 5) {
        showAletViewWithMessage(@"Please enter valid phone number.");
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiVerify paramter:@{@"mobile":tfMobile.text} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                if ([jsonData[0] isEqualToString:@"Sms with pin code sent"]) {
                    isActiveOTP = false;
                    tfOTP.text = @"";
                    viewPin.hidden = false;
                    [btnSave setTitle:@"Verify" forState:UIControlStateNormal];
                    timerOTP = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown)
                                                              userInfo:nil repeats:YES];
                    counter = 60;
                    [self updateTimerLabel];
                }else{
                    showAletViewWithMessage(jsonData[0]);
                }
            }else{
                showAletViewWithMessage(kFailAPI);
            }
        }
    }];
}
-(void) verifyOTP {
    if (_isStringEmpty(tfOTP.text) || tfMobile.text.length < 2) {
        showAletViewWithMessage(@"Please enter valid pin.");
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiVerify paramter:@{@"pin":tfOTP.text} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                if ([jsonData[0] isEqualToString:@"Pin code is right, thank you!"]) {
                    //Save No in local
                    if (!_isStringEmpty(userINFO.mobile) && ![tfMobile.text isEqualToString:userINFO.mobile]) {
                        [self updateProfileNumber];
                    }else{
                    _refreshBlock(@"Done");
                        [self dismissViewControllerAnimated:true completion:nil];
                    }
                }else{
                    showAletViewWithMessage(jsonData[0]);
                }
            }else{
                showAletViewWithMessage(kFailAPI);
            }
        }
    }];
}
-(void) updateProfileNumber {
    
    [self startActivity];
    NSDictionary *dict = @{@"mail":userINFO.mail,
                           @"field_first_name":userINFO.first_name,
                           @"field_last_name":userINFO.last_name,
                           @"field_phone":tfMobile.text,
                           @"field_company_name":userINFO.company_number,
                           @"field_address":userINFO.address,
                           @"field_address_2":userINFO.address_2,
                           @"field_city":userINFO.city,
                           @"field_postal_code":userINFO.postal_code,
                           @"field_landline_number":userINFO.landline_numbe,
                           @"field_company_number":userINFO.company_number,
                           @"field_vat_registration_number":userINFO.field_vat_registration_number,
                           @"field_description":userINFO.educator_introduction,
                           @"field_site":userINFO.website,
                           @"hobbies":userINFO.hobbiesIds,
                           @"gender":userINFO.gender,
                           @"date_of_birth":userINFO.birthDate,
                           };
    [[NetworkManager sharedInstance] postRequestFullUrl:apiEditUserUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         if (result == WebServiceResultSuccess)
         {
             userINFO.isChangePic = false;
             if (_refreshBlock) {
                 _refreshBlock(@"Done");
                 [self dismissViewControllerAnimated:true completion:nil];
        }
         }else{
             showAletViewWithMessage(@"Fail to update number in profile information.");
         }
     }];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
@end
