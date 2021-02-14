//
//  ForgotPasswordViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/12/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : ParentViewController
{
    IBOutlet UIView *viewHeader;
}
@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

-(IBAction)btnSendPass:(id)sender;
@end
