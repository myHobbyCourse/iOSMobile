//
//  SoldCourses.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 10/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoldCourses : NSObject

@property(strong,nonatomic) NSString *billing_info;
@property(strong,nonatomic) NSString *buyer;
@property(strong,nonatomic) NSString *buyer_mail;
@property(strong,nonatomic) NSString *buyer_uid;
@property(strong,nonatomic) NSString *coupon ;
@property(strong,nonatomic) NSString *created;
@property(strong,nonatomic) NSString *node_ref;
@property(strong,nonatomic) NSString *order_id;
@property(strong,nonatomic) NSString *price ;
@property(strong,nonatomic) NSString *quantity;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *sum;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *paypal_payment_id;


- (id) initWith:(NSDictionary*)dict ;

@end
