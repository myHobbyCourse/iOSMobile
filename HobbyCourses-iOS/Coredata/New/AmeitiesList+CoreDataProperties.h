//
//  AmeitiesList+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "AmeitiesList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AmeitiesList (CoreDataProperties)

+ (NSFetchRequest<AmeitiesList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *amIndex;
@property (nullable, nonatomic, copy) NSString *amName;
@property (nullable, nonatomic, copy) NSString *courseID;
@property (nullable, nonatomic, retain) CourseForm *course;

@end

NS_ASSUME_NONNULL_END
