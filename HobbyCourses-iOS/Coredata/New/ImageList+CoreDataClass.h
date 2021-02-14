//
//  ImageList+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseForm;

NS_ASSUME_NONNULL_BEGIN

@interface ImageList : NSManagedObject

+(void) insertImage:(NSString *) imgName courseForm:(CourseForm*) course;
+(ImageList*) getObjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteImage:(NSString*) rowKey;
+(NSArray*) getAllImageForm;

@end

NS_ASSUME_NONNULL_END

#import "ImageList+CoreDataProperties.h"
