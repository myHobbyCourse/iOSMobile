//
//  LocationPopUpViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationPopUpViewController : ParentViewController
{
    IBOutlet UIView *viewBGWhite;
    IBOutlet UIButton *btnApply;
    IBOutlet UITextField *tfPincode;
    
}
-(IBAction)btnSkip:(id)sender;
-(IBAction)btnApplyAction:(id)sender;
@end
