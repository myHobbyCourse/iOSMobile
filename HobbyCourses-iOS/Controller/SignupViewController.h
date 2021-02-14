//
//  SignupViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/12/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : ParentViewController
{
    IBOutlet UIView *viewCustomer;
    IBOutlet UIView *viewEducator;

    __weak IBOutlet UIView *viewTutor;
    IBOutlet UIButton *btnCustomer;
    IBOutlet UIButton *btnEducator;
  
    __weak IBOutlet UIButton *btnIChargeByHour;
    __weak IBOutlet UIButton *btnCourseWithMutipleSession;
}
@property(nonatomic,strong) UserDetail *userdetail;


-(IBAction)btnTypeOption:(UIButton*)sender;


@end
