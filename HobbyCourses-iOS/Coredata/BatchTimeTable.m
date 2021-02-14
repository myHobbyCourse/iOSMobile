//
//  BatchTimeTable.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "BatchTimeTable.h"

@implementation BatchTimeTable

// Insert code here to add functionality to your managed object subclass
+(void) insertTimes:(NSString*) uuid from:(NSString *) start to:(NSString*) end Compare:(NSString*) compare UUID:(NSString*) forenKey{
 
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSArray * objArr = [self getobjectbyStartDate:compare identifier:uuid];
    BatchTimeTable * obj;
    if (objArr == nil || objArr.count == 0) { // First time 1464506040397.090820
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"BatchTimeTable"
               inManagedObjectContext:moc];
    }else {
        obj = [objArr firstObject];
    }

    obj.mStartTime = start;
    obj.mEndTime = end;
    obj.mUid = uuid;
    obj.mCompareDate = compare;
    obj.mForenKey = forenKey;
    NSError *mocSaveError = nil;
    if (![moc save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}
+(NSArray*) getobjectbyStartDate:(NSString *) start identifier:(NSString*) uuid {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"BatchTimeTable" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mCompareDate == %@ and mUid == %@",start,uuid];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}
//Signle batch records
+(NSArray*) getobjectbyBatchID:(NSString *)  uuid {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"BatchTimeTable" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mUid == %@",uuid];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}
+(NSArray*) getTimeForMonth:(NSString*) sDate endDate:(NSString*) eDate {

    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(mCompareDate >= %@) AND (mCompareDate <= %@)", sDate, eDate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"BatchTimeTable" inManagedObjectContext:moc]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    return results;
}
+(NSArray*) getobjectAllObject {

    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"BatchTimeTable" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}

// single batch copy
+(BOOL) copyBatchTimeToNew:(NSString*) batchId toBatch:(NSString*) newBatchId{
    
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"BatchTimeTable" inManagedObjectContext:myContext]];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mUid == %@",batchId];
    allTimes.predicate = predicate;
    
    NSError *error = nil;
    NSArray *times = [myContext executeFetchRequest:allTimes error:&error];
    //error handling goes here
    for (BatchTimeTable *time in times) {
        BatchTimeTable *obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"BatchTimeTable"
               inManagedObjectContext:myContext];
        obj.mUid = newBatchId;
        obj.mStartTime = time.mStartTime;
        obj.mEndTime = time.mEndTime;
        obj.mCompareDate = time.mCompareDate;
        obj.mForenKey = time.mForenKey;
    }
    NSError *saveError = nil;
    if (![myContext save:&saveError])
    {
        NSLog(@"save did not complete successfully. Error: %@",
              [saveError localizedDescription]);
        return false;
    }else{
        return true;
    }
}

//Single batch
+(BOOL) deleteTimeSlot:(NSString*) batchId {
    
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"BatchTimeTable" inManagedObjectContext:myContext]];
    [allTimes setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mUid == %@",batchId]; // muID mean uniques timestamp id not a UUID string
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
