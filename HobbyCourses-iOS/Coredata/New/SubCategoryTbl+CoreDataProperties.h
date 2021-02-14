//
//  SubCategoryTbl+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "SubCategoryTbl+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SubCategoryTbl (CoreDataProperties)

+ (NSFetchRequest<SubCategoryTbl *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *subCategoryId;
@property (nullable, nonatomic, copy) NSString *subCategoryName;
@property (nullable, nonatomic, copy) NSString *subCategoryImgUrl;
@property (nullable, nonatomic, copy) NSString *course_count;
@property (nullable, nonatomic, retain) CategoryTbl *category;
@property (nullable, nonatomic, retain) CourseForm *course;

@end

NS_ASSUME_NONNULL_END
