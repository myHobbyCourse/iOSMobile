//
//  ShoppingCart.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ShoppingCart.h"

@implementation ShoppingCart

@synthesize course, price, count;

- (id) init {
    self = [super init];
    if (self) {
        course = [[Course alloc] init];
        price = 200;
        count = 0;
    }
    return self;
}

@end
