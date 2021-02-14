//
//  CategoryTbl+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseForm, SubCategoryTbl;

NS_ASSUME_NONNULL_BEGIN

@interface CategoryTbl : NSManagedObject
+(void) insertCategory:(CategoryEntity *) categoryEntity;
+(CategoryTbl*) getCategorybyID:(NSString *) rowKey;


@end

NS_ASSUME_NONNULL_END

#import "CategoryTbl+CoreDataProperties.h"
