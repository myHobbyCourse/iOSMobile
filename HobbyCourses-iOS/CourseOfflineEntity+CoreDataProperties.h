//
//  CourseOfflineEntity+CoreDataProperties.h
//  HobbyCourses-iOS
//
//  Created by Kirit on 20/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CourseOfflineEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseOfflineEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *courseDetails;
@property (nullable, nonatomic, retain) NSData *courseImage;

@end

NS_ASSUME_NONNULL_END
