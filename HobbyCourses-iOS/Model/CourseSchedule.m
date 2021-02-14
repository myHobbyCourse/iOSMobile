//
//  CourseSchedule.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseSchedule.h"

@implementation CourseSchedule


- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            
            self.nid = dict[@"nid"];
            self.title = dict[@"title"];
            self.author = dict[@"author"];
            self.post_date = dict[@"post_date"];
            self.author_uid = dict[@"author_uid"];
            self.city = dict[@"city"];
            self.arrProducts = [NSMutableArray new];
            NSArray *arr = dict[@"products"];
            if ([arr isKindOfClass:[NSArray class]]) {
                for (NSDictionary *d in arr) {
                    ProductEntity * obj = [[ProductEntity alloc] initWith:d];
                    if (obj.students.count > 0){
                        [self.arrProducts addObject:obj];
                    }
                }
            }
            self.field_deal_image = [[NSMutableArray alloc]init];
            NSArray *images = dict[@"field_deal_image"];
            if ([images isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in images) {
                    NSMutableDictionary *d = [dict mutableCopy];
                    [d handleNullValue];
                    [self.field_deal_image addObject:d[@"src"]];
                }
            }
        }
        @catch (NSException *exception) { }
    }
    return self;
}



@end
