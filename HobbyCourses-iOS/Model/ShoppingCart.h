//
//  ShoppingCart.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

@interface ShoppingCart : NSObject

@property (nonatomic, strong) Course* course;
@property (nonatomic) int price;
@property (nonatomic) int count;

@end
