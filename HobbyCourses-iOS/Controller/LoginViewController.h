//
//  LoginViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/12/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginViewController : ParentViewController<SA_OAuthTwitterControllerDelegate>
{
    IBOutlet UITextField* tfUserName;
    IBOutlet UITextField* tfPassword;
    SA_OAuthTwitterEngine				*_engine;
    IBOutlet GIDSignInButton *btnGoogle;
}

#pragma mark - Button action

-(IBAction)btnFacebookTapped:(id)sender;
-(IBAction)btnSigninAction:(id)sender;
-(IBAction)btnTwitterTapped:(UIButton*)sender;

@end
