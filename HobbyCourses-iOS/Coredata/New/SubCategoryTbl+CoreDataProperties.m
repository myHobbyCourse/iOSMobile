//
//  SubCategoryTbl+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "SubCategoryTbl+CoreDataProperties.h"

@implementation SubCategoryTbl (CoreDataProperties)

+ (NSFetchRequest<SubCategoryTbl *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SubCategoryTbl"];
}

@dynamic subCategoryId;
@dynamic subCategoryName;
@dynamic subCategoryImgUrl;
@dynamic course_count;
@dynamic category;
@dynamic course;

@end
