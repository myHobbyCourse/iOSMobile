//
//  ScheduleList+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ScheduleList+CoreDataProperties.h"

@implementation ScheduleList (CoreDataProperties)

+ (NSFetchRequest<ScheduleList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ScheduleList"];
}

@dynamic classId;
@dynamic sessionStart;
@dynamic sessionEnd;
@dynamic sessionDate;
@dynamic classList;

@end
