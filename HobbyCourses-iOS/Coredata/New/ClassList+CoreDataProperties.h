//
//  ClassList+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ClassList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClassList (CoreDataProperties)

+ (NSFetchRequest<ClassList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *classId;
@property (nullable, nonatomic, copy) NSString *classSession;
@property (nullable, nonatomic, copy) NSString *classSize;
@property (nullable, nonatomic, copy) NSString *classRegPrice;
@property (nullable, nonatomic, copy) NSString *classDiscount;
@property (nullable, nonatomic, copy) NSString *classStartDate;
@property (nullable, nonatomic, copy) NSString *classEndDate;
@property (nullable, nonatomic, copy) NSString *courseID;
@property (nullable, nonatomic, retain) CourseForm *course;
@property (nullable, nonatomic, retain) NSSet<ScheduleList *> *schedules;

@end

NS_ASSUME_NONNULL_END
