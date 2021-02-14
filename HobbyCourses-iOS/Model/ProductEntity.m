//
//  ProductEntity.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 31/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity
- (id) initWith:(NSDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
    
            self.product_id = dict[@"product_id"];
//            self.field_age_group = dict[@"field_age_group"];
//            if (self.field_age_group == nil || [self.field_age_group isEqualToString:@""]) {
//                self.field_age_group = [NSString stringWithFormat:@"%@-%@",dict[@"field_age_group_from"],dict[@"field_age_group_to"]];
//            }
            self.sold = dict[@"sold"];
            if (_isStringEmpty(self.sold)) {
                self.sold = @"0";
            }
            self.quantity = dict[@"quantity"];
            if ([self.quantity integerValue] < 0) {
                self.quantity = @"0";
            }
            if(self.quantity){
                NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
                [formatter setMaximumFractionDigits:0];
                self.quantity =  [formatter stringFromNumber:[NSNumber numberWithDouble:[self.quantity doubleValue]]];
            }

            self.course_start_date = dict[@"course_start_date"];
            self.course_end_date = dict[@"course_end_date"];
            self.sessions_number = dict[@"sessions_number"];
            self.batch_size = dict[@"batch_size"];
            self.status = dict[@"status"];
            self.tutor = dict[@"tutor"];
            self.initial_price = dict[@"price"];
            self.price = dict[@"initial_price"];
            
            self.timings = [[NSMutableArray alloc]init];
            self.timingsDate = [[NSMutableArray alloc]init];
            NSArray *arr = dict[@"timing"];
            if (arr) {
                for(NSDictionary *d in arr) {
                    NSMutableDictionary *ddd = [d mutableCopy];
                    [ddd handleNullValue];
                    [self.timings addObject:ddd];
                    TimeBatch *obj = [[TimeBatch alloc]initWith:ddd];
                    if (obj) {
                        [self.timingsDate addObject:obj];
                    }
                }
            }
            NSArray *sortedArray = [self.timingsDate sortedArrayUsingComparator: ^(TimeBatch *d1, TimeBatch *d2) {
                return [d1.batch_start_date compare:d2.batch_start_date];
            }];
            [self.timingsDate removeAllObjects];
            [self.timingsDate addObjectsFromArray:sortedArray];
            
            NSArray *arrStudent = dict[@"students"];
            self.students = [NSMutableArray new];
            if ([arrStudent isKindOfClass:[NSArray class]]) {
                for (NSDictionary * d in arrStudent) {
                    NSMutableDictionary * dd = [d mutableCopy];
                    [dd handleNullValue];
                    Student * stud = [[Student alloc]initWith:dd];
                    [self.students addObject:stud];
                }
            }
            
        }
        @catch (NSException *exception) { }
    }
    return self;
}

-(BOOL)isEqual:(NSString*)object {
    return self.product_id == object;
}
@end
