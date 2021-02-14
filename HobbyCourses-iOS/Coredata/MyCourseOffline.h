//
//  MyCourseOffline.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 27/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CourseFrom.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyCourseOffline : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
//+(void) insertCourse:(id) value feildName:(NSString *) name uid:(NSString *) mid;
+(BOOL) insertCourse:(CourseFrom*) course uid:(NSString *) mid;
+(NSArray*) getobjectbyId:(NSString *) mid;
+(MyCourseOffline*) getobjectbyBatchId:(NSString *) batchId;
+(BOOL) deleteMyCourse:(NSString*) uuid;

@end

NS_ASSUME_NONNULL_END

#import "MyCourseOffline+CoreDataProperties.h"
