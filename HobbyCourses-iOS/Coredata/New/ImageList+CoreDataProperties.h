//
//  ImageList+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ImageList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ImageList (CoreDataProperties)

+ (NSFetchRequest<ImageList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imgUrl;
@property (nullable, nonatomic, copy) NSString *imgIndex;
@property (nullable, nonatomic, copy) NSString *courseID;
@property (nullable, nonatomic, retain) CourseForm *course;

@end

NS_ASSUME_NONNULL_END
