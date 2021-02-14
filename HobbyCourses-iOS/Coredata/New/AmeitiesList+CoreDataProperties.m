//
//  AmeitiesList+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "AmeitiesList+CoreDataProperties.h"

@implementation AmeitiesList (CoreDataProperties)

+ (NSFetchRequest<AmeitiesList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AmeitiesList"];
}

@dynamic amIndex;
@dynamic amName;
@dynamic courseID;
@dynamic course;

@end
