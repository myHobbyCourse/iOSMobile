//
//  RevisonBatches.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Revision.h"

@interface RevisonBatches : NSObject
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *product_id;
@property(strong,nonatomic) NSString *created;
@property(strong,nonatomic) NSString *changesCount;
@property(strong,nonatomic) NSMutableArray *arrChanges;
@property(strong,nonatomic) RefreshBlock complate;
@property(strong,nonatomic) Revision * revisionDetails;

- (id) initWith:(NSDictionary*)dict;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
