//
//  Search.h
//  HobbyCourses
//
//  Created by iOS Dev on 26/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Search : NSObject

@property(nonatomic,strong) NSString *keyword;
@property(nonatomic,strong) NSString *location;
@property(nonatomic,strong) NSString *radius;
@property(nonatomic,strong) NSString *startDate;
@property(nonatomic,strong) NSString *endDate;
@property(nonatomic,strong) NSString *classSize;
@property(nonatomic,strong) NSString *ageGroup;
@property(nonatomic,strong) NSString *priceRangeMin;
@property(nonatomic,strong) NSString *priceRangeMax;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *sessions;
@property(nonatomic,strong) NSMutableArray *weekDays;
@property(nonatomic,strong) NSString *orderBy;
@property(nonatomic,strong) NSString *timesValue;

@property(nonatomic,strong) NSArray *arrPriceSlab;
@property(nonatomic,strong) NSArray *arrClass;
@property(nonatomic,strong) NSArray *arrOrderBy;
@property(nonatomic,strong) NSArray *arrTimes;
@property(nonatomic,strong) NSArray *arrAgeValue;

-(NSString*) getLocationName;
-(NSInteger) getClassValue;
-(NSInteger) getOrderValue;
-(NSInteger) getAgeValue;
-(NSInteger) getPriceValue;
-(NSInteger) getSessionsValue;
-(NSInteger) getTimesValue;
@end
