//
//  Course.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/13/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "Course.h"

@implementation Course

- (id) initWith:(NSDictionary*)dict {
    self = [super init];
    if (self) {
       
        self.currentPage = 1;
        @try {
            self.nid = dict[@"nid"];
            self.title = dict[@"title"];
            self.post_date = dict[@"post_date"];
            NSDictionary *dictAdd = dict[@"address"];
            self.address_1 = dictAdd[@"thoroughfare"];
            self.address_2 = dictAdd[@"premise"];

            self.author = dict[@"author"];
            self.city = dict[@"city"];
            self.category = dict[@"category"];
            self.sub_category = dict[@"sub_category"];
            self.trial_class = dict[@"trial_class"];
            self.offer_valid_from = dict[@"offer_valid_from"];
            self.offer_valid_until = dict[@"offer_valid_until"];
            self.guarantee = dict[@""];
            NSArray *arr = dict[@"images"];
            self.images = [[NSMutableArray alloc]init];
            if ([arr isKindOfClass:[NSArray class]]) {
                [self.images addObjectsFromArray:arr];
            }else if([arr isKindOfClass:[NSString class]]){
                [self.images addObject:arr];
            }
            self.comment_count = dict[@"comment_count"];
            self.descriptions = dict[@"Description"];
            if (self.descriptions == nil) {
                self.descriptions = dict[@"description"];
            }
            self.commerce_price = dict[@"commerce_price"];
        
            self.latitude = dict[@"latitude"];
            self.longitude = dict[@"longitude"];
            
            self.requirements = dict[@"requirements"];
            if (![self.requirements isKindOfClass:[NSNull class]]) {
                self.requirements = self.requirements.removeHTML;
            }
            self.path = dict[@"path"];
            self.daytime = dict[@"daytime"];
            self.productArr = [[NSMutableArray alloc]init];
            NSArray *arrValue = dict[@"products"];
            if ([arrValue isKindOfClass:[NSArray class]]) {
                for (NSMutableDictionary *dict in arrValue) {
                    NSMutableDictionary *d = [dict mutableCopy];
                    [d handleNullValue];
                    ProductEntity * entity = [[ProductEntity alloc]initWith:d];
                    if (entity) {
                        [self.productArr addObject:entity];
                    }
                }
            }else{
                NSArray *arrValue = dict[@"timing"];
                if ([arrValue isKindOfClass:[NSArray class]]) {
                    NSMutableDictionary *d = [dict mutableCopy];
                    [d handleNullValue];
                    ProductEntity * entity = [[ProductEntity alloc]initWith:d];
                    if (entity) {
                        [self.productArr addObject:entity];
                    }
                }

            }
        }
        @catch (NSException *exception)
        {
            
        }
    }
    return self;
}

@end
