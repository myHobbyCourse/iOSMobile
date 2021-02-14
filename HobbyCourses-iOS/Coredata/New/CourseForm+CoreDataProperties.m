//
//  CourseForm+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CourseForm+CoreDataProperties.h"

@implementation CourseForm (CoreDataProperties)

+ (NSFetchRequest<CourseForm *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CourseForm"];
}

@dynamic courseNid;
@dynamic courseTitle;
@dynamic courseCancellation;
@dynamic courseClassSize;
@dynamic courseBatchSize;
@dynamic courseIntroduction;
@dynamic courseAdd1;
@dynamic courseAdd2;
@dynamic coursePinCode;
@dynamic courseCity;
@dynamic courseLat;
@dynamic courseLng;
@dynamic courseVenueName;
@dynamic courseAgeGp;
@dynamic courseAgeGpValue;
@dynamic coursePlaces;
@dynamic courseIsMoneyBack;
@dynamic courseIsTrial;
@dynamic courseDescription;
@dynamic courseReqirements;
@dynamic tutorName;
@dynamic classes;
@dynamic images;
@dynamic amenities;
@dynamic videos;
@dynamic category;
@dynamic subcategory;
@dynamic certificates;

@end
