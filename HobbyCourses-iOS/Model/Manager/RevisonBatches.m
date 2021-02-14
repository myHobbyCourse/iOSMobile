//
//  RevisonBatches.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RevisonBatches.h"

@implementation RevisonBatches
- (id) initWith:(NSDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            self.title = dict[@"title"];
            self.product_id = dict[@"product_id"];
            self.created = dict[@"created"];
            self.arrChanges = [NSMutableArray new];
            [[NetworkManager sharedInstance] postRequestUrl:apiRevisionDetails paramter:@{@"product_id": self.product_id} withCallback:^(NSArray* jsonData, WebServiceResult result) {
                if (result == WebServiceResultSuccess) {
                    if ([jsonData isKindOfClass:[NSArray class]]) {
                        self.changesCount = [NSString stringWithFormat:@"%lu",(unsigned long)jsonData.count];
                        for (NSDictionary *dict in jsonData) {
                            self.revisionDetails = [[Revision alloc]initWith:dict];
                            [self.arrChanges addObject:self.revisionDetails.change_date];
                        }
                        
                        self.complate(self.changesCount);
                    }
                    
                }
            }];
            
        }
        @catch (NSException *exception) { }
    }
    return self;
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.complate = refreshBlock;
}
@end
