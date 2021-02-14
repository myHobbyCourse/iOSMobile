//
//  AmeitiesList+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseForm;

NS_ASSUME_NONNULL_BEGIN

@interface AmeitiesList : NSManagedObject
+(void) insertAmeities:(NSString *) imgName courseForm:(CourseForm*) course;
+(AmeitiesList*) getObjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteAmeities:(NSString*) rowKey;
+(BOOL) deleteAmeities;
+(NSArray*) getAllAmeitiesList;
@end

NS_ASSUME_NONNULL_END

#import "AmeitiesList+CoreDataProperties.h"
