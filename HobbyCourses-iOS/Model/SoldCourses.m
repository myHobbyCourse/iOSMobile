//
//  SoldCourses.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 10/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SoldCourses.h"

@implementation SoldCourses

- (id) initWith:(NSDictionary*)dict {
    self = [super init];
    if (self)
    {
        self.billing_info = dict[@"billing_info"];
        self.buyer = dict[@"buyer"];
        self.buyer_mail = dict[@"buyer_mail"];
        self.buyer_uid = dict[@"buyer_uid"];
        self.coupon = dict[@"coupon"];
        self.created = dict[@"created"];
        self.node_ref = dict[@"node_ref"];
        self.order_id = dict[@"order_id"];
        self.price = dict[@"price"];
        self.quantity = dict[@"quantity"];
        self.status = dict[@"status"];
        self.sum = dict[@"sum"];
        self.title = dict[@"title"];
        self.paypal_payment_id = dict[@"paypal_payment_id"];
        
    }
    return self;
}


@end
