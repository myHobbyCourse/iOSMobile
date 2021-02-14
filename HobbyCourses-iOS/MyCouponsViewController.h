//
//  MyCouponsViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponsViewController : ParentViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic)  NSMutableArray* arrData;

-(void) getMyCoupan;

@end
