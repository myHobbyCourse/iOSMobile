//
//  RevisionHistoryTimings.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RevisionHistoryTimings.h"

@implementation RevisionHistoryTimings

- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            self.start = dict[@"start"];
            self.end = dict[@"end"];
            self.title = dict[@"title"];
        }
        @catch (NSException *exception) { }
    }
    return self;
}


@end
