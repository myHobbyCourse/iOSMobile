//
//  PhoneVerifyVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 06/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneVerifyVC : ParentViewController{
    IBOutlet UILabel *lblCoutryCode;
}
@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
