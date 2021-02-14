//
//  CategoryTbl+CoreDataClass.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CategoryTbl+CoreDataClass.h"

@implementation CategoryTbl
+(void) insertCategory:(CategoryEntity *) categoryEntity {
    
    CategoryTbl *obj = [self getCategorybyID:categoryEntity.tid];
    if (obj == nil) {
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"CategoryTbl"
               inManagedObjectContext:APPDELEGATE.managedObjectContext];
    }

    obj.categoryId = [NSString stringWithFormat:@"%@",categoryEntity.tid];
    obj.categoryName = categoryEntity.category;
    obj.categoryImgUrl = categoryEntity.image;
    for (SubCategoryEntity *entity in categoryEntity.subCategories) {
        [SubCategoryTbl insertSubCategory:entity categoryTbl:obj];
    }
    NSError *mocSaveError = nil;
    if (![APPDELEGATE.managedObjectContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}
+(CategoryTbl*) getCategorybyID:(NSString *) rowKey {
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"CategoryTbl" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"categoryId == %@",rowKey];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    if (arr.count > 0) {
        return arr[0];
    }
    return nil;
}

@end
