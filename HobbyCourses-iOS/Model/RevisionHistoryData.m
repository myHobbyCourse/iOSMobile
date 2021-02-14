//
//  RevisionHistoryData.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RevisionHistoryData.h"

@implementation RevisionHistoryData

- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            self.price = dict[@"price"];
            self.status = dict[@"status"];
            self.start_date = dict[@"start_date"];
            self.end_date = dict[@"end_date"];
            self.sessions = dict[@"sessions"];
            self.batch_size = dict[@"batch_size"];
            self.tutor_name = dict[@"tutor_name"];
            self.field_stock = dict[@"field_stock"];
            self.trial_class = dict[@"trial_class"];
            NSDictionary *d = dict[@"age_group"];
            if ([d isKindOfClass:[NSDictionary class]]) {
                self.age_group = [NSString stringWithFormat:@"%@ - %@",d[@"from"],d[@"to"]];
            }
        }
        @catch (NSException *exception) { }
    }
    return self;
}


@end
