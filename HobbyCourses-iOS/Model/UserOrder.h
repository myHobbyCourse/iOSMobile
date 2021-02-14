//
//  UserOrder.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 08/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "OrderDetail.h"

@protocol OrderDetail
@end

@interface UserOrder : NSObject

@property(strong,nonatomic) NSString *order_id;
@property(strong,nonatomic) NSString *created;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *coupon;
@property(strong,nonatomic) NSString *order_total;

@property(strong,nonatomic) NSString *billing_administrative_area;
@property(strong,nonatomic) NSString *billing_city;
@property(strong,nonatomic) NSString *billing_email;
@property(strong,nonatomic) NSString *billing_name_line;
@property(strong,nonatomic) NSString *billing_postal_code;
@property(strong,nonatomic) NSString *billing_premise;
@property(strong,nonatomic) NSString *billing_thoroughfare;
@property(strong,nonatomic) NSString *payment_method;

@property(strong,nonatomic) NSMutableArray <OrderDetail>*line_items;


- (id) initWith:(NSDictionary*)dict ;
@end
