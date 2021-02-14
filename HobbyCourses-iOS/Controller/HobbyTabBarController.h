//
//  HobbyTabBarController.h
//  HobbyCourses
//
//  Created by iOS Dev on 14/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HobbyTabBarController : UITabBarController<UITabBarControllerDelegate>

-(void) selectTab:(NSInteger) idx;
@end
