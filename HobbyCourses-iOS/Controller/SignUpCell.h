//
//  SignUpCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 24/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignupViewController.h"
#import "SingUpVC_ipad.h"

@class SignupViewController,SingUpVC_ipad;


@interface SignUpCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UITextField *tfInput;
@property(weak,nonatomic) SignupViewController *controller;
@property(weak,nonatomic) SingUpVC_ipad *controller_iPAD;

@end
