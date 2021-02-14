//
//  DataClass.m
//  HobbyCourses
//
//  Created by iOS Dev on 19/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass
@synthesize crsCordinateDict,crsAddress,crsImages,selectedPreviewImg,crsYoutubeURL,crsCertificate,crsAmenities,arrCourseBatches,isPage1Done,isPage2Done,isPage3Done,isPage4Done,isPage5Done,isPage6Done,isPage7Done,crsVenueName,crsVenueCoDict,rowID;

static DataClass *instance = nil;

+(DataClass *)getInstance {
    @synchronized(self) {
        if(instance==nil) {
            instance= [[DataClass alloc] init];
        }
    }
    return instance;
}

- (id)init {
    self = [super init];
    if ( self ) {
        crsImages = [NSMutableArray new];
        crsYoutubeURL = [[NSMutableArray alloc] initWithCapacity:5];
        crsCertificate = [[NSMutableArray alloc] initWithCapacity:5];
        crsAmenities = [[NSMutableArray alloc] init];
        
        selectedPreviewImg = 0;
        arrCourseBatches = [NSMutableArray new];
        self.crsStock = @"1";
        self.crsAgeGroupIndex = -1;
        
    }
    return self;
}



#pragma mark - Custom Method
-(void) flushClass {
    self.crsAddress = nil;
    self.crsCordinateDict = nil;
    self.crsAddress1 = nil;
    self.crsPincode = nil;
    self.crsCity = nil;
    self.crsImages  = [NSMutableArray new];
    self.crsTitle  = nil;
    self.crsStock  = nil;
    self.crsCategory  =  nil;
    self.crsSubCategoryEntity  = nil;
    self.crsCertificate  = [NSMutableArray new];
    [self.crsCertificate addObject:@""];
 
    self.crsYoutubeURL  = [NSMutableArray arrayWithCapacity:5];
    [self.crsYoutubeURL addObject:@""];
    [self.crsYoutubeURL addObject:@""];
    [self.crsYoutubeURL addObject:@""];
    [self.crsYoutubeURL addObject:@""];
    [self.crsYoutubeURL addObject:@""];
    self.crsBatch  = nil;
    self.crsSummary  = nil;
    self.crsRequirements  = nil;
    self.crsShortDesc  = nil;
    
    self.crsAgeGroup  = nil;
    self.crsAmenities  = [NSMutableArray new];
    self.arrCourseBatches  = [NSMutableArray new];
    
    self.crsVenueName  = nil;
    self.crsVenueCoDict  = nil;
    
    self.crsTutor = nil;
    self.crsAgeGroupIndex = -1;
    self.crsAgeGroup = nil;
    self.crsCancellation = nil;
}

-(void) setCourseFromData:(NSString*) courseId {
    [self flushClass];
    CourseForm *course = [CourseForm getObjectbyRowID:courseId];
    
    if (course == nil) {
        [CourseForm insertOrUpdateCourseForm:courseId objects:@[] feildName:FeildNameNone];
        course = [CourseForm getObjectbyRowID:courseId];
    }
    
    dataClass.crsTitle = course.courseTitle;
    dataClass.crsCategoryTbl = course.category;
    dataClass.crsSubCategoryTbl = course.subcategory;
    dataClass.crsBatch = course.courseBatchSize;
    dataClass.crsCancellation = course.courseCancellation;
    dataClass.crsSummary = course.courseIntroduction;
    dataClass.crsAddress = course.courseAdd1;
    dataClass.crsAddress1 = course.courseAdd2;
    dataClass.crsCity = course.courseCity;
    dataClass.crsPincode = course.coursePinCode;
    dataClass.crslat = course.courseLat;
    dataClass.crslng = course.courseLng;
    dataClass.crsAgeGroupIndex = [course.courseAgeGp integerValue];
    dataClass.crsAgeGroup = course.courseAgeGpValue;
    dataClass.isMoneyBack = course.courseIsMoneyBack;
    dataClass.isTrail = course.courseIsTrial;
    dataClass.crsStock = course.coursePlaces;
    dataClass.crsShortDesc = course.courseDescription;
    dataClass.crsTutor= course.tutorName;
    dataClass.crsRequirements = course.courseReqirements;
   
    for(ImageList *imgObj in [course.images allObjects]){
        [dataClass.crsImages addObject:imgObj.imgUrl];
    }
    
    if (course.classes.count == 0) {
        NSString *uID = GetTimeStampString;
        [ClassList insertOrUpdate:uID objects:@[] feildName:FeildNameNone];
        Batches *batch = [[Batches alloc] init];
        batch.batchID = uID;
        [dataClass.arrCourseBatches addObject:batch];
    }else{
        for(ClassList *obj in course.classes){
            Batches *batch = [[Batches alloc] init];
            batch.batchID = obj.classId;
            batch.sessions = obj.classSession;
            batch.classSize = obj.classSize;
            batch.price = obj.classRegPrice;
            batch.discount = obj.classDiscount;
            batch.startDate = obj.classStartDate;
            batch.endDate = obj.classEndDate;
            for (ScheduleList *schedule in obj.schedules) {
                TimeBatch *time = [[TimeBatch alloc] init];
                time.sessionId = schedule.sessionId;
                time.batch_start_date = schedule.sessionStart;
                time.batch_end_date = schedule.sessionEnd;
                time.sDate = schedule.sessionDate;
                [batch.batchesTimes addObject:time];
            }
            [dataClass.arrCourseBatches addObject:batch];
        }
    }
    
    for(AmeitiesList *obj in course.amenities) {
        [dataClass.crsAmenities addObject:obj.amName];
    }
    
    for(VideoList *obj in course.videos) {
        [dataClass.crsYoutubeURL replaceObjectAtIndex:[obj.videoIndex integerValue] withObject:obj.videoUrl];
    }
    
    for(CertificateList *obj in course.certificates) {
        [dataClass.crsCertificate addObject:@""];
    }
    for(CertificateList *obj in course.certificates) {
        [dataClass.crsCertificate replaceObjectAtIndex:[obj.certificateIndex integerValue] withObject:obj.certificateName];
    }
}

@end
