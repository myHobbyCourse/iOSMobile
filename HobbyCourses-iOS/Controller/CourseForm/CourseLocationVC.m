//
//  CourseLocationVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 18/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseLocationVC.h"
@import GooglePlaces;

@interface CourseLocationVC () <GMSAutocompleteViewControllerDelegate> {
    NSMutableArray *addressDataArray;
    NSMutableArray<VenuesEntity*> *arrVenues;
    NSURLSessionDataTask *task;
   // GMSPlacePicker *_placePicker;
}

@end

@implementation CourseLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblSearch.estimatedRowHeight = 50;
    tblSearch.rowHeight = UITableViewAutomaticDimension;
    arrVenues= [NSMutableArray new];
    [self getVenueList];
    [self hideShowTable];
    [tblParent reloadData];
    [self fetchUserLocation];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course Map Screen"];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tblSearch reloadData];
    UITableViewCell *cell = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    _topSearch.constant = cell.frame.origin.y + ((is_iPad()) ? 85: 55);
}
-(void) fetchUserLocation{
    [self startActivity];
    [[UserLocation sharedInstance] fetchUserLocationForOnce:self block:^(CLLocation * location, NSError * error) {
        [self stopActivity];
        if (location) {
            [MyLocationManager sharedInstance].userLatitude = location.coordinate.latitude;
            [MyLocationManager sharedInstance].userLongitude = location.coordinate.longitude;
        }
    }];
}
-(void) hideShowTable{
    if (addressDataArray.count == 0) {
        tblSearch.hidden = true;
    }else{
        tblSearch.hidden = false;
    }
}
-(IBAction)btnVenue:(UIButton*)sender {
    ValueSelectorVC  *vc =(ValueSelectorVC*) [getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"ValueSelectorVC"];
    vc.screenTitle = @"Select SubCategory";
    NSMutableArray *arr = [NSMutableArray new];
    for (VenuesEntity *obj  in arrVenues) {
        [arr addObject:obj.venue_name];
    }
    vc.arrTittle = arr;
    vc.type = SelectionTypeVenue;
    [vc getRefreshBlock:^(NSString *anyValue) {
        if ([anyValue isEqualToString:@"-1"]) {
            dataClass.crsVenueName =@"";
            dataClass.crsVenueCoDict = nil;
        }else{
            
            dataClass.crsVenueName = arrVenues[[anyValue intValue]].venue_name;
            dataClass.crsVenueCoDict = @{@"lat":arrVenues[[anyValue intValue]].latitude,@"lng":arrVenues[[anyValue intValue]].longitude};
            double latdouble = [arrVenues[[anyValue intValue]].latitude doubleValue];
            double londouble = [arrVenues[[anyValue intValue]].longitude doubleValue];
            
            //Create coordinate
            CLLocationCoordinate2D loc = {(latdouble),(londouble)};
            CLLocation *locationObj = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
            
            FormLocationCell *cell = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:loc];
            [annotation setTitle:dataClass.crsAddress]; //You can set the subtitle too
            [cell.mapView addAnnotation:annotation];
            MKCoordinateRegion adjustedRegion = [cell.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(loc, 200, 200)];
            [cell.mapView setRegion:adjustedRegion];
            
            [self findAddressFromLocation:locationObj];
            
        }
        [tblParent reloadData];
    }];
    [self.navigationController pushViewController:vc animated:true];
    
}
-(IBAction)btnNext:(UIButton*)sender{
    if([self checkStringValue:dataClass.crsAddress]){
        showAletViewWithMessage(@"Where on planet Earth? Please enter your Course Address Location");
        return;
    }
    FromDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"FromDetailsVC"];
    [self.navigationController pushViewController:vc animated:true];
    
}
#pragma mark API Calls
-(void) getVenueList {
    [self startActivity];
    [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@",apiVenueList,APPDELEGATE.userCurrent.uid] paramter:nil isToken:true withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                VenuesEntity * objTutor = [[VenuesEntity alloc]initWith:d];
                [arrVenues addObject:objTutor];
            }
            [tblParent reloadData];
        }
    }];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblSearch) {
        return addressDataArray.count;
    }else{
        return 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblParent && indexPath.row ==0 && arrVenues.count == 0) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblSearch) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
        UILabel *lblAddress = [cell viewWithTag:44];
        lblAddress.text = addressDataArray[indexPath.row][@"description"];
        return cell;
    }else{
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 1) {
            UIView *viewBorder = [cell viewWithTag:11];
            viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
            viewBorder.layer.borderWidth = 1.0;
            viewBorder.layer.cornerRadius = 8;
            UITextField *tf = [cell viewWithTag:12];
            NSString *a = dataClass.crsAddress;
            if (dataClass.crsAddress == nil || [dataClass.crsAddress isKindOfClass:[NSNull class]]) {
                a = @"";
            }
            NSString *b = dataClass.crsAddress1;
            if (dataClass.crsAddress1 == nil || [dataClass.crsAddress1 isKindOfClass:[NSNull class]]) {
                b = @"";
            }
            NSString *c = dataClass.crsPincode;
            if (dataClass.crsPincode == nil || [dataClass.crsPincode isKindOfClass:[NSNull class]]) {
                c = @"";
            }
            NSString *final = [NSString stringWithFormat:@"%@ %@ %@",a,b,c];
            tf.text = (_isStringEmpty(final)) ? @"Tap here to select location" : final;
        }else if (indexPath.row == 2){
            FormLocationCell *cellObj = cell;
            if (!_isStringEmpty(dataClass.crslat)) {
                NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",dataClass.crslat,dataClass.crslng,@"zoom=15&size=450x300"];
                NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                UIImageView *imgV = [cell viewWithTag:11];
                [cellObj.imgVMap sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
            }else if([MyLocationManager sharedInstance].userLongitude){
                NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%f,%f&%@&sensor=true",[MyLocationManager sharedInstance].userLatitude,[MyLocationManager sharedInstance].userLongitude,@"zoom=15&size=450x300"];
                NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                UIImageView *imgV = [cell viewWithTag:11];
                [cellObj.imgVMap sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
            }
        }else{
            UITextField *tfVenue = [cell viewWithTag:11];
            tfVenue.text = dataClass.crsVenueName;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblSearch) {
        NSString *reference = addressDataArray[indexPath.row][@"reference"];
        [self startActivity];
        [task cancel];
        task = [[NetworkManager sharedInstance] getLatLongFromGoogleWithReference:reference completionBlock:^(id JSON, WebServiceResult result) {
            [self stopActivity];
            NSMutableArray *cordinateDataArray = [[NSMutableArray alloc]init];
            if (WebServiceResultSuccess == result) {
                HCLog(@"%@",JSON);
                if ([JSON[@"status"] isEqualToString:@"OK"]) {
                    if ([JSON[@"result"] isKindOfClass:[NSDictionary class]]) {
                        [cordinateDataArray addObject:JSON[@"result"]];
                    }else{
                        cordinateDataArray = JSON[@"result"];
                    }
                    dataClass.crsAddress = cordinateDataArray[0][@"formatted_address"];
                    dataClass.crsCordinateDict = cordinateDataArray[0][@"geometry"][@"location"];
                    
                    tableView.hidden = true;
                    [tblParent reloadData];
                    FormLocationCell *cell = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([dataClass.crsCordinateDict[@"lat"] floatValue], [dataClass.crsCordinateDict[@"lng"] floatValue]);
                    [annotation setCoordinate:loc];
                    [annotation setTitle:dataClass.crsAddress]; //You can set the subtitle too
                    [cell.mapView addAnnotation:annotation];
                    int rr = (is_iPad()) ? 800 : 200;
                    MKCoordinateRegion adjustedRegion = [cell.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(loc, rr, rr)];
                    [cell.mapView setRegion:adjustedRegion];
                    CLLocation *locationObj = [[CLLocation alloc] initWithLatitude:loc.latitude longitude:loc.longitude];
                    [self findAddressFromLocation:locationObj];
                    
                }else {
                    showAletViewWithMessage(kFailAPI);
                }
            }
        }];
    }else{
        
        if ((indexPath.row == 1 || indexPath.row == 2)) {
            VenueListVC *vc =  [[UIStoryboard storyboardWithName:@"Venue" bundle: nil] instantiateViewControllerWithIdentifier:@"VenueListVC"];
            vc.isSelectLocation = true;
            [vc getRefreshBlock:^(id anyValue) {
                VenuesEntity *venue = (VenuesEntity*)anyValue;
                NSMutableArray *arrLocation = [NSMutableArray new];
                    dataClass.crsAddress = venue.venue_name;
                    [arrLocation addObject:dataClass.crsAddress];
                    
                    dataClass.crsAddress1 = venue.address;
                    [arrLocation addObject:dataClass.crsAddress1];
                
    
                    dataClass.crsCity = venue.address1;
                    [arrLocation addObject:dataClass.crsCity];
                
                    dataClass.crsPincode = venue.pincode;
                    [arrLocation addObject:dataClass.crsPincode];
                
                dataClass.crslat = venue.latitude;
                dataClass.crslng = venue.longitude;
                
                [arrLocation addObject:dataClass.crslat];
                [arrLocation addObject:dataClass.crslng];
                
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:arrLocation feildName:FeildNameLocation];
                
                [tblParent reloadData];
                [tblSearch reloadData];
            }];
            if (is_iPad()) {
                vc.modalPresentationStyle = UIModalPresentationPopover;
                [self presentViewController:vc animated:YES completion:nil];

                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UITextField *tf = [cell viewWithTag:12];
                [self configuraModalPopOver:tf controller:vc];
            }else{
                [self.navigationController pushViewController:vc animated:true];
            }
            return;
            if ([MyLocationManager sharedInstance].userLatitude) {
                [self openGooglePicker];
            }else{
                [[UserLocation sharedInstance] fetchUserLocationForOnce:self block:^(CLLocation * location, NSError * error) {
                    if (location) {
                        [MyLocationManager sharedInstance].userLatitude = location.coordinate.latitude;
                        [MyLocationManager sharedInstance].userLongitude = location.coordinate.longitude;
                        [self openGooglePicker];
                    }
                }];
            }
            
        }
    }
}
-(void) openGooglePicker{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake([MyLocationManager sharedInstance].userLatitude, [MyLocationManager sharedInstance].userLongitude);
//    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
//                                                                  center.longitude + 0.001);
//    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
//                                                                  center.longitude - 0.001);
//    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
//                                                                         coordinate:southWest];
//    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
  //  GMSPlacePickerViewController *placePicker =
    //[[GMSPlacePickerViewController alloc] initWithConfig:config];

    
    //Commented by Vinod Jat for testig the app
    /*
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        if (place == nil) {
            return;
        }
        NSMutableArray *arrLocation = [NSMutableArray new];
        NSArray *arr = [place.formattedAddress componentsSeparatedByString:@", "];
        if (arr.count > 1) {
            
            dataClass.crsAddress = arr[0];
            [arrLocation addObject:dataClass.crsAddress];
            
            dataClass.crsAddress1 = arr[1];
            [arrLocation addObject:dataClass.crsAddress1];
        }
        for(GMSAddressComponent *obj in place.addressComponents){
            NSLog(@"%@",obj.type);
            NSLog(@"%@",obj.name);
            if ([obj.type isEqualToString:@"locality"] || [obj.type isEqualToString:@"postal_town"]) {
                dataClass.crsCity = obj.name;
                [arrLocation addObject:dataClass.crsCity];
            }else if ([obj.type isEqualToString:@"postal_code"]){
                dataClass.crsPincode = obj.name;
                [arrLocation addObject:dataClass.crsPincode];
            }
        }
        if (place.addressComponents == nil) {
            [arrLocation addObject:@""];
            [arrLocation addObject:@""];
        }
        dataClass.crslat = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
        dataClass.crslng = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
        
        [arrLocation addObject:[NSString stringWithFormat:@"%f",place.coordinate.latitude]];
        [arrLocation addObject:[NSString stringWithFormat:@"%f",place.coordinate.longitude]];
        
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:arrLocation feildName:FeildNameLocation];
        
        [tblParent reloadData];
        [tblSearch reloadData];
    }];*/
}
-(void)findAddressFromLocation:(CLLocation*)location
{
    if (location == nil) {
        return;
    }
    CLGeocoder *geoCoder;
    if (!geoCoder) {
        geoCoder = [[CLGeocoder alloc]init];
    }
    [self startActivity];
    __weak CourseLocationVC *weakSelf = self;
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       NSLog(@"geoCoder %@",[error debugDescription]);
                       [self stopActivity];
                       if(placemarks.count > 0) {
                           NSMutableArray *arrLocation = [NSMutableArray new];
                           
                           /*if (![weakSelf checkStringValue:[placemarks[0] thoroughfare]]) {
                               dataClass.crsAddress = [placemarks[0] thoroughfare];
                               [arrLocation addObject:dataClass.crsAddress];
                           }else{ [arrLocation addObject:@""]; }
                           
                           if (![weakSelf checkStringValue:[placemarks[0] subThoroughfare]]) {
                               dataClass.crsAddress1 = [placemarks[0] subThoroughfare];
                               [arrLocation addObject:dataClass.crsAddress1];
                           }else{ [arrLocation addObject:@""]; }*/
                           
                           if (![weakSelf checkStringValue:[placemarks[0] locality]]) {
                               dataClass.crsCity = [placemarks[0] locality];
                               [arrLocation addObject:dataClass.crsCity];
                           }else{ [arrLocation addObject:@""]; }
                           
                           if (![weakSelf checkStringValue:[placemarks[0] postalCode]]) {
                               dataClass.crsPincode = [placemarks[0] postalCode];
                               [arrLocation addObject:dataClass.crsPincode];
                           }else{ [arrLocation addObject:@""]; }
                           
                           [arrLocation addObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude]];
                           [arrLocation addObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude]];
                           
                           [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:arrLocation feildName:FeildNameLocation];
                       }
                   }];
    
}
#pragma mark - UITextFeild Delegate
-(IBAction)searchTextValueChange:(UITextField*)textField {
    NSString *place = [textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (textField.text.length > 0) {
        [[NetworkManager sharedInstance] getAddressFromGoogleWithName:place completionBlock:^(id JSON, WebServiceResult result) {
            if (result == WebServiceResultSuccess) {
                addressDataArray = [[NSMutableArray alloc]init];
                if ([JSON[@"status"] isEqualToString:@"OK"]) {
                    
                    if ([JSON[@"predictions"] isKindOfClass:[NSDictionary class]]) {
                        [addressDataArray addObject:JSON[@"predictions"]];
                    }else{
                        addressDataArray = [JSON[@"predictions"] mutableCopy];
                    }
                    
                }else if ([JSON[@"status"] isEqualToString:@"ZERO_RESULTS"]) {
                    NSDictionary *noresult = @{@"description" : @"No Result Found"};
                    [addressDataArray addObject:noresult];
                    
                }
            }
            [tblSearch reloadData];
        }];
    }else
    {
        [addressDataArray removeAllObjects];
        [tblSearch reloadData];
    }
    [self hideShowTable];
}
#pragma mark - UITextField
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [tblParent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place ID %@", place.placeID);
    NSLog(@"Place attributions %@", place.attributions.string);
    NSMutableArray *arrLocation = [NSMutableArray new];
    NSArray *arr = [place.formattedAddress componentsSeparatedByString:@", "];
    if (arr.count > 1) {
        
        dataClass.crsAddress = arr[0];
        [arrLocation addObject:dataClass.crsAddress];
        
        dataClass.crsAddress1 = arr[1];
        [arrLocation addObject:dataClass.crsAddress1];
    }
    for(GMSAddressComponent *obj in place.addressComponents){
        NSLog(@"%@",obj.type);
        NSLog(@"%@",obj.name);
        if ([obj.type isEqualToString:@"locality"] || [obj.type isEqualToString:@"postal_town"]) {
            dataClass.crsCity = obj.name;
            [arrLocation addObject:dataClass.crsCity];
        }else if ([obj.type isEqualToString:@"postal_code"]){
            dataClass.crsPincode = obj.name;
            [arrLocation addObject:dataClass.crsPincode];
        }
    }
    if (place.addressComponents == nil) {
        [arrLocation addObject:@""];
        [arrLocation addObject:@""];
    }
    dataClass.crslat = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
    dataClass.crslng = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
    
    [arrLocation addObject:[NSString stringWithFormat:@"%f",place.coordinate.latitude]];
    [arrLocation addObject:[NSString stringWithFormat:@"%f",place.coordinate.longitude]];
    
    [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:arrLocation feildName:FeildNameLocation];
    
    [tblParent reloadData];
    [tblSearch reloadData];
    
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}





@end
