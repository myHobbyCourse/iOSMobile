//
//  LoginViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/12/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<GIDSignInDelegate, GIDSignInUIDelegate>{
    NSString *email;
    NSString *password;
    IBOutlet UIView *viewHeader;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    viewHeader.frame = CGRectMake(0, 0, _screenSize.width, 180 * _heighRatio);
    [FBSDKAccessToken setCurrentAccessToken:nil];
    tfUserName.placeholder = @"Enter Username or Email address";
    
    [GIDSignIn sharedInstance].delegate = self;
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
    if (!is_iPad()) {
        [self performSegueWithIdentifier:@"toTerms" sender:nil];
    }
    

    //tfUserName.text = @"crazywolf181+companystaff@gmail.com";
    //tfPassword.text = @"pass1234!";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self updateToGoogleAnalytics:@"Login Screen"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[ForgotPasswordViewController class]]) {
        ForgotPasswordViewController *vc = segue.destinationViewController;
        [vc getRefreshBlock:^(NSString *anyValue) {
            if ([anyValue isEqualToString:@"Google"]) {
                [self googlePlusButtonTouchUpInside:nil];
            }else if([anyValue isEqualToString:@"Twitter"]) {
                [self btnTwitterTapped:nil];
            }else if([anyValue isEqualToString:@"Facebook"]) {
                [self btnFacebookTapped:nil];
            }
        }];
    }
}
#pragma mark - Google Sign in
- (IBAction)googlePlusButtonTouchUpInside:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    HCLog(@"%@",user);
    if(user)
        [self googleLoginApi:user.authentication.idToken];
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
}
-(void) googleLoginApi:(NSString*) token
{
    [self startActivity];
    NSDictionary *dic = @{@"id_token":token};
    [[NetworkManager sharedInstance] postRequestUrl:apiGoogleLogin paramter:dic withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if([jsonData isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *d = [jsonData mutableCopy];
                [d handleNullValue];
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:d] forKey:kUserInformationKey];
                [UserDefault synchronize];
                APPDELEGATE.userCurrent = [[User alloc]initWith:d];
                [UserDefault setBool:true forKey:kisGoogleLogin];
                
                NSLog(@"%@",APPDELEGATE.userCurrent.token);
                [self getUserProfile];
            }else {
                if ([jsonData isKindOfClass:[NSArray class]])
                {
                    NSArray *arr = (NSArray*) jsonData;
                    if (arr.count > 0) {
                        showAletViewWithMessage(arr[0]);
                    }
                }else{
                    showAletViewWithMessage(@"Something went wrong.");
                }
            }
            
        }else if(result == WebServiceResultError) {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (NSArray*) jsonData;
                if (arr.count > 0)
                {   if ([arr[0] isEqualToString:@"CSRF validation failed"]) {
                    [[ApiService sharedInstance] clearURLCache];
                    [self googleLoginApi:token];
                }else{
                    showAletViewWithMessage(arr[0]);
                }
                }
            }else{
                showAletViewWithMessage(@"Login to myhobby app failed. Check the username and password and try again.");
            }        }else {
            showAletViewWithMessage(@"Are you not who we thought you were? There was an error with your E-Mail/Password combination. Please try again");
        }
    }];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ids = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ids forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            UITextField *tfEmail = [cell viewWithTag:11];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.7] }];
            tfEmail.attributedPlaceholder = str;
        }break;
        case 1:
        {
            UITextField *tfPass = [cell viewWithTag:12];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.7] }];
            tfPass.attributedPlaceholder = str;
        }break;
        case 2:
        {
            UIButton *btnLogin = [cell viewWithTag:31];
            btnLogin.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
            btnLogin.layer.borderWidth = 1;
        }break;
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
#pragma mark- UITextView Delegate
- (IBAction)textViewDidEditing:(UITextField *)textView
{
    if (textView.tag == 11) {
        email = textView.text;
    }else{
        password = textView.text;
    }
    
}

#pragma mark - UIButton methods


- (IBAction)onSignup:(id)sender
{
    [self performSegueWithIdentifier:@"login_signup" sender:nil];
}
-(IBAction)btnSigninAction:(id)sender;
{
    if ([self checkStringValue:email]) {
        showAletViewWithMessage(@"Please enter valid username.");
    }else if([self checkStringValue:password]){
        showAletViewWithMessage(@"Please enter valid password.");
    }else{
        [self loginApi:@{@"mail":email,@"password":password}];
    }
}
#pragma mark - Social logins
-(IBAction)btnTwitterTapped:(UIButton*)sender
{
    if (_engine) _engine = nil;
    _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
    _engine.consumerKey = kOAuthConsumerKey;
    _engine.consumerSecret = kOAuthConsumerSecret;
    
    UIViewController			*controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
    
    if (controller)
        [self presentViewController: controller animated: YES completion: nil];
    else {
        [_engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
    }
    
}
- (IBAction)btnFacebookTapped:(id)sender {
    [self.view endEditing:YES];
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self startActivityWithoutBG];
        [self resquestFacebookUserInformation];
        
    }else{
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
                showAletViewWithMessage([NSString stringWithFormat:@"%@",[error localizedDescription]]);
                [loginManager logOut];
            } else if (result.isCancelled) {
                // Handle cancellations
                [loginManager logOut];
            } else {
                if ([result.grantedPermissions containsObject:@"email"]) {
                    // Do work
                    [self startActivityWithoutBG];
                    [self resquestFacebookUserInformation];
                    
                }
            }
        }];
        
    }
}
#pragma mark Api call
-(void) fbLoginApi:(NSString*) token
{
    NSDictionary *dic = @{@"access_token":token};
    
    [[NetworkManager sharedInstance] postRequestUrl:apiFBUrl paramter:dic withCallback:^(id jsonData, WebServiceResult result)
     {
         if (result == WebServiceResultSuccess)
         {
             if([jsonData isKindOfClass:[NSDictionary class]])
             {
                 NSMutableDictionary *d = [jsonData mutableCopy];
                 [d handleNullValue];
                 [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:d] forKey:kUserInformationKey];
                 [UserDefault synchronize];
                 APPDELEGATE.userCurrent = [[User alloc]initWith:d];
                 [UserDefault setBool:true forKey:kisFBLogin];
                 
                 NSLog(@"%@",APPDELEGATE.userCurrent.token);
                 [self getUserProfile];
             }else{
                 if ([jsonData isKindOfClass:[NSArray class]]) {
                     NSArray *arr = (NSArray*) jsonData;
                     if (arr.count > 0)
                     {
                         showAletViewWithMessage(arr[0]);
                     }
                 }else{
                     showAletViewWithMessage(@"Something went wrong.");
                 }
             }
         }else if(result == WebServiceResultError){
             if ([jsonData isKindOfClass:[NSArray class]])
             {
                 NSArray *arr = (NSArray*) jsonData;
                 if (arr.count > 0)
                 {   if ([arr[0] isEqualToString:@"CSRF validation failed"]) {
                     [[ApiService sharedInstance] clearURLCache];
                     [self fbLoginApi:token];
                 }else{
                     showAletViewWithMessage(arr[0]);
                 }
                 }
             }else{
                 showAletViewWithMessage(@"login failed : sorry an unexpected error occurred, please try again later");
             }
         }else{
             showAletViewWithMessage(@"Are you not who we thought you were? There was an error with your E-Mail/Password combination. Please try again");
         }
     }];
}
-(void) loginApi:(NSDictionary *)dict
{
    if (![self isNetAvailable]) {
        return;
    }
    [self startActivityWithoutBG];
    
    [[NetworkManager sharedInstance] postRequestUrl:apiLoginUrl paramter:dict withCallback:^(NSDictionary *jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if([jsonData isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *d = [jsonData mutableCopy];
                NSLog(@">>>>>>>>>>>>>>.%@",d);
                [d handleNullValue];
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:d] forKey:kUserInformationKey];
                [UserDefault synchronize];
                APPDELEGATE.userCurrent = [[User alloc]initWith:d];
                
                NSLog(@"%@",APPDELEGATE.userCurrent.token);
                [self getUserProfile];
            }else
            {
                if ([jsonData isKindOfClass:[NSArray class]])
                {
                    NSArray *arr = (NSArray*) jsonData;
                    if (arr.count > 0) {
                        showAletViewWithMessage(arr[0]);
                    }
                }else{
                    showAletViewWithMessage(@"Something went wrong.");
                }
                
            }
            
        }else if(result == WebServiceResultError)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (NSArray*) jsonData;
                if (arr.count > 0)
                {   if ([arr[0] isEqualToString:@"CSRF validation failed"]) {
                    [[ApiService sharedInstance] clearURLCache];
                    [self loginApi:dict];
                }else{
                    showAletViewWithMessage(arr[0]);
                }
                }
            }else{
                showAletViewWithMessage(@"Login to myhobby app failed. Check the username and password and try again.");
            }
        }else
        {
            showAletViewWithMessage(@"Are you not who we thought you were? There was an error with your E-Mail/Password combination. Please try again");
        }
        
    }];
    
}
#pragma mark- API Calls Check for profile data
-(void) getUserProfile
{
    [[NetworkManager sharedInstance] postRequestFullUrl:@"http://myhobbycourses.com/myhobbycourses_endpoint/user_details_service/get_info" paramter:nil withCallback:^(id jsonData, WebServiceResult result)
     {
         HCLog(@"%@",jsonData);
         if (result == WebServiceResultSuccess) {
             if ([jsonData isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = jsonData;
                 NSMutableDictionary *d = [dict mutableCopy];
                 [d handleNullValue];
                 userINFO = [[UserDetail alloc]initWith:d];
                 [userINFO getProfileSatus];
             }
         }
         if (APPDELEGATE.userCurrent.isVendor) {
             [self performSegueWithIdentifier:@"segueVendorHome" sender:self];
         }else{
             [self performSegueWithIdentifier:@"GoToCourseList" sender:self];
         }
     }];
}


#pragma mark - Fetch data from FB
-(void)resquestFacebookUserInformation{
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    NSDictionary *params = @{@"fields": @"picture, email,name,gender,first_name,last_name"};
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if (!error) {
            NSDictionary *dicFBResult = result;
            NSLog(@"Result : %@",dicFBResult);
            
            NSString * deviceToken = @"";
            if([UserDefault objectForKey:kUserDeviceTokenKey])
            {
                deviceToken = [UserDefault stringForKey:kUserDeviceTokenKey];
            }
            NSMutableDictionary *parm =[[NSMutableDictionary alloc]init];
            //
            parm[@"emailAddress"] =  (dicFBResult[@"email"]) ? dicFBResult[@"email"] :@"";
            parm[@"fbtoken"] = result[@"id"];
            parm[@"udid"] = getUDID();
            parm[@"vDeviceToken"] = deviceToken;
            parm[@"deviceType"] =  @"iOS";
            NSString *token = [[FBSDKAccessToken currentAccessToken] tokenString];
            [self stopActivity];
            
            [self fbLoginApi:token];
        }else{
            [self stopActivity];
            showAletViewWithMessage([NSString stringWithFormat:@"%@",[error localizedDescription]]);
        }
    }];
}
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: data forKey: @"authData"];
    [defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    NSLog(@"Authenicated for %@", username);
    OAToken* accessToken = [_engine getAccessToken];
    NSString* token = [accessToken key];
    NSString* secret = [accessToken secret];
    [self callServiceToTwiiterLogin:token andSecret:secret];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    NSLog(@"Authentication Canceled.");
}
-(void)callServiceToTwiiterLogin:(NSString*)token andSecret:(NSString*)secret{
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
    [dataDict setObject:token forKey:@"token1"];
    [dataDict setObject:secret forKey:@"token2"];
    [dataDict setObject:@"somename@somedomain.com" forKey:@"email"];
    [self startActivityWithoutBG];
    [[NetworkManager sharedInstance] postRequestUrl:apiTwitterUrl paramter:dataDict withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         if (result == WebServiceResultSuccess)
         {
             if([jsonData isKindOfClass:[NSDictionary class]])
             {
                 NSMutableDictionary *d = [jsonData mutableCopy];
                 [d handleNullValue];
                 [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:d] forKey:kUserInformationKey];
                 [UserDefault synchronize];
                 APPDELEGATE.userCurrent = [[User alloc]initWith:d];
                 
                 NSLog(@"%@",APPDELEGATE.userCurrent.token);
                 [UserDefault setBool:true forKey:kisTwitterLogin];
                 [self getUserProfile];
             }else {
                 if ([jsonData isKindOfClass:[NSArray class]]) {
                     NSArray *arr = (NSArray*) jsonData;
                     if (arr.count > 0) {
                         showAletViewWithMessage(arr[0]);
                     }
                 }else{
                     showAletViewWithMessage(@"Something went wrong.");
                 }
            }
         }else if(result == WebServiceResultError) {
             if ([jsonData isKindOfClass:[NSArray class]]) {
                 NSArray *arr = (NSArray*) jsonData;
                 if (arr.count > 0) {
                     showAletViewWithMessage(arr[0]);
                 }
             }else{
                 showAletViewWithMessage(@"login failed : sorry an unexpected error occurred, please try again later");
             }
         }else {
             showAletViewWithMessage(@"Are you not who we thought you were? There was an error with your E-Mail/Password combination. Please try again");
         }
         
     }];
}


@end
