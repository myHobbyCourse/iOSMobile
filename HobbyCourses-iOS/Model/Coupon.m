//
//  Coupon.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

@synthesize title, created, order, coupon, value;

- (id) initWith:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        
        @try {
            self.Order_ID = dict[@"order_id"];
            self.OrderTitle = dict[@"title"];
            self.OrderCoupon = dict[@"coupon"];
            NSDate *d1 = [global24Formatter() dateFromString:dict[@"created_date"]];
            self.Created_date = [globalDateOnlyFormatter() stringFromDate:d1];

        }
        @catch (NSException *exception) {
            
        }
    }
    return self;
}

@end