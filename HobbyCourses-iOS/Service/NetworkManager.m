//
//  NetworkManager.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 23/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (instancetype) sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void) postRequestUrl:(NSString*) relUrl paramter:(NSDictionary*)param withCallback:(void (^)(id jsonData,WebServiceResult result))callback
{
    [[ApiService sharedInstance] postMethodWithRelativePath:relUrl paramater:param block:^(id JSON, WebServiceResult result) {
        if(result == WebServiceResultSuccess){
            callback(JSON,WebServiceResultSuccess);
            
        }else{
            callback(JSON,WebServiceResultError);
            
        }
    }];
}
-(void) postRequestFullUrl:(NSString*) relUrl paramter:(NSDictionary*)param withCallback:(void (^)(id jsonData,WebServiceResult result))callback
{
    [[ApiService sharedInstance] postMethodWithRelativePath:relUrl paramater:param block:^(id JSON, WebServiceResult result) {
        if(result == WebServiceResultSuccess){
            callback(JSON,WebServiceResultSuccess);
            
        }else{
            callback(JSON,WebServiceResultError);
            
        }
    }];
}


-(void) getRequestUrl:(NSString*) relUrl paramter:(NSDictionary*)param isToken:(BOOL) isAddToken withCallback:(void (^)(id jsonData,WebServiceResult result))callback
{
    // [[ApiService sharedInstance] getMethodWithRelativePath:relUrl paramater:param block:block];

    NSLog(@"Request URL : %@",relUrl);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",relUrl]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:(is_iPad()) ? @"ipad" : @"iphone"  forHTTPHeaderField:@"X-Apple-Device-Type"];
    
    [request setValue:@"*/*" forHTTPHeaderField:@"Accepet"];
    
    if (APPDELEGATE.userCurrent.token && isAddToken)
    {
        NSLog(@"CF Token %@",APPDELEGATE.userCurrent.token);
        [request setValue:APPDELEGATE.userCurrent.token forHTTPHeaderField:@"X-CSRF-Token"];
        
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
    completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error == nil) {
                  NSError *parseError = nil;
                  NSString *someString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  HCLog(@"%@",someString);
                  id dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                  if (dictionary) {
                      //NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                      if ([dictionary isKindOfClass:[NSArray class]]) {
                          NSArray *arr = dictionary;
                          if (arr.count > 0) {
                              if ([arr[0] isKindOfClass:[NSString class]]) {
                                  if ([arr[0] isEqualToString:@"Access denied for user anonymous"]) {
                                      showAletViewWithMessage(@"Time’s up. The session has expired and you’ll need to login again");
                                      for (id key in [UserDefault dictionaryRepresentation]) {
                                          [UserDefault removeObjectForKey:key];
                                      }
                                      [UserDefault synchronize];
                                      APPDELEGATE.selectedCity = @"";
                                      UINavigationController *nav =[getStoryBoardDeviceBased((is_iPad()) ? StoryboardMain : StoryboardEntry) instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
                                      SpalshViewController *v2 = nav.viewControllers[0];
                                      v2.isDirectMove = true;
                                      APPDELEGATE.window.rootViewController = nav;
                                      
                                      return;
                                      
                                  }
                              }
                          }
                          
                          
                      }
                      callback(dictionary,WebServiceResultSuccess);
                  }else{
                      callback(dictionary,WebServiceResultError);
                  }
              }else{
                  callback(error.description,WebServiceResultError);
              }
          });
      }];
    
    [task resume];
}
- (NSURLSessionDataTask*)getAddressFromGoogleWithName:(NSString *)name completionBlock:(WebCallBlock)block
{
    NSString *path = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=false&key=%@",name,googleKey];
    return [[ApiService sharedInstance] getMethodWithRelativePath:path paramater:nil block:block];
    
}
- (NSURLSessionDataTask*)getLatLongFromGoogleWithReference:(NSString *)reference completionBlock:(WebCallBlock)block
{
    NSString *path = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=%@",reference,googleKey];
    return [[ApiService sharedInstance] getMethodWithRelativePath:path
                                                        paramater:nil
                                                            block:block];
}
@end
