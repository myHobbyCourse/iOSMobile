//
//  TempStore+CoreDataProperties.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 25/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TempStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface TempStore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *rowId;
@property (nullable, nonatomic, retain) NSString *mStartTime;
@property (nullable, nonatomic, retain) NSString *mEndTime;
@property (nullable, nonatomic, retain) NSString *mCompareDate;

@end

NS_ASSUME_NONNULL_END
