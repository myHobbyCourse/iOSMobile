//
//  Attendance.m
//  HobbyCourses
//
//  Created by iOS Dev on 08/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "Attendance.h"

@implementation Attendance
- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            self.ID = dict[@"id"];
            self.product_id = dict[@"product_id"];
            self.course_title = dict[@"course_title"];
            self.uid_owner = dict[@"uid_owner"];
            self.uid_student = dict[@"uid_student"];
            self.student_name = dict[@"student_name"];
            self.register_date = dict[@"register_date"];
            self.course_time_start = dict[@"course_time_start"];
            self.course_time_end = dict[@"course_time_end"];
            self.attendance = dict[@"attendance"];
            self.late = dict[@"late"];
            self.comment = dict[@"comment"];
            self.student_avatar = dict[@"student_avatar"];
            if (self.course_time_start) {
                double timestampval =  [self.course_time_start doubleValue]/1000;
                NSTimeInterval timestamp = (NSTimeInterval)timestampval;
                //NSNumber *startTime = [NSNumber numberWithInt:[self.course_time_start intValue]];
                NSDate *d = [NSDate dateWithTimeIntervalSince1970:timestamp];
                self.strDay = [globalDAYFormatter() stringFromDate:d];
            }
            
            

        }
        @catch (NSException *exception) { }
    }
    return self;
}
@end
