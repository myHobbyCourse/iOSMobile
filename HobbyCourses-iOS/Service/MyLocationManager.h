//
//  MyLocationManager.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
@protocol MyLocationManagerDelegate;


@interface MyLocationManager : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, readwrite) double userLatitude;
@property (nonatomic, readwrite) double userLongitude;
@property (nonatomic, readwrite) double userDistance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) CLLocation *CurrentLocation;
@property (nonatomic, strong) NSString *currentAddress;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *cityName;

//@property (nonatomic, readwrite) CLLocationDegrees longitude, latitude;
@property(nonatomic,weak) id <MyLocationManagerDelegate> delegate;

+(MyLocationManager *)sharedInstance;
#pragma mark - Get Current Location
- (void)getCurrentLocation;
- (void)stopUpdatingLocation;
-(void)findAddressFromLocation:(CLLocation*)location;
@end


@protocol MyLocationManagerDelegate <NSObject>

@optional
-(void)location:(MyLocationManager*)locationManager didFoundNewLocation:(CLLocation*)location;
-(void)location:(MyLocationManager*)locationManager address:(NSString*)address;
-(void)location:(MyLocationManager*)locationManager address:(NSString*)address forLat:(double)lat forLong:(double)lng;
-(void)location:(MyLocationManager*)locationManager error:(NSError *)error;
@end

