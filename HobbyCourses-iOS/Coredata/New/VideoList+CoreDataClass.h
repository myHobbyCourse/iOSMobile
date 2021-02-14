//
//  VideoList+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseForm;

NS_ASSUME_NONNULL_BEGIN

@interface VideoList : NSManagedObject
+(void) insertVideos:(NSString *) name index:(NSString*) idx courseForm:(CourseForm*) course;
+(VideoList*) getObjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteVideos:(NSString*) rowKey;
+(NSArray*) getAllVideoList;
@end

NS_ASSUME_NONNULL_END

#import "VideoList+CoreDataProperties.h"
