//
//  SubmitForm+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 14/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubmitForm : NSManagedObject

+(void) insertSubmitFrom:(NSString *) courseID object:(DataClass*) data row:(NSString*) rowId;
+(NSArray*) getobjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteSubmitForm:(NSString*) rowKey;
+(NSArray*) getAllCourseForm;
@end

NS_ASSUME_NONNULL_END

#import "SubmitForm+CoreDataProperties.h"
