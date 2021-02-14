//
//  BatchTimeTable.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BatchTimeTable : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void) insertTimes:(NSString*) uuid from:(NSString *) start to:(NSString*) end Compare:(NSString*) compare UUID:(NSString*) forenKey;
+(BOOL) copyBatchTimeToNew:(NSString*) batchId toBatch:(NSString*) newBatchId;
+(NSArray*) getobjectbyStartDate:(NSString *) start identifier:(NSString*) uuid;
+(NSArray*) getobjectbyBatchID:(NSString *)  uuid;
+(NSArray*) getobjectAllObject;
+(BOOL) deleteTimeSlot:(NSString*) batchId;
+(NSArray*) getTimeForMonth:(NSString*) sDate endDate:(NSString*) eDate;
@end

NS_ASSUME_NONNULL_END

#import "BatchTimeTable+CoreDataProperties.h"
