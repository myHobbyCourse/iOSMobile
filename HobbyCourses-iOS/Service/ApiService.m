//
//  ApiService.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/23/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ApiService.h"
#import "AFNetworking.h"
@implementation ApiService

static AFHTTPSessionManager *manager;


+ (instancetype) sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
+ (void)initialize
{
    manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBasePath]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.reachabilityManager startMonitoring];
}

-(void) clearURLCache {
    // Delete any cached URLrequests!
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
    
    // Also delete all stored cookies!
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    id cookie;
    for (cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    
    /* NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
     if ([credentialsDict count] > 0) {
     // the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
     NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
     id urlProtectionSpace;
     // iterate over all NSURLProtectionSpaces
     while (urlProtectionSpace = [protectionSpaceEnumerator nextObject]) {
     NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
     id userName;
     // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
     while (userName = [userNameEnumerator nextObject]) {
     NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
     //NSLog(@"credentials to be removed: %@", cred);
     [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
     }
     }
     } */
    
}
- (NSURLSessionDataTask *)getMethodWithRelativePath:(NSString*)relativePath
                                          paramater:(NSDictionary*)param
                                              block:(WebCallBlock)block
{
    NSLog(@"realtivePath: %@",relativePath);
    NSLog(@"paramaters : %@",param);
    [manager.requestSerializer setValue:(is_iPad()) ? @"ipad" : @"iphone"  forHTTPHeaderField:@"X-Apple-Device-Type"];
    [manager.requestSerializer setValue:APPDELEGATE.userCurrent.token forHTTPHeaderField:@"X-CSRF-Token"];
    return  [manager GET:relativePath parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *parseError = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
            block(responseObject,WebServiceResultSuccess);
        }else {
            @try {
                id dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&parseError];
                if (dictionary) {
                    block(dictionary,WebServiceResultSuccess);
                }else{
                    block(dictionary,WebServiceResultError);
                }
            } @catch (NSException *exception) {
                HCLog(@"Error in parsing");
                block(responseObject,WebServiceResultError);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(error,WebServiceResultError);
    }];
}

- (void)postMethodWithRelativePath:(NSString*)relativePath
                         paramater:(NSDictionary*)param
                             block:(WebCallBlock)block
{
    NSLog(@"realtivePath: %@",relativePath);
    NSLog(@"paramaters : %@",convertObjectToJson(param));
    
    [manager.requestSerializer setValue:APPDELEGATE.userCurrent.token forHTTPHeaderField:@"X-CSRF-Token"];
    [manager.requestSerializer setValue:(is_iPad()) ? @"ipad" : @"iphone"  forHTTPHeaderField:@"X-Apple-Device-Type"];
    [manager.requestSerializer  setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:relativePath parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject,WebServiceResultSuccess);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        
        if (errorData != nil){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
            NSLog(@"Respose : %@",serializedData);
            
            if (serializedData) {
                block(serializedData,WebServiceResultError);
            }else{
                block(error,WebServiceResultError);
            }
        }else{
            block(error,WebServiceResultError);
        }
        
    }];
}

@end
