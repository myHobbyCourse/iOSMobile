//
//  ClassList+CoreDataClass.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ClassList+CoreDataClass.h"
#import "Batches.h"

@implementation ClassList

+(void) insertOrUpdate:(NSString *) classId objects:(NSArray*) info feildName:(FeildName) forField {
    ClassList * obj = [self getObjectbyRowID:classId];
    
    if (obj == nil) {
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"ClassList"
               inManagedObjectContext:APPDELEGATE.managedObjectContext];
        obj.classId = classId;
    }
    switch (forField) {
        case BatchSession:
            obj.classSession = info[0];
            break;
        case BatchSize:
            obj.classSize = info[0];
            break;
        case BatchDiscount:
            obj.classDiscount = info[0];
            break;
        case BatchPrice:
            obj.classRegPrice = info[0];
            break;
        case BatchStart:
            obj.classStartDate = info[0];
            break;
        case BatchEnd:
            obj.classEndDate = info[0];
            break;
        case BatchSignleAll:{
            Batches *oob = info[0];
            if ([oob isKindOfClass:[Batches class]]) {
                obj.classSession = oob.sessions;
                obj.classSize = oob.classSize;
                obj.classDiscount = oob.discount;
                obj.classRegPrice = oob.price;
                obj.classStartDate = oob.startDate;
                obj.classEndDate = oob.endDate;
            }
        }
            break;
        
        default:
            break;
    }
    CourseForm *course = [CourseForm getObjectbyRowID:dataClass.rowID];
    if (course) {
        obj.course = course;
        obj.courseID = course.courseNid;
    }
    
    NSError *mocSaveError = nil;
    if (![APPDELEGATE.managedObjectContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}

+(ClassList*) getObjectbyRowID:(NSString *) rowKey {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"ClassList" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"classId == %@",rowKey];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    if (arr.count > 0) {
        return arr[0];
    }
    return nil;}

+(NSArray*) getAllClass {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"classId" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}


//Single batch
+(BOOL) deleteClass:(NSString*) rowKey {
    
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"ClassList" inManagedObjectContext:myContext]];
    [allTimes setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"classId == %@",rowKey];
    allTimes.predicate = predicate;
    
    NSError *error = nil;
    NSArray *times = [myContext executeFetchRequest:allTimes error:&error];
    //error handling goes here
    for (NSManagedObject *time in times) {
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
