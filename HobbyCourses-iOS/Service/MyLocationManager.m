//
//  NNLocationManager.m
//  Nanwo
//
//  Created by Yudiz Solutions Pvt.Ltd. on 14/08/15.
//  Copyright (c) 2015 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

#import "MyLocationManager.h"
static MyLocationManager *sharedManager;

@implementation MyLocationManager
@synthesize userLatitude;
@synthesize userLongitude;
@synthesize currentAddress;
@synthesize cityName;
+(MyLocationManager *)sharedInstance
{
    if(sharedManager == nil)
    {
        sharedManager = [[MyLocationManager alloc] init];
    }
    return sharedManager;
}

- (void)getCurrentLocation {
    // Create a location manager
    if (!sharedManager.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // Set a delegate to receive location callbacks
    self.locationManager.delegate = self;
    // Check for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
//    [self.locationManager requestAlwaysAuthorization];
    
    // Start the location manager
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
//    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted || status ==  kCLAuthorizationStatusNotDetermined  || [CLLocationManager locationServicesEnabled] == NO) {
        if IsAtLeastiOSVersion(@"8.0") {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location services are off"
                                                           message:@"To use location you must turn on 'Always' in the lcoation services settings"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Settings", nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location services are off"
                                                           message:@"To use location you must turn on 'Always' in the lcoation services settings"
                                                          delegate:nil
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if([self.delegate respondsToSelector:@selector(location:error:)]){
        [self.delegate location:self error:error];
    }
}

#pragma mark - Delegate For IOS6 & Later
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if([locations count] > 0)
    {
        CLLocation *currentLocation = [locations lastObject];
        //        NSLog(@"%s %@",__FUNCTION__, currentLocation);
        if (currentLocation != nil)
        {
            self.CurrentLocation = currentLocation;
            if ([self.delegate respondsToSelector:@selector(location:didFoundNewLocation:)]){
                [self.delegate location:self didFoundNewLocation:currentLocation];
            }
           
            [self findAddressFromLocation:currentLocation];
            self.userLatitude = currentLocation.coordinate.latitude;
            self.userLongitude = currentLocation.coordinate.longitude;

            NSLog(@"userLatitude : %f  \n  userLongitude :%f \n currentAddress :%@",self.userLatitude,self.userLongitude,self.currentAddress);

           [self stopUpdatingLocation];
           
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%s %@",__FUNCTION__, newLocation);
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
//        self.latitude = currentLocation.coordinate.latitude;
//        self.longitude = currentLocation.coordinate.longitude;
        self.userLatitude = currentLocation.coordinate.latitude;
        self.userLongitude = currentLocation.coordinate.longitude;
        self.CurrentLocation = newLocation;
        CLLocationDistance distance = [currentLocation distanceFromLocation:oldLocation];
        NSLog(@"distance :%f",distance);
        if (distance > 0.0) {
            self.userDistance = distance;
        }
       
//        if ([UserDefault objectForKey:kUserAddress] ) {
//            self.currentAddress = [UserDefault valueForKey:kUserAddress];
//        }
        NSLog(@"userLatitude : %f  \n  userLongitude :%f \n currentAddress :%@",self.userLatitude,self.userLongitude,self.currentAddress);

        
        if ([self.delegate respondsToSelector:@selector(location:didFoundNewLocation:)]){
            [self.delegate location:self didFoundNewLocation:newLocation];
        }
        [self stopUpdatingLocation];
    }
    
}


-(void)findAddressFromLocation:(CLLocation*)location 
{
    NSLog(@"findAddressFromLocation %@",location);
    
    if (!self.geoCoder) {
        self.geoCoder = [[CLGeocoder alloc]init];
    }
    [self.geoCoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"geoCoder %@",[error debugDescription]);
         
         if(placemarks.count > 0){
             
             NSDictionary *address =[placemarks[0] addressDictionary];
             NSArray *arr =address[@"FormattedAddressLines"];
             NSString *strAddress =@"";
             for (int i =0; i< [arr count]; i++) {
                 NSString *str =arr[i];
                 if (i != ([arr count] - 1)) {
                     strAddress = [strAddress stringByAppendingString:str];
                     strAddress = [strAddress stringByAppendingString:@","];
                 }else{
                     strAddress = [strAddress stringByAppendingString:str];
                 }
             }
             NSLog(@"%@",strAddress);
             //             [UserDefault setObject:strAddress forKey:kUserAddress];
             //             [UserDefault synchronize];
             self.currentAddress = strAddress;
             self.postalCode = [placemarks[0] postalCode];
             self.cityName = [[placemarks[0] addressDictionary] objectForKey:(NSString*) kABPersonAddressCityKey];

             NSLog(@"postalCode:%@",[placemarks[0] postalCode]);
             
      
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"receivedCity"
              object:self];

         }
         
     }];
    
}


#pragma mark- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
@end
