//
//  PaymentOptionVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 03/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentOptionVC : ParentViewController

@property (nonatomic, strong) RefreshBlock refreshBlock;

-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
