//
//  OrderCoursesViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCoursesViewController : ParentViewController <UITableViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* arrData;
//@property (nonatomic, strong) NSMutableArray *arrSelectedSection;

-(void) syncOrder;

@end
