//
//  MyReview.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "MyReview.h"

@implementation MyReview

- (id) initWith:(NSDictionary*)dict {
    self = [super init];
    if (self)
    {
        @try {
            
            self.Comment_title = dict[@"comment_title"];
            self.commented_course_title = dict[@"commented_course_title"];
            NSDate *date = [mmm24Formatter() dateFromString:dict[@"updated_date"]];
            if (date) {
                self.updated_date = [f2DIGItYearTimeFormatter() stringFromDate:date];
            }else{
              self.updated_date = dict[@"updated_date"];
            }
            NSDate *date1 = [mmm24Formatter() dateFromString:dict[@"post_date"]];
            if (date) {
                self.post_date = [f2DIGItYearTimeFormatter() stringFromDate:date1];
            }else{
                self.post_date = dict[@"post_date"];
            }
            
            
//            self.post_date = dict[@"post_date"];
//            self.updated_date = dict[@"updated_date"];
            self.commented_nid = dict[@"commented_nid"];
            self.cid = dict[@"cid"];
            self.comment = dict[@"comment"];
            if (dict[@"course_rating"])
            {
                NSString *str = dict[@"course_rating"];
                if (str && ![str isEqualToString:@""]) {
                    NSArray *arr = [str componentsSeparatedByString:@"/"];
                    self.course_rating = arr[0];
                }
            }
            if (dict[@"images"])
            {
                NSArray *arr = dict[@"images"];
                self.arrImages = [[NSMutableArray alloc]init];
                if ([arr isKindOfClass:[NSDictionary class]])
                {
                    [self.arrImages addObject:[arr valueForKey:@"src"]];
                    
                }
                else if ([arr isKindOfClass:[NSArray class]] && arr && arr.count>0)
                {
                    for(NSDictionary *imgDict in arr)
                    {
                        if([imgDict valueForKey:@"src"])
                        {
                            [self.arrImages addObject:[imgDict valueForKey:@"src"]];
                        }
                    }
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        
    }
    return self;
}
@end
