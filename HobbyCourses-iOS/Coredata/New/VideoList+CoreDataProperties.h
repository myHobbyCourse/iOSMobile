//
//  VideoList+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "VideoList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VideoList (CoreDataProperties)

+ (NSFetchRequest<VideoList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *videoUrl;
@property (nullable, nonatomic, copy) NSString *videoIndex;
@property (nullable, nonatomic, copy) NSString *courseID;
@property (nullable, nonatomic, retain) CourseForm *course;

@end

NS_ASSUME_NONNULL_END
