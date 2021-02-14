//
//  MyCourseOffline.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 27/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "MyCourseOffline.h"

@implementation MyCourseOffline

// Insert code here to add functionality to your managed object subclass

//To get all batch of course
+(NSArray*) getobjectbyId:(NSString *) mid {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"MyCourseOffline" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mUid == %@",mid];
    request.predicate = predicate;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    return arr;
}
//To get particuler batch batch & uuid One course have unique UUID & mutiple batch have unique batchId
+(MyCourseOffline*) getobjectbyBatchId:(NSString *) batchId {
    
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSEntityDescription * enity = [NSEntityDescription entityForName:@"MyCourseOffline" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.entity = enity;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mBatchId == %@",batchId];
    request.predicate = predicate;
    request.returnsObjectsAsFaults = false;
    NSError *mocSaveError = nil;
    NSArray * arr = [moc executeFetchRequest:request error:&mocSaveError];
    if (arr.count > 0 ) {
        return arr[0];
    }
    return nil;
    
}
+(BOOL) insertCourse:(CourseFrom*) course uid:(NSString *) mid {
    NSManagedObjectContext * moc = APPDELEGATE.managedObjectContext;
    NSArray * objArr = [self getobjectbyId:mid];
    MyCourseOffline * obj;
    if (objArr == nil || objArr.count == 0) { // First time 1464506040397.090820
        obj = [NSEntityDescription
               insertNewObjectForEntityForName:@"MyCourseOffline"
               inManagedObjectContext:moc];
    }else {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"mBatchId == %@",course.courseBatchId];
        NSArray *filteredArray = [objArr filteredArrayUsingPredicate:bPredicate];
        if (filteredArray.count > 0) {
            obj = [filteredArray firstObject];
        } else { // Batch id not match create new row with same uuidstring
            obj = [NSEntityDescription
                   insertNewObjectForEntityForName:@"MyCourseOffline"
                   inManagedObjectContext:moc];
        }

    }
    obj.mUid = mid;
    obj.mStartDate = course.coursestartDate;
    obj.mEndDate = course.courseEndDate;
    obj.mPrice = course.coursePrice;
    obj.mDiscount = course.courseDiscount;
    obj.mSession = course.courseSession;
    obj.mBatchSize = course.courseBatchSize;
    obj.mBatchId = course.courseBatchId;
    
    NSError *mocSaveError = nil;
    if (![moc save:&mocSaveError])
    {
        NSLog(@"Save did not complete successfully. Error: %@",
              [mocSaveError localizedDescription]);
        return false;
    }else{
        return true;
    }
}
+(BOOL) deleteMyCourse:(NSString*) uuid{
    NSManagedObjectContext * myContext = APPDELEGATE.managedObjectContext;
    NSFetchRequest *allTimes = [[NSFetchRequest alloc] init];
    [allTimes setEntity:[NSEntityDescription entityForName:@"MyCourseOffline" inManagedObjectContext:myContext]];
    [allTimes setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"mUid == %@",uuid]; // here tmuID is UUID string
    allTimes.predicate = predicate;
    NSError *error = nil;
    NSArray *times = [myContext executeFetchRequest:allTimes error:&error];
    //error handling goes here
    for (MyCourseOffline *time in times) {
        [BatchTimeTable deleteTimeSlot:time.mBatchId];
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
    return true;
}
@end
