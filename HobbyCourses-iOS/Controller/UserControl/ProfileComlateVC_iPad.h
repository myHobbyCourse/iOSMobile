//
//  ProfileComlateVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileComlateVC_iPad : ParentViewController{
    IBOutlet UIImageView *imgVCircle;
}

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;@end
