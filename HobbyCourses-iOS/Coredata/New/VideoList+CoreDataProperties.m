//
//  VideoList+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "VideoList+CoreDataProperties.h"

@implementation VideoList (CoreDataProperties)

+ (NSFetchRequest<VideoList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VideoList"];
}

@dynamic videoUrl;
@dynamic videoIndex;
@dynamic courseID;
@dynamic course;

@end
