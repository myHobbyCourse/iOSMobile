//
//  SubmitForm+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 14/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SubmitForm+CoreDataProperties.h"

@implementation SubmitForm (CoreDataProperties)

+ (NSFetchRequest<SubmitForm *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SubmitForm"];
}

@dynamic courseData;
@dynamic courseID;

@end
