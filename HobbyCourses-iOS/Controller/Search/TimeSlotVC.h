//
//  TimeSlotVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 30/04/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface TimeSlotVC : ParentViewController
@property(strong,nonatomic) Search *searchObj;
@property(strong,nonatomic) NSMutableArray *arrTimes;
//@property (nonatomic, strong) RefreshBlock refreshBlock;

-(void) getRefreshBlock:(RefreshBlock)refreshBlock;


@end
