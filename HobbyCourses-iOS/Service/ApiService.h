//
//  ApiService.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/23/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM (NSInteger, WebServiceResult) {
    WebServiceResultSuccess = 0,
    WebServiceResultFail,
    WebServiceResultError
};

typedef void(^WebCallBlock)(id JSON,WebServiceResult result);

@interface ApiService : NSObject

+ (instancetype) sharedInstance;
- (void) clearURLCache;

typedef void(^RequestCompletionHandler)(NSDictionary *result,NSError *error);
typedef void(^RequestCompletionHandler1)(NSArray *result,NSError *error);


- (NSURLSessionDataTask*)getMethodWithRelativePath:(NSString*)relativePath
                        paramater:(NSDictionary*)param
                            block:(WebCallBlock)block;

- (void)postMethodWithRelativePath:(NSString*)relativePath
                               paramater:(NSDictionary*)param
                                   block:(WebCallBlock)block;

@end
