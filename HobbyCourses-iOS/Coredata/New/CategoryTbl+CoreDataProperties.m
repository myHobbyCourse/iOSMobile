//
//  CategoryTbl+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CategoryTbl+CoreDataProperties.h"

@implementation CategoryTbl (CoreDataProperties)

+ (NSFetchRequest<CategoryTbl *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CategoryTbl"];
}

@dynamic categoryId;
@dynamic categoryName;
@dynamic categoryImgUrl;
@dynamic subcategory;
@dynamic course;
@dynamic subcategorys;

@end
