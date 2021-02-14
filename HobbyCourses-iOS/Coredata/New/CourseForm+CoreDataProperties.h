//
//  CourseForm+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CourseForm+CoreDataClass.h"
#import "CertificateList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CourseForm (CoreDataProperties)

+ (NSFetchRequest<CourseForm *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *courseNid;
@property (nullable, nonatomic, copy) NSString *courseTitle;
@property (nullable, nonatomic, copy) NSString *courseCancellation;
@property (nullable, nonatomic, copy) NSString *courseClassSize;
@property (nullable, nonatomic, copy) NSString *courseBatchSize;
@property (nullable, nonatomic, copy) NSString *courseIntroduction;
@property (nullable, nonatomic, copy) NSString *courseAdd1;
@property (nullable, nonatomic, copy) NSString *courseAdd2;
@property (nullable, nonatomic, copy) NSString *coursePinCode;
@property (nullable, nonatomic, copy) NSString *courseCity;
@property (nullable, nonatomic, copy) NSString *courseLat;
@property (nullable, nonatomic, copy) NSString *courseLng;
@property (nullable, nonatomic, copy) NSString *courseVenueName;
@property (nullable, nonatomic, copy) NSNumber *courseAgeGp;
@property (nullable, nonatomic, copy) NSString *coursePlaces;
@property (nullable, nonatomic, copy) NSString *courseIsMoneyBack;
@property (nullable, nonatomic, copy) NSString *courseIsTrial;
@property (nullable, nonatomic, copy) NSString *courseDescription;
@property (nullable, nonatomic, copy) NSString *courseReqirements;
@property (nullable, nonatomic, copy) NSString *tutorName;
@property (nullable, nonatomic, copy) NSString *courseAgeGpValue;
@property (nullable, nonatomic, retain) NSSet<ClassList *> *classes;
@property (nullable, nonatomic, retain) NSSet<ImageList *> *images;
@property (nullable, nonatomic, retain) NSSet<AmeitiesList *> *amenities;
@property (nullable, nonatomic, retain) NSSet<VideoList *> *videos;
@property (nullable, nonatomic, retain) NSSet<CertificateList *> *certificates;
@property (nullable, nonatomic, retain) CategoryTbl *category;
@property (nullable, nonatomic, retain) SubCategoryTbl *subcategory;

@end

@interface CourseForm (CoreDataGeneratedAccessors)

- (void)addClassesObject:(ClassList *)value;
- (void)removeClassesObject:(ClassList *)value;
- (void)addClasses:(NSSet<ClassList *> *)values;
- (void)removeClasses:(NSSet<ClassList *> *)values;

- (void)addImagesObject:(ImageList *)value;
- (void)removeImagesObject:(ImageList *)value;
- (void)addImages:(NSSet<ImageList *> *)values;
- (void)removeImages:(NSSet<ImageList *> *)values;

- (void)addAmenitiesObject:(AmeitiesList *)value;
- (void)removeAmenitiesObject:(AmeitiesList *)value;
- (void)addAmenities:(NSSet<AmeitiesList *> *)values;
- (void)removeAmenities:(NSSet<AmeitiesList *> *)values;

- (void)addVideosObject:(VideoList *)value;
- (void)removeVideosObject:(VideoList *)value;
- (void)addVideos:(NSSet<VideoList *> *)values;
- (void)removeVideos:(NSSet<VideoList *> *)values;

@end

NS_ASSUME_NONNULL_END
