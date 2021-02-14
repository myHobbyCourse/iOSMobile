//
//  OrderDetail.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 17/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeBatch.h"
@protocol TimeBatch
@end

@interface OrderDetail : NSObject

@property(strong,nonatomic) NSString *seller;
@property(strong,nonatomic) NSString *seller_address;
@property(strong,nonatomic) NSString *seller_address_2;
@property(strong,nonatomic) NSString *seller_city;
@property(strong,nonatomic) NSString * seller_company_name;
@property(strong,nonatomic) NSString *seller_landline_number;
@property(strong,nonatomic) NSString *seller_phone;
@property(strong,nonatomic) NSString *seller_postal_code;
@property(strong,nonatomic) NSString *seller_mail;
@property(strong,nonatomic) NSString *seller_uid;
@property(strong,nonatomic) NSString *price;
@property(strong,nonatomic) NSString *quantity;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *product_id;
@property(strong,nonatomic) NSString *node_ref;
@property(strong,nonatomic) NSString *start_date;
@property(strong,nonatomic) NSString *end_date;
@property(strong,nonatomic) NSString *sum;
@property(strong,nonatomic) NSString *course_address;
@property(strong,nonatomic) NSDate *nearestDate;
@property(strong,nonatomic) NSDate *nearestDateEnd;

@property(strong,nonatomic) NSString *sold;
@property(strong,nonatomic) NSString *batch_size;
@property(strong,nonatomic) NSString *sessions_number;


@property(strong,nonatomic) NSMutableArray <TimeBatch>*timing;
- (id) initWithDict:(NSDictionary*)dict;
@end
