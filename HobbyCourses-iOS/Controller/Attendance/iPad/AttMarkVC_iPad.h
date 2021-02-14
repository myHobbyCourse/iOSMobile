//
//  AttMarkVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 20/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttMarkVC_iPad : ParentViewController

@property(strong,nonatomic) ProductEntity *product;
@property(strong,nonatomic) CourseSchedule *courseSchedule;

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) refreshBlock:(RefreshBlock)deleteBlock;

@end
