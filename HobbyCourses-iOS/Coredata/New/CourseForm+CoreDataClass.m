//
//  CourseForm+CoreDataClass.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CourseForm+CoreDataClass.h"
@implementation CourseForm

+(void) insertOrUpdateCourseForm:(NSString *) courseNid objects:(NSArray*) info feildName:(FeildName) forField {
    CourseForm *obj = [self getObjectbyRowID:courseNid];
    if (obj == nil) {
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"CourseForm"
               inManagedObjectContext:APPDELEGATE.managedObjectContext];
        obj.courseNid = courseNid;
    }
    switch (forField) {
        case FeildNameTitle:
            obj.courseTitle = info[0];
            break;
        case FeildNameCategory:
            obj.category = [CategoryTbl getCategorybyID:info[0]];
            break;
        case FeildNameSubCategory:
            obj.subcategory = [SubCategoryTbl getSubCategorybyID:info[0]];
            break;
        case FeildNameBatchSize:
            obj.courseBatchSize = info[0];
            break;
        case FeildNameCancellation:
            obj.courseCancellation = info[0];
            break;
        case FeildNameIntroduction:
            obj.courseIntroduction = info[0];
            break;
        case FeildNameLocation:
            obj.courseAdd1 = (info.count > 0) ? info[0] : @"";
            obj.courseAdd2 = (info.count > 1) ? info[1] : @"";
            obj.courseCity = (info.count > 2) ? info[2] : @"";
            obj.coursePinCode = (info.count > 3) ? info[3] : @"";
            obj.courseLat = (info.count > 4) ? info[4] : @"";
            obj.courseLng = (info.count > 5) ? info[5] : @"";
            break;
        case FeildNameAgeGp:
            obj.courseAgeGp = info[0];
            obj.courseAgeGpValue = info[1];
            break;
        case FeildNameIsMoney:
            obj.courseIsMoneyBack = info[0];
            break;
        case FeildNameIsTrial:
            obj.courseIsTrial = info[0];
            break;
        case FeildNamePlaceA:
            obj.coursePlaces = info[0];
            break;
        case FeildNameDescription:
            obj.courseDescription = info[0];
            break;
        case FeildNameImage:
            [ImageList insertImage:info[0] courseForm:obj];
            break;
        case FeildNameCourseReq:
            obj.courseReqirements = info[0];
            break;
        case FeildNameTutor:
            obj.tutorName = info[0];
            break;
        default:
            break;
    }
    
    NSError *mocSaveError = nil;
    if (![APPDELEGATE.managedObjectContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}

+(CourseForm*) getObjectbyRowID:(NSString *) rowKey {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"CourseForm" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"courseNid == %@",rowKey];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    if (arr.count > 0) {
        return arr[0];
    }
    return nil;
}

+(NSArray*) getAllCourseForm {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"courseNid" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}


//Single batch
+(BOOL) deleteCourseForm:(NSString*) rowKey {
    
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"CourseForm" inManagedObjectContext:myContext]];
    [allTimes setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"courseNid == %@",rowKey];
    allTimes.predicate = predicate;
    
    NSError *error = nil;
    NSArray *times = [myContext executeFetchRequest:allTimes error:&error];
    //error handling goes here
    for (CourseForm *time in times) {
        for (ImageList *imageList in time.images) {
            [[DocumentAccess obj] removeMediaForName:imageList.imgUrl];
        }
        [myContext deleteObject:time];
    }
    NSError *saveError = nil;
    if (![myContext save:&saveError])
    {
        NSLog(@"delete did not complete successfully. Error: %@",
              [saveError localizedDescription]);
        return false;
    }else{
        return true;
    }
}

@end
