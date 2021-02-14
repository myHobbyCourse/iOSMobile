//
//  ImageList+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ImageList+CoreDataProperties.h"

@implementation ImageList (CoreDataProperties)

+ (NSFetchRequest<ImageList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ImageList"];
}

@dynamic imgUrl;
@dynamic imgIndex;
@dynamic courseID;
@dynamic course;

@end
