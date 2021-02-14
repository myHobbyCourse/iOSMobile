//
//  Batches.h
//  HobbyCourses
//
//  Created by iOS Dev on 01/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Batches : NSObject
@property(strong,nonatomic) NSString * startDate;
@property(strong,nonatomic) NSString * endDate;
@property(strong,nonatomic) NSString * price;
//@property(strong,nonatomic) NSString * sold;
@property(strong,nonatomic) NSString * sessions;
@property(strong,nonatomic) NSString * discount;
@property(strong,nonatomic) NSString * batchID;
@property(strong,nonatomic) NSString * classSize;
@property(strong,nonatomic) NSMutableArray<TimeBatch*> *batchesTimes;


@end
