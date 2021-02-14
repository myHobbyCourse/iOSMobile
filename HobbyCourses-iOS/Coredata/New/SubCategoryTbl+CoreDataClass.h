//
//  SubCategoryTbl+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryTbl, CourseForm;

NS_ASSUME_NONNULL_BEGIN

@interface SubCategoryTbl : NSManagedObject
+(void) insertSubCategory:(SubCategoryEntity *) subCategoryEntity categoryTbl:(CategoryTbl*) category;
+(SubCategoryTbl*) getSubCategorybyID:(NSString *) rowKey;

@end

NS_ASSUME_NONNULL_END

#import "SubCategoryTbl+CoreDataProperties.h"
