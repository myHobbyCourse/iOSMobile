//
//  Revision.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Revision : NSObject
@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * changed;
@property(strong,nonatomic) NSString * change_date;

@property(strong,nonatomic) RevisionHistoryData *history_data;
@property(strong,nonatomic) NSMutableArray <RevisionHistoryTimings *> *arrHistory_timing;
@property(strong,nonatomic) NSString * start_date;

- (id) initWith:(NSMutableDictionary*)dict;

@end
