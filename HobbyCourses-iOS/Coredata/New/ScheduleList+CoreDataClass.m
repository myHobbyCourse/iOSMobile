//
//  ScheduleList+CoreDataClass.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ScheduleList+CoreDataClass.h"

@implementation ScheduleList

+(void) insertOrUpdate:(TimeBatch *) timeBatch classRow:(NSString*) rowID {
  
    ScheduleList * obj = [self getObjectbyRowID:timeBatch.sessionId];
    
    if (obj == nil) {
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"ScheduleList"
               inManagedObjectContext:APPDELEGATE.managedObjectContext];
        obj.sessionId = timeBatch.sessionId;
    }
    
    obj.sessionStart = timeBatch.batch_start_date;
    obj.sessionEnd = timeBatch.batch_end_date;
    obj.sessionDate = timeBatch.sDate;
    
    ClassList *classList = [ClassList getObjectbyRowID:rowID];
    if (classList) {
        obj.classList = classList;
        obj.classId = classList.classId;
    }
    
    NSError *mocSaveError = nil;
    if (![APPDELEGATE.managedObjectContext save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}

+(ScheduleList*) getObjectbyRowID:(NSString *) rowKey {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"ScheduleList" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sessionId == %@",rowKey];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    if (arr.count > 0) {
        return arr[0];
    }
    return nil;}

+(NSArray*) getAllSchedules {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"sessionId" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}


//Single batch
+(BOOL) deleteSchedule:(NSString*) rowKey {
    
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"ScheduleList" inManagedObjectContext:myContext]];
    [allTimes setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sessionId == %@",rowKey];
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
