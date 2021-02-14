//
//  DataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 19/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Batches;

@interface DataClass : NSObject

@property(nonatomic,strong) NSString *crsAddress;
@property(nonatomic,retain) NSString *crsAddress1;
@property(nonatomic,strong) NSString *crsPincode;
@property(nonatomic,strong) NSString *crsCity;
@property(nonatomic,strong) NSString *crsVenueName;
@property(nonatomic,strong) NSString *crslat;
@property(nonatomic,strong) NSString *crslng;

@property(nonatomic,strong) NSDictionary *crsVenueCoDict;

@property(nonatomic,strong) NSDictionary *crsCordinateDict;
@property(assign) NSInteger selectedPreviewImg;
@property(nonatomic,strong) CategoryEntity *crsCategory;
@property(nonatomic,strong) SubCategoryEntity *crsSubCategoryEntity;

@property(nonatomic,strong) CategoryTbl *crsCategoryTbl;
@property(nonatomic,strong) SubCategoryTbl *crsSubCategoryTbl;


@property(nonatomic,strong) NSString *crsStock;

@property(nonatomic,strong) NSString *crsTutor;
@property(nonatomic,strong) NSString *crsBatch;
@property(nonatomic,strong) NSString *crsTitle;
@property(nonatomic,strong) NSString *crsCancellation;

@property(nonatomic,strong) NSString *crsAgeGroup;
@property(assign) NSInteger crsAgeGroupIndex;

@property(nonatomic,strong) NSString *crsRequirements;
@property(nonatomic,strong) NSString *crsSummary;
@property(nonatomic,strong) NSString *crsShortDesc;

@property(nonatomic,strong) NSString *crsNid; //For Edit

@property(strong,nonatomic) NSString *rowID;


@property(nonatomic,strong) NSMutableArray<Batches*> *arrCourseBatches;

@property(strong,nonatomic) NSString *isMoneyBack;
@property(strong,nonatomic) NSString *isTrail;


@property(nonatomic,strong) NSMutableArray<NSString*> *crsImages;
@property(nonatomic,strong) NSMutableArray<NSString*> *crsCertificate;
@property(nonatomic,strong) NSMutableArray<NSString*> *crsYoutubeURL;
@property(nonatomic,strong) NSMutableArray<NSString*> *crsAmenities;

@property(assign) BOOL isPage1Done;
@property(assign) BOOL isPage2Done;
@property(assign) BOOL isPage3Done;
@property(assign) BOOL isPage4Done;
@property(assign) BOOL isPage5Done;
@property(assign) BOOL isPage6Done;
@property(assign) BOOL isPage7Done;
@property(assign) BOOL isPage8Done;


+(DataClass*)getInstance;

- (void) flushClass;

-(void) setCourseFromData:(NSString*) courseId;
@end
