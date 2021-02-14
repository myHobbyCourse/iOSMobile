//
//  TimeBatch.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 03/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TimeBatch.h"

@implementation TimeBatch
@synthesize sessionId;
- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            self.batch_start_date = [global24Formatter() dateFromString:dict[@"value"]];
            self.batch_end_date = [global24Formatter() dateFromString:dict[@"value2"]];
            NSString *strDate = [globalDateFormatter() stringFromDate:self.batch_start_date];
            self.dayName = [globalDAYFormatter() stringFromDate:self.batch_start_date];
            self.sDate = [globalDateFormatter() dateFromString:strDate];
            self.class_name = dict[@"class_name"];
            self.sessionId = GetTimeStampString;

        }
        @catch (NSException *exception) { }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.batch_start_date forKey:@"batch_start_date"];
    [encoder encodeObject:self.batch_end_date forKey:@"batch_end_date"];
    [encoder encodeObject:self.sDate forKey:@"sDate"];

    
}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.batch_start_date  = [decoder decodeObjectForKey:@"batch_start_date"];
        self.batch_end_date  = [decoder decodeObjectForKey:@"batch_end_date"];
        self.sDate  = [decoder decodeObjectForKey:@"sDate"];
    }
    return self;
}

@end
