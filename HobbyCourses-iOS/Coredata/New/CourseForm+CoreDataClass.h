//
//  CourseForm+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum : NSUInteger {
    FeildNameNone,
    FeildNameTitle,
    FeildNameCategory,
    FeildNameSubCategory,
    FeildNameBatchSize,
    FeildNameCancellation,
    FeildNameIntroduction,
    FeildNameLocation,
    FeildNameAgeGp,
    FeildNamePlaceA,
    FeildNameIsMoney,
    FeildNameIsTrial,
    FeildNameDescription,
    FeildNameImage,
    FeildNameCourseReq,
    FeildNameTutor,

    
    BatchSession,
    BatchSize,
    BatchPrice,
    BatchDiscount,
    BatchStart,
    BatchEnd,
    BatchSignleAll
    
    
    
} FeildName;

@class AmeitiesList, CategoryTbl, ClassList, ImageList, SubCategoryTbl, VideoList;

NS_ASSUME_NONNULL_BEGIN

@interface CourseForm : NSManagedObject

+(void) insertOrUpdateCourseForm:(NSString *) courseNid objects:(NSArray*) info feildName:(FeildName) forField;
+(CourseForm*) getObjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteCourseForm:(NSString*) rowKey;
+(NSArray*) getAllCourseForm;

@end

NS_ASSUME_NONNULL_END

#import "CourseForm+CoreDataProperties.h"
