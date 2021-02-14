//
//  SubCategoryTbl+CoreDataClass.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "SubCategoryTbl+CoreDataClass.h"

@implementation SubCategoryTbl
+(void) insertSubCategory:(SubCategoryEntity *) subCategoryEntity categoryTbl:(CategoryTbl*) category {
    
    SubCategoryTbl *obj = [self getSubCategorybyID:subCategoryEntity.tid];
    if (obj == nil) {
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"SubCategoryTbl"
               inManagedObjectContext:APPDELEGATE.managedObjectContext];
    }
    
    obj.subCategoryId = [NSString stringWithFormat:@"%@",subCategoryEntity.tid];
    obj.subCategoryName = subCategoryEntity.subCategory;
    obj.subCategoryImgUrl = subCategoryEntity.image;
    obj.course_count = subCategoryEntity.course_count;
    obj.category = category;
    
    NSError *mocSaveError = nil;
    if (![APPDELEGATE.managedObjectContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}
+(SubCategoryTbl*) getSubCategorybyID:(NSString *) rowKey {
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"SubCategoryTbl" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"subCategoryId == %@",rowKey];
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
