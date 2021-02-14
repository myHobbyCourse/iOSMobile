//
//  TempStore.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 25/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TempStore.h"

@implementation TempStore

// Insert code here to add functionality to your managed object subclass
+(void) insertTimesFrom:(NSString *) start to:(NSString*) end Compare:(NSString*) compare UUID:(NSString*) rowKey {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    TempStore * obj;
    obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"TempStore"
               inManagedObjectContext:moc];

    obj.mStartTime = start;
    obj.mEndTime = end;
    obj.rowId = rowKey;
    obj.mCompareDate = compare;
    
    NSError *mocSaveError = nil;
    if (![moc save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
    }
}

//Signle batch records
+(NSArray*) getobjectbyRowID:(NSString *)  rowKey compareDate:(NSString*) compare {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"TempStore" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mCompareDate == %@ and rowId == %@",compare,rowKey];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}
+(BOOL) deleteAllTempData{
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"TempStore" inManagedObjectContext:myContext]];
    
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
