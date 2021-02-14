//
//  ClassList+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CourseForm+CoreDataClass.h"


@class CourseForm;

NS_ASSUME_NONNULL_BEGIN

@interface ClassList : NSManagedObject
+(void) insertOrUpdate:(NSString *) classId objects:(NSArray*) info feildName:(FeildName) forField;
+(ClassList*) getObjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteClass:(NSString*) rowKey;
+(NSArray*) getAllClass;
@end

NS_ASSUME_NONNULL_END

#import "ClassList+CoreDataProperties.h"
