//
//  EditProfileVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 16/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileVC : ParentViewController

@property(assign) NSInteger moveToIndexPath;
@property (nonatomic, strong) RefreshBlock refreshBlock;

-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
