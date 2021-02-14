//
//  SingUpVC_ipad.h
//  HobbyCourses
//
//  Created by iOS Dev on 02/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingUpVC_ipad : ParentViewController
{
    IBOutlet UIView *viewLeaner;
    IBOutlet UIView *viewTutor;
    
    IBOutlet UITableView *tblLeft;
    IBOutlet UITableView *tblRight;
    
    IBOutlet UIButton *btnCustomer;
    IBOutlet UIButton *btnEducator;
    
    IBOutlet UIButton *btnSingUp;
    IBOutlet NSLayoutConstraint *_topConstraint;

    __weak IBOutlet UIButton *btnIChargeByHour;
    
    __weak IBOutlet UIView *viewTutorial;

    __weak IBOutlet UIButton *btnCourseWithMutipleSession;
    
}
@property(nonatomic,strong) UserDetail *userdetail;


-(IBAction)btnTypeOption:(UIButton*)sender;
@end
