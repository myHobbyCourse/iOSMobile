//
//  Coupon.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property (nonatomic, strong)   NSString* title;
@property (nonatomic, strong)   NSString* created;
@property (nonatomic, strong)   NSString* order;
@property (nonatomic, strong)   NSString* coupon;
@property (nonatomic)           NSInteger value;

@property (nonatomic, strong)   NSString* Order_ID;
@property (nonatomic, strong)   NSString* OrderTitle;
@property (nonatomic, strong)   NSString* OrderCoupon;
@property (nonatomic, strong)   NSString* Created_date;

- (id) initWith:(NSDictionary*)dict ;

@end