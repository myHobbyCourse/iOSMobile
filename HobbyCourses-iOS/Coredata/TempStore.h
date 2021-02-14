//
//  TempStore.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 25/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TempStore : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void) insertTimesFrom:(NSString *) start to:(NSString*) end  Compare:(NSString*) compare UUID:(NSString*) rowKey;
+(NSArray*) getobjectbyRowID:(NSString *)  rowKey compareDate:(NSString*) compare ;
+(BOOL) deleteAllTempData;
@end

NS_ASSUME_NONNULL_END

#import "TempStore+CoreDataProperties.h"
