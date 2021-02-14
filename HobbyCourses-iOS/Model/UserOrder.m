//
//  UserOrder.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 08/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "UserOrder.h"
#import "OrderDetail.h"


@implementation UserOrder

- (id) initWith:(NSDictionary*)dict {
    self = [super init];
    if (self)
    {
        @try {
            self.order_id = dict[@"order_id"];
            self.created = dict[@"created"];
            self.status = dict[@"status"];
            self.coupon = dict[@"coupon"];
            
            self.billing_administrative_area = dict[@"billing_administrative_area"];
            self.billing_city = dict[@"billing_city"];
            self.billing_email = dict[@"billing_email"];
            self.billing_name_line = dict[@"billing_name_line"];
            self.billing_postal_code = dict[@"billing_postal_code"];
            self.billing_premise = dict[@"billing_premise"];
            self.billing_thoroughfare = dict[@"billing_thoroughfare"];
            self.payment_method = dict[@"payment_method"];
            self.order_total = dict[@"order_total"];
            NSArray *arr = dict[@"line_items"];
            self.line_items  = [(NSMutableArray<OrderDetail>*)[NSMutableArray alloc]init];
            if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *item in arr) {
                    if ([item isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *d = [item mutableCopy];
                        [d handleNullValue];
                        
                        OrderDetail *order = [[OrderDetail alloc]initWithDict:d];
                        if ([order.nearestDate compare:[NSDate date]] == NSOrderedDescending || [order.nearestDate compare:[NSDate date]] == NSOrderedSame) {
                            [self.line_items addObject:order];
                        }
                        
                    }
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%s",__PRETTY_FUNCTION__);
        }
    }
    return self;
}


@end
