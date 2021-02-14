//
//  ClassList+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ClassList+CoreDataProperties.h"

@implementation ClassList (CoreDataProperties)

+ (NSFetchRequest<ClassList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ClassList"];
}

@dynamic classId;
@dynamic classSession;
@dynamic classSize;
@dynamic classRegPrice;
@dynamic classDiscount;
@dynamic classStartDate;
@dynamic classEndDate;
@dynamic courseID;
@dynamic course;
@dynamic schedules;

@end
