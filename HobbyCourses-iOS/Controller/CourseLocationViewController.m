//
//  CourseLocationViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseLocationViewController.h"
#import "MapPin.h"
@class CourseMapPop;

@interface CourseLocationViewController ()<MKMapViewDelegate>
{
    IBOutlet NSLayoutConstraint *heightPopup;
    IBOutlet UIImageView *img1;
    IBOutlet UILabel *lblStartDate;
    IBOutlet UILabel *lblEndDate;
    IBOutlet UILabel *lblPrice;
    IBOutlet UILabel *lblDiscount;
    IBOutlet NSLayoutConstraint *widthView;
    
    NSMutableArray *arrCategory;
    NSIndexPath *selectedCatIndex;
    IBOutlet MKMapView *mapview;
    CLLocationCoordinate2D location;
    CLLocation *coursePoint;
    BOOL isLocation;
    BOOL isSetRegion;
}
@end

@implementation CourseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrCategory = [[NSMutableArray alloc]init];
    NSData *data = [UserDefault objectForKey:kCategoryKey];
    if (data)
    {
        NSArray *arrCat = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        for (NSDictionary *dict in arrCat)
        {
            CategoryEntity *entity = [[CategoryEntity alloc]initWithDictionary:dict];
            [arrCategory addObject:entity];
            
        }
        [tblCategory reloadData];
    }
    
    viewCategory.hidden = YES;
    mapview.delegate =self;
    btnCateory.titleLabel.numberOfLines = 0;
    
    [[MyLocationManager sharedInstance] getCurrentLocation];
    
    if (self.isFromDetail)
    {
        if (![self checkStringValue:self.selectedCourse.latitude] && ![self checkStringValue:self.selectedCourse.longitude] )
        {
            
            CLLocation *location1 = [[CLLocation alloc] initWithLatitude: [self.selectedCourse.latitude doubleValue]
                                                               longitude: [self.selectedCourse.longitude doubleValue]];
            [self plotPin:self.selectedCourse location:location1];
            
        }
        
    }else
    {
        for (CourseDetail *course in self.arrayCourseList)
        {
            if (![self checkStringValue:course.latitude] && ![self checkStringValue:course.longitude] )
            {
                
                CLLocation *location1 = [[CLLocation alloc] initWithLatitude: [course.latitude doubleValue]
                                                                   longitude: [course.longitude doubleValue]];
                [self plotPin:course location:location1];
                
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course Map Screen"];
}



-(void) plotPin:(id) obj location:(CLLocation*) coordinate
{
    NSMutableArray *annotationArray = [NSMutableArray array];
    
    if ([obj isKindOfClass:[CourseDetail class]])
    {
        CourseDetail *course = obj;
        MapPin *pin = [[MapPin alloc] initWithCoordinates:coordinate.coordinate placeName:course.title description:@"" courseId:course.nid];
        [annotationArray addObject:pin];
        
    }else
    {
        Course *course = obj;
        MapPin *pin = [[MapPin alloc] initWithCoordinates:coordinate.coordinate placeName:course.title description:@"" courseId:course.nid];
        [annotationArray addObject:pin];
    }
    [mapview addAnnotations:annotationArray];
    if (self.selectedCourse == nil && !isSetRegion)
    {
        MapPin *pin = [annotationArray firstObject];
        [self drawMap:pin.coordinate];
        isSetRegion = true;
    }
    if (obj == self.selectedCourse) {
        MapPin *pin = [annotationArray firstObject];
        [self drawMap:pin.coordinate];
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    
    viewCourseRound.layer.cornerRadius = 10;
    viewCourseRound.layer.masksToBounds =YES;
    btnViewCourse.layer.cornerRadius =10.0;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        // Do something when in landscape
        widthView.constant = self.view.frame.size.width * 0.5;
        
    }
    else
    {
        // Do something when in portrait
        widthView.constant = self.view.frame.size.width * 0.7;
        
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnCurrentLocation:(id)sender
{
    if (isLocation || ([MyLocationManager sharedInstance].userLatitude  && [MyLocationManager sharedInstance].userLongitude))
    {
        [self drawMap:location];
    }
}

#pragma mark - MapView mwthod
-(void)drawMap:(CLLocationCoordinate2D)center{
    
    //user location
    double miles = 5.0;
    double scalingFactor = ABS( (cos(2 * M_PI * center.latitude / 360.0) ));
    
    //span
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    //creating Region
    MKCoordinateRegion region;
    region.span = span;
    region.center = center;
    [mapview setRegion:region animated:YES];
}
#pragma mark - MKMap View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (userLocation != nil) {
        location = CLLocationCoordinate2DMake([[userLocation location] coordinate].latitude, [[userLocation location] coordinate].longitude);
        isLocation = true;
        //        [self drawMap:location];
        
    }
    
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    NSLog(@"Failed to Get Current Location..!! %@",[error localizedDescription]);
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *aid=@"aid";
    if([annotation isKindOfClass:[MapPin class]])
    {
        NSLog(@"Callllled");
        MKAnnotationView *annotationView;//=[mapView dequeueReusableAnnotationViewWithIdentifier:aid];
        if(!annotationView)
        {
            annotationView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:aid];
            annotationView.canShowCallout = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [button addTarget:self
                       action:@selector(viewDetails:) forControlEvents:UIControlEventTouchUpInside];
            MapPin *mappin = annotation;
            button.tag = [mappin.courseId intValue];
            annotationView.rightCalloutAccessoryView = button;
        }
        
        return annotationView;
    }
    return nil;
}
-(IBAction)btnSearchCourse:(id)sender
{
    if (selectedCatIndex)
    {
        CategoryEntity *obj = arrCategory[selectedCatIndex.row];
        
        NSDictionary *dict = @{@"city":APPDELEGATE.selectedCity,@"category":obj.category,@"page":@"1"};
        [self getCourseApi:dict];
    }
}
-(IBAction)viewDetails:(UIButton*)sender
{
    NSArray *arrSearch;
    if (self.isFromDetail)
    {
        arrSearch = [[NSArray alloc]initWithObjects:self.selectedCourse, nil];
    }else{
        NSString *courseId = [NSString stringWithFormat:@"%d",sender.tag];
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.nid == %@", courseId];
        
        arrSearch = [self.arrayCourseList filteredArrayUsingPredicate:resultPredicate];
    }
    
    if (arrSearch.count>0)
    {
        id course = [arrSearch firstObject];
        if ([course isKindOfClass:[Course class]])
        {
            Course *course = [arrSearch firstObject];
          
            if (![self checkStringValue:course.latitude] && ![self checkStringValue:course.longitude]) {
                coursePoint = [[CLLocation alloc] initWithLatitude: [course.latitude doubleValue]
                                                                   longitude: [course.longitude doubleValue]];
            }
            CourseMapPop *alert =  [CourseMapPop instanceFromNib:course.title withMessage:course.descriptions.removeHTML     controller:self block:^(Tapped tapped, CourseMapPop *alert) {
                
                if (tapped == TappedDismiss) {
                    UIButton *btn = [[UIButton alloc] init];
                    btn.tag = sender.tag;
                    [self btnCouseNav:btn];
                    
                }else if(tapped == TappedOkay){
                    [self btnDirection:nil];
                }
                [alert removeFromSuperview];
            }];
            [APPDELEGATE.window addSubview:alert];

        }else{
            CourseDetail *course = [arrSearch firstObject];
            if (![self checkStringValue:course.latitude] && ![self checkStringValue:course.longitude] )
            {
                coursePoint = [[CLLocation alloc] initWithLatitude: [course.latitude doubleValue]
                                                         longitude: [course.longitude doubleValue]];
            }
            
            CourseMapPop *alert =  [CourseMapPop instanceFromNib:course.title withMessage:course.Description.removeHTML     controller:self block:^(Tapped tapped, CourseMapPop *alert) {
                
                if (tapped == TappedDismiss) {
                    UIButton *btn = [[UIButton alloc] init];
                    btn.tag = sender.tag;
                    [self btnCouseNav:btn];
                    
                }else if(tapped == TappedOkay){
                    [self btnDirection:nil];
                }
                [alert removeFromSuperview];
            }];
            [APPDELEGATE.window addSubview:alert];
        }
        
    }
    
   
}
-(void) btnCouseNav:(UIButton*) sender {
    if (self.isFromDetail) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"GoToCourseDetail" sender:sender];
    }
}

-(IBAction)btnSearchLocation:(id)sender {
    SelectCityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
    vc.view.backgroundColor = [UIColor clearColor];
    vc.isShowbtn = true;
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [vc getCityBlock:^(NSString *anyValue) {
        isSetRegion = false;
        tfSearchLocation.text = anyValue;
        if (selectedCatIndex)
        {
            CategoryEntity *obj = arrCategory[selectedCatIndex.row];
            NSDictionary *dict = @{@"city":tfSearchLocation.text,@"category":obj.category,@"page":@"1",@"form":@"1"};
            [self getCourseApi:dict];
        }else
        {
            NSDictionary *dict = @{@"city":tfSearchLocation.text,@"page":@"1",@"form":@"1"};
            [self getCourseApi:dict];
        }
    }];
    [self presentViewController:vc animated:NO completion:nil];
    
}
-(void) getCourseApi:(NSDictionary*)dict
{
    [self startActivity];
    
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        NSLog(@"%@",jsonData);
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                showAletViewWithMessage(@"If at first you don’t succeed…please select Course for selected criteria and try again.");
                return;
            }
            if (jsonData[@"results"]) {
                NSArray * arr =  jsonData[@"results"];
                if ([arr isKindOfClass:[NSArray class]])
                {
                    NSArray *arr = jsonData;
                    if (self.arrayCourseList == nil) {
                        self.arrayCourseList = [[NSMutableArray alloc]init];
                        [self.arrayCourseList removeAllObjects];
                    }

                    for (NSDictionary *dict in arr)
                    {
                        if ([dict isKindOfClass:[NSDictionary class]])
                        {
                            Course *courseEnt = [[Course alloc]initWith:dict];
                            [self.arrayCourseList addObject:courseEnt];
                        }
                    }
                    
                    id userLocation = [mapview userLocation];
                    [mapview removeAnnotations:[mapview annotations]];
                    
                    if ( userLocation != nil ) {
                        [mapview addAnnotation:userLocation]; // will cause user location pin to blink
                        [mapview setShowsUserLocation:YES];
                    }
                    
                    for (Course *course in self.arrayCourseList)
                    {
                        if (![self checkStringValue:course.latitude] && ![self checkStringValue:course.longitude] )
                        {
                            CLLocation *location1 = [[CLLocation alloc] initWithLatitude: [course.latitude doubleValue]
                                                                               longitude: [course.longitude doubleValue]];
                            [self plotPin:course location:location1];}
                        
                    }
                }
            }
        }else{
            showAletViewWithMessage(@"Earthly error…No courses found for entered location or category.");
        }
    }];
    
}
-(IBAction)btnDirection:(UIButton*)sender {
    
    NSString* url = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",mapview.userLocation.coordinate.latitude, mapview.userLocation.coordinate.longitude, coursePoint.coordinate.latitude, coursePoint.coordinate.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}
- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.7;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.5;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.5;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.7;
            break;
            
        default:
            break;
    };
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GoToCourseDetail"]) {
        CourseDetailsVC *view = segue.destinationViewController;
        UIButton *btn = sender;
        view.NID = [NSString stringWithFormat:@"%ld",(long)btn.tag];
        view.similerCourses = self.arrayCourseList;
    }
}


@end
