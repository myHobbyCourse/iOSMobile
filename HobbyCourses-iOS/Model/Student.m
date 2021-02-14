//
//  Student.m
//  HobbyCourses
//
//  Created by iOS Dev on 08/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "Student.h"

@implementation Student

- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            self.order_id = dict[@"order_id"];
            self.uid = dict[@"uid"];
            self.name = dict[@"name"];
            self.avatar = dict[@"avatar"];
            self.comment = @"";
            
        }
        @catch (NSException *exception) { }
    }
    return self;
}



@end
