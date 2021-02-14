//
//  Revision.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "Revision.h"

@implementation Revision

- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            
            self.title = dict[@"title"];
            self.start_date = dict[@"start_date"];
            self.changed = dict[@"changed"];
            if (self.changed) {
                double timestampval =  [self.changed doubleValue];
                NSTimeInterval timestamp = (NSTimeInterval)timestampval;
                NSDate *dd = [NSDate dateWithTimeIntervalSince1970:timestamp];
                self.change_date = [NSString stringWithFormat:@"%@",[ddMMMyyhhmma() stringFromDate:dd]];
            }else{
                self.change_date = [NSString stringWithFormat:@"%@",[ddMMMyyhhmma() stringFromDate:[NSDate date]]];;
            }
            
            //Timing
            NSArray * arrTimings = dict[@"history_timing"];
            self.arrHistory_timing = [NSMutableArray new];
            for (NSMutableDictionary *timeDict in arrTimings) {
                RevisionHistoryTimings *timings = [[RevisionHistoryTimings alloc]initWith:timeDict];
                if (timings){
                    [self.arrHistory_timing addObject:timings];
                }
            }
            //History Data
            NSDictionary *historyDict = dict[@"history_data"];
            if ([historyDict isKindOfClass:[NSDictionary class]]) {
                self.history_data = [[RevisionHistoryData alloc]initWith:dict[@"history_data"]];
            }
            
        }
        @catch (NSException *exception) { }
    }
    return self;
}


@end
