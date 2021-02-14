//
//  Review.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/17/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "Review.h"

@implementation Review

@synthesize user, rate, title, text;

- (id) initWith:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        @try
        {
            self.subject = dict[@"subject"];
            self.author = dict[@"author"];
            if (_isStringEmpty(self.author)) {
                self.author = dict[@"comment_author"];
            }
            self.author_uid = dict[@"comment_author_uid"];
            self.comment = dict[@"comment"];
            self.commented_nid = dict[@"commented_node_nid"];
            if (self.commented_nid == nil) {
                self.commented_nid = dict[@"commented_nid"];
            }
            self.post_date = dict[@"post_date"];
            if (_post_date == nil) {
                if (dict[@"created"]) {
                    self.post_date = dict[@"created"];
                }
            }
            self.commented_node_title = dict[@"commented_node_title"];
            NSArray *arr = [dict[@"course_rating"] componentsSeparatedByString:@"/"];
            
            NSArray *arrImg = dict[@"images"];
            self.imagesArr = [[NSMutableArray alloc]init];
            if ([arrImg isKindOfClass:[NSArray class]] && arrImg && arrImg.count>0)
            {
                for(NSDictionary *imgDict in arrImg)
                {
                    if([imgDict valueForKey:@"src"])
                    {
                        [self.imagesArr addObject:[imgDict valueForKey:@"src"]];
                    }
                }
                
            }else if([arrImg isKindOfClass:[NSDictionary class]])
            {
                    if([(NSDictionary*)arrImg valueForKey:@"src"])
                    {
                        [self.imagesArr addObject:[arrImg valueForKey:@"src"]];
                    }
            }
            
            self.avatar = dict[@"avatar"];
            //rating arr
            if (arr && arr.count>0)
            {
                NSString *str = [NSString stringWithFormat:@"%@",arr[0]];
                self.course_rating = str.floatValue;
            }else{
                self.course_rating = 3.0f;
            }
            

        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
       
    }
    return self;
}

@end
