//
//  SubmitForm+CoreDataClass.m
//  HobbyCourses
//
//  Created by iOS Dev on 14/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SubmitForm+CoreDataClass.h"

@implementation SubmitForm
+(void) insertSubmitFrom:(NSString *) courseID object:(DataClass*) data row:(NSString*) rowId{
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSArray * objArr = [self getobjectbyRowID:rowId];
    SubmitForm * obj;
    if (objArr == nil || objArr.count == 0) { // First time 1464506040397.090820
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"SubmitForm"
               inManagedObjectContext:moc];
    }else {
        obj = [objArr firstObject];
    }

    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:data];
    obj.courseID = courseID;
    obj.courseData = encodedObject;

    NSError *mocSaveError = nil;
    if (![moc save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}

//Signle batch records
+(NSArray*) getobjectbyRowID:(NSString *) rowKey {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"SubmitForm" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"courseID == %@",rowKey];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}
+(NSArray*) getAllCourseForm {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"SubmitForm" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}


//Single batch
+(BOOL) deleteSubmitForm:(NSString*) rowKey {
    
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"SubmitForm" inManagedObjectContext:myContext]];
    [allTimes setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"courseID == %@",rowKey];
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
