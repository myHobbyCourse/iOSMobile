//
//  OrderVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 25/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderVC : ParentViewController <UITableViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* arrData;
@property (nonatomic, strong) NSMutableArray *arrSelectedSection;



@end
