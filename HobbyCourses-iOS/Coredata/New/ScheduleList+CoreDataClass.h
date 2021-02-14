//
//  ScheduleList+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CourseForm+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleList : NSManagedObject

+(void) insertOrUpdate:(TimeBatch *) timeBatch classRow:(NSString*) rowID;
+(ScheduleList*) getObjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteSchedule:(NSString*) rowKey;
+(NSArray*) getAllSchedules;

@end

NS_ASSUME_NONNULL_END

#import "ScheduleList+CoreDataProperties.h"
