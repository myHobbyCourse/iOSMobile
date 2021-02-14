//
//  ScheduleList+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ScheduleList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScheduleList (CoreDataProperties)

+ (NSFetchRequest<ScheduleList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString * sessionId;
@property (nullable, nonatomic, copy) NSDate *sessionStart;
@property (nullable, nonatomic, copy) NSDate *sessionEnd;
@property (nullable, nonatomic, copy) NSDate *sessionDate;
@property (nullable, nonatomic, copy) NSString *classId;
@property (nullable, nonatomic, retain) ClassList *classList;

@end

NS_ASSUME_NONNULL_END
