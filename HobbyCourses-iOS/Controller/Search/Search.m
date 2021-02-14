//
//  Search.m
//  HobbyCourses
//
//  Created by iOS Dev on 26/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "Search.h"

@implementation Search
@synthesize radius,priceRangeMin,price,priceRangeMax,keyword,orderBy,ageGroup,location,weekDays,classSize,endDate,startDate,arrClass,arrOrderBy,arrAgeValue,arrTimes,timesValue;

- (id) init {
    self = [super init];
    if (self) {
        weekDays = [[NSMutableArray alloc] init];
        arrClass = [[NSArray alloc] initWithObjects:@"1-to-1",@"2 - 5",@"5 - 10",@"10 - 20",@"Any Size", nil];
        arrOrderBy = [[NSMutableArray alloc]initWithObjects:@"Start date (DESC)",@"Start date (ASC)",@"Reviews count (DESC)",@"Reviews count (ASC)",@"Price (DESC)",@"Price (ASC)",@"Distance", nil];
        arrTimes = [[NSArray alloc] initWithObjects:@"Morning 08am - 12am",@"Afternoon 12am - 03pm",@"Late Afternoon 03pm - 05pm",@"Evening 05pm - 08pm",@"Don’t care", nil];

        arrAgeValue = [[NSArray alloc] initWithObjects:@"18 - 99 Years",@"19 - 40 Years",@"40 - 60 Years",@"60 - 99 Years",@"17 - 20 Years",@"16 - 17 Years",@"12 - 16 Years",@"5 - 12 Years", nil];
        
        _arrPriceSlab = [[NSArray alloc] initWithObjects:@"0 - 50 £",@"0 - 100 £",@"0 - 250 £",@"0 - 499 £",@"Don't care", nil];

        startDate = [globalDateOnlyFormatter() stringFromDate:[NSDate date]];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:6];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        endDate = [globalDateOnlyFormatter() stringFromDate:newDate];
        radius = @"5";
        location = (_isStringEmpty(userINFO.city)) ? APPDELEGATE.selectedCity : userINFO.city;
        classSize = [arrClass lastObject];
        orderBy = [arrOrderBy lastObject];
        timesValue =  [arrTimes lastObject];
        price = [_arrPriceSlab lastObject];
    }
    return self;
}
-(NSString*) getLocationName {
    if ([location containsString:@"NearBy"]) {
        return [MyLocationManager sharedInstance].cityName;
    }else if ([location isEqualToString:@"AnyWhere"]) {
        return @"";
    }
    return location;
    
}
-(NSInteger) getClassValue {
    return [arrClass indexOfObject:classSize];
}
-(NSInteger) getOrderValue {
    return [arrOrderBy indexOfObject:orderBy];
}
-(NSInteger) getAgeValue {
    if ([arrAgeValue indexOfObject:ageGroup] > 8) {
        return  -1;
    }
    return [arrAgeValue indexOfObject:ageGroup];
}
-(NSInteger) getTimesValue {
    if ([arrTimes indexOfObject:timesValue] > 4) {
        return  5;
    }
    NSInteger v = [arrTimes indexOfObject:timesValue];
    return  (v == 4) ? 5 : v;
}
-(NSInteger) getPriceValue {
    if (price == nil) {
        return 4;
    }
    return  [_arrPriceSlab indexOfObject:price];
}
//arrSessionBy = [[NSMutableArray alloc]initWithObjects:@"Individual (1-to-1)",@"2 - 10",@"10 - 15",@"15+",@"Don't care", nil];
-(NSInteger) getSessionsValue {
    if (_isStringEmpty(_sessions)) {
        return 4;
    }
    if (_sessions.intValue == 1) {
        return 0;
    }else if(_sessions.intValue > 2 && _sessions.intValue < 10){
        return 1;
    }else if(_sessions.intValue > 10 && _sessions.intValue < 15){
        return 2;
    }else if(_sessions.intValue > 15 && _sessions.intValue < 30){
        return 3;
    }else {
        return 4;
    }
}
@end
