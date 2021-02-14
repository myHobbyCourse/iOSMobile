//
//  NetworkManager.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 23/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype) sharedInstance;

-(void) postRequestUrl:(NSString*) relUrl paramter:(NSDictionary*)param withCallback:(void (^)(id jsonData,WebServiceResult result))callback;

-(void) getRequestUrl:(NSString*) relUrl paramter:(NSDictionary*)param isToken:(BOOL) isAddToken withCallback:(void (^)(id jsonData,WebServiceResult result))callback;

-(void) postRequestFullUrl:(NSString*) relUrl paramter:(NSDictionary*)param withCallback:(void (^)(id jsonData,WebServiceResult result))callback;

- (NSURLSessionDataTask*)getAddressFromGoogleWithName:(NSString *)name completionBlock:(WebCallBlock)block;
- (NSURLSessionDataTask*)getLatLongFromGoogleWithReference:(NSString *)reference completionBlock:(WebCallBlock)block;
@end
