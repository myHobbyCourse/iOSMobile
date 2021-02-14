//
//  BookingSettingVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 16/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingSettingVC : ParentViewController

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
