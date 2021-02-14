//
//  OrderDetail.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 17/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "OrderDetail.h"

@implementation OrderDetail

- (id) initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self)
    {
        @try {
            self.seller_uid = dict[@"seller_uid"];
            self.price = dict[@"price"];
            self.quantity = dict[@"quantity"];
            if(self.quantity){
                NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
                [formatter setMaximumFractionDigits:0];
                self.quantity =  [formatter stringFromNumber:[NSNumber numberWithDouble:[self.quantity doubleValue]]];
            }

            self.title = dict[@"title"];
            self.product_id = dict[@"product_id"];
            self.start_date = dict[@"start_date"];
            self.end_date = dict[@"end_date"];
            NSArray * arr = dict[@"timing"];

            self.seller = dict[@"seller"];
            self.seller_address = dict[@"seller_address"];
            self.seller_address_2 = dict[@"seller_address_2"];
            self.seller_city = dict[@"seller_city"];
            self.seller_company_name = dict[@"seller_company_name"];
            self.seller_landline_number = dict[@"seller_landline_number"];

            self.seller_phone = dict[@"seller_phone"];
            self.seller_postal_code = dict[@"seller_postal_code"];
            self.seller_mail = dict[@"mail"];
            self.course_address = dict[@"course_address"];

            self.sessions_number = dict[@"sessions_number"];
            self.sold = dict[@"sold"];
            self.batch_size = dict[@"batch_size"];

            self.sum = dict[@"sum"];
            self.timing  = [(NSMutableArray<TimeBatch>*)[NSMutableArray alloc]init];
            
            
            if ([arr isKindOfClass:[NSArray class]]) {
                if (arr.count > 0) {
                    for (NSDictionary * time in arr) {
                        NSMutableDictionary * d = [time mutableCopy];
                        [d handleNullValue];
                        TimeBatch * obj = [[TimeBatch alloc]initWith:d];
                        [self.timing addObject:obj];
                        
                    }
                    TimeBatch *last =  [self.timing lastObject];
                    NSDate *minDate = last.batch_start_date;
                    NSDate *maxDate = last.batch_end_date;
                    NSTimeInterval minTimeInterval = [minDate timeIntervalSince1970];
                    
                    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
                    for (TimeBatch *obj in self.timing) {
                        if( [obj.batch_start_date timeIntervalSinceDate:[NSDate date]] > 0 ) {
                            NSTimeInterval interval = [obj.batch_start_date timeIntervalSince1970];
                            if (fabs(minTimeInterval - current) > fabs(interval - current)) {
                                minDate = obj.batch_start_date;
                                maxDate = obj.batch_end_date;
                                minTimeInterval = interval;
                            }
                        }
                    }
                    
                    self.nearestDate = minDate;
                    self.nearestDateEnd = maxDate;
                }
            }
            
        }
        @catch (NSException *exception) {
        }
    }
    return self;
}

@end
