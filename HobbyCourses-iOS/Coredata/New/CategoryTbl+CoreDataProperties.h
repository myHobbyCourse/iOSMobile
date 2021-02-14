//
//  CategoryTbl+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CategoryTbl+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CategoryTbl (CoreDataProperties)

+ (NSFetchRequest<CategoryTbl *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *categoryId;
@property (nullable, nonatomic, copy) NSString *categoryName;
@property (nullable, nonatomic, copy) NSString *categoryImgUrl;
@property (nullable, nonatomic, retain) SubCategoryTbl *subcategory;
@property (nullable, nonatomic, retain) NSSet<SubCategoryTbl *> *subcategorys;

@property (nullable, nonatomic, retain) CourseForm *course;

@end

NS_ASSUME_NONNULL_END
