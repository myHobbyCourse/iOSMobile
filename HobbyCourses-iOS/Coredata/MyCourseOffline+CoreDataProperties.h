//
//  MyCourseOffline+CoreDataProperties.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 27/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyCourseOffline.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCourseOffline (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mBatchId;
@property (nullable, nonatomic, retain) NSString *mUid;
@property (nullable, nonatomic, retain) NSString *mStartDate;
@property (nullable, nonatomic, retain) NSString *mEndDate;
@property (nullable, nonatomic, retain) NSString *mSession;
@property (nullable, nonatomic, retain) NSData *mTimes;
@property (nullable, nonatomic, retain) NSString *mBatchSize;
@property (nullable, nonatomic, retain) NSString *mPrice;
@property (nullable, nonatomic, retain) NSString *mDiscount;


@end

NS_ASSUME_NONNULL_END
