//
//  FavCourse.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FavCourse.h"

@implementation FavCourse

- (id) initWith:(NSMutableDictionary*)dict {
    self = [super init];
    if (self)
    {
        @try {
            self.title = dict[@"title"];
            self.nid = dict[@"nid"];
            self.review_count = dict[@"review_count"];
            self.price = dict[@"price"];
            self.city = dict[@"city"];
            self.author = dict[@"author"];
            self.author_avatar = dict[@"author_avatar"];
            self.vote_result = dict[@"vote_result"];
            if ([self.vote_result isKindOfClass:[NSString class]]) {
                if (self.vote_result.length > 0) {
                    NSArray *arr = [self.vote_result componentsSeparatedByString:@"/"];
                    self.vote_result = (arr.count > 0) ? arr[0] : @"0";
                }
            }
            
            NSDictionary * imgDict = dict[@"image"];
            if ([imgDict isKindOfClass:[NSDictionary class]])
            {
                self.image = [imgDict valueForKey:@"src"];
                
            }
            self.lastUpdate = @"";
            if (dict[@"node_created"]) {
                double timestampval =  [dict[@"node_created"] doubleValue];
                NSTimeInterval timestamp = (NSTimeInterval)timestampval;
                NSDate *updatetimestamp = [NSDate dateWithTimeIntervalSince1970:timestamp];
                self.lastUpdate = [f2DIGItYearTimeFormatter() stringFromDate:updatetimestamp];
            }
            
            
        }
        @catch (NSException *exception) {
            
        }
        
    }
    return self;
    
}


@end
