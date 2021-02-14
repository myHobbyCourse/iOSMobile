//
//  AddVenueVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 30/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AddVenueVC_iPad.h"
#import "MBProgressHUD.h"

@import GooglePlaces;
@import GooglePlacePicker;

@interface AddVenueVC_iPad ()<UploadManagerDelegate,GMSAutocompleteViewControllerDelegate>
{
    IBOutlet UITableView *tblLeft;
    IBOutlet UITableView *tblRight;
    IBOutlet UIView *viewShadow;
    NSInteger currentIndex;
    NSMutableArray<VenuesEntity*> *arrVenues;
   // GMSPlacePicker *_placePicker;
    MBProgressHUD *hud;

}
@end

@implementation AddVenueVC_iPad
@synthesize selectedVenue;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addShaowForiPad:viewShadow];
    tblRight.estimatedRowHeight = 100;
    tblRight.rowHeight = UITableViewAutomaticDimension;
    tblLeft.estimatedRowHeight = 100;
    tblLeft.rowHeight = UITableViewAutomaticDimension;
    tblLeft.tableFooterView = [UIView new];
    arrVenues = [NSMutableArray new];
    currentIndex = -1;
    
    if (is_iPad()) {
        [self getVenueList];
    }else if (self.selectedVenue != nil){
        [arrVenues addObject:self.selectedVenue];
    }else{
        [self btnAddNewVenue:nil];
    }
    
    [tblRight reloadData];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Add Venue Screen"];
}
-(BOOL) isValid {
    if (_isStringEmpty(selectedVenue.venue_name)) {
        showAletViewWithMessage(@"Please enter venue name");
        return false;
    }
    if (_isStringEmpty(selectedVenue.venue_details)) {
        showAletViewWithMessage(@"Please enter venue description");
        return false;
    }
    if (_isStringEmpty(selectedVenue.pincode)) {
        showAletViewWithMessage(@"Please enter postal code");
        return false;
    }
    if (_isStringEmpty(selectedVenue.address)) {
        showAletViewWithMessage(@"Please enter address");
        return false;
    }
    
    if (_isStringEmpty(selectedVenue.address1)) {
        showAletViewWithMessage(@"Please enter city");
        return false;
    }
    
    if (_isStringEmpty(selectedVenue.venue_id) && selectedVenue.imgV == nil) {
        showAletViewWithMessage(@"Please choose picture");
        return false;
    }
    return true;
}

#pragma mark - Button Action
-(IBAction)btnAddNewVenue:(UIButton*)sender {
    VenuesEntity *new = [[VenuesEntity alloc] init];
    [arrVenues addObject:new];
    selectedVenue = new;
    currentIndex = arrVenues.count - 1;
    [tblLeft reloadData];
    [tblRight reloadData];
}

-(IBAction)btnSaveVenue:(UIButton*)sender {
    if (![self isValid]) {
        return;
    }
    if (selectedVenue.imgV) {
        [hud hide:true];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = [NSString stringWithFormat:@"Uploading 1 of %d",(int)dataClass.crsImages.count + 1];
        [UploadManager sharedInstance].delegate = self;
        [[UploadManager sharedInstance] uploadImagesWithArray:@[selectedVenue.imgV]];
        
    }else{
        [self addUpdateDeleteVenue:nil];
    }


}
-(IBAction)btnDelete:(UIButton*)sender {
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableDictionary *venueDict = [NSMutableDictionary new];
    [venueDict setObject:@"delete" forKey:@"action"];
    [venueDict setObject:selectedVenue.venue_id forKey:@"item_id"];
    [venueDict setObject:selectedVenue.venue_name forKey:@"name"];
    [venueDict setObject:selectedVenue.venue_details forKey:@"details"];
    
    [dict setObject:@[venueDict] forKey:@"venues"];
    [[NetworkManager sharedInstance] postRequestUrl:apiUpdate_delete_venue paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [self getVenueList];
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
-(IBAction)btnOpenLocationPicker:(UIButton*)sender{
    if ([MyLocationManager sharedInstance].userLatitude) {
        [self openGooglePicker];
    }else{
        [self startActivity];
        [[UserLocation sharedInstance] fetchUserLocationForOnce:self block:^(CLLocation * location, NSError * error) {
            [self stopActivity];
            if (location) {
                [MyLocationManager sharedInstance].userLatitude = location.coordinate.latitude;
                [MyLocationManager sharedInstance].userLongitude = location.coordinate.longitude;
                [self openGooglePicker];
            }
        }];
    }
}

-(void) addUpdateDeleteVenue:(NSString*) fid {
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];

    NSMutableDictionary *venueDict = [NSMutableDictionary new];
    if(selectedVenue.venue_id){
        [venueDict setObject:selectedVenue.venue_id forKey:@"item_id"];
    }
    [venueDict setObject:selectedVenue.venue_name forKey:@"name"];
    [venueDict setObject:selectedVenue.venue_details forKey:@"details"];
    if (fid){
        [venueDict setObject:fid forKey:@"fid"];
    }
    [venueDict setObject:@[@{@"city":selectedVenue.address1, @"street":selectedVenue.address, @"postal_code":selectedVenue.pincode}] forKey:@"location"];

    [dict setObject:@[venueDict] forKey:@"venues"];
    [[NetworkManager sharedInstance] postRequestUrl:apiUpdate_delete_venue paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (is_iPad()) {
            [self getVenueList];
        }else{
            [DefaultCenter postNotificationName:@"refreshVenueList" object:nil];
        }
        
    }];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblLeft) {
        return (arrVenues.count == 0) ? 1 :arrVenues.count;
    } else{
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblRight) {
        if (indexPath.row == 3) {
            AddVenueCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
            cell.controller = self;
            [cell.collectionV reloadData];
            return cell;
        }else{
            NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
            AddVenueCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controller = self;
            switch (indexPath.row) {
                case 0:{
                    UITextField *viewBorder = [cell viewWithTag:11];
                    UITextField *tfVenueName = [cell viewWithTag:12];
                    tfVenueName.text = (selectedVenue) ? selectedVenue.venue_name : @"";
                    viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
                    viewBorder.layer.borderWidth = 1.0;
                }   break;
                case 1:{
                    UITextView *txtV = [cell viewWithTag:11];
                    txtV.layer.borderColor = [UIColor darkGrayColor].CGColor;
                    txtV.text = (selectedVenue) ? selectedVenue.venue_details : @"";
                    txtV.layer.borderWidth = 1.0;
                    
                }   break;
                case 2: {
                    UIView *viewBorder1 = [cell viewWithTag:11];
                     UIView *viewBorder2 = [cell viewWithTag:12];
                     UIView *viewBorder3 = [cell viewWithTag:13];
                     UIView *viewBorder4 = [cell viewWithTag:14];
                    [self makeBorder:viewBorder1];
                    [self makeBorder:viewBorder2];
                    [self makeBorder:viewBorder3];
                    [self makeBorder:viewBorder4];
                    cell.tfAdd1.text = selectedVenue.address;
                    cell.tfAdd2.text = selectedVenue.address1;
                    cell.tfPostalCode.text = selectedVenue.pincode;
                    cell.tfCountry.text = selectedVenue.country;
                } break;
                default:
                    break;
            }
            return cell;
        }
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:11];
        lbl.text = [NSString stringWithFormat:@"Venue %ld",indexPath.row + 1];
        if (indexPath.row == currentIndex) {
            cell.backgroundColor = [UIColor colorWithRed:159.0/255.0 green:213.0/255.0 blue:214.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tblLeft == tableView) {
        currentIndex = indexPath.row;
        selectedVenue = arrVenues[indexPath.row];

        [tblLeft reloadData];
        [tblRight reloadData];
    }
}
-(void) fetchVenueImage {
    [self startActivity];
    [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:selectedVenue.imagePath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if(image){
            selectedVenue.imgV = image;
            [selectedVenue.arrImgaes removeAllObjects];
            [selectedVenue.arrImgaes addObject:selectedVenue.imgV];
            [tblRight reloadData];
        }
    }];
  /*
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:selectedVenue.imagePath] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self stopActivity];
        if(image){
            selectedVenue.imgV = image;
            [selectedVenue.arrImgaes removeAllObjects];
            [selectedVenue.arrImgaes addObject:selectedVenue.imgV];
            [tblRight reloadData];
        }
    }];*/
}

-(void) makeBorder :(UIView*) viewBorder {
    viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
    viewBorder.layer.borderWidth = 1.0;
}
-(void) openGooglePicker{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
  
}
#pragma mark API Calls
-(void) getVenueList {
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiVenueList paramter:@{@"uid":APPDELEGATE.userCurrent.uid,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [arrVenues removeAllObjects];
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                VenuesEntity * objVenue = [[VenuesEntity alloc]initWith:d];
                [arrVenues addObject:objVenue];
            }
            [tblLeft reloadData];
        }
        if (arrVenues.count == 0) {
            showAletViewWithMessage(@"No venue found!!");
            [self btnAddNewVenue:nil];
        }else{
            currentIndex = 0;
            selectedVenue = arrVenues[0];
        }
        [tblLeft reloadData];
        [tblRight reloadData];

    }];
}
#pragma mark - Upload Manager Delegate
- (void)updateProgress:(NSNumber *)completed total:(NSNumber *)totalUpload{
    hud.progress = ([completed intValue] * 100/[totalUpload intValue])/100.0f;
    hud.labelText = [NSString stringWithFormat:@"Uploading %d of %d",(int)[completed intValue]+1,(int)[totalUpload intValue]];
}
- (void)uploadCompleted:(NSArray *)arrayFids{
    hud.labelText = @"Upload completed.";
    [hud hide:true];
    [self performSelector:@selector(addUpdateDeleteVenue:) withObject:arrayFids.firstObject afterDelay:0.5];
    [UploadManager sharedInstance].delegate = nil;
}
- (void)uploadFailed
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading failed, Please try again.";
    showAletViewWithMessage(@"Tutor image uploading fail.");
    [hud hide:YES afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}
#pragma mark- Camera Picker
-(IBAction)btnChoosePic:(UIButton*)sender {
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Are you sure!!" bgColor:__THEME_YELLOW button:@[@"Camera",@"Gallery"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedDismiss) {
            [[JPUtility shared] performOperation:0.3 block:^{
                [self btnCamera:nil];
            }];
        }else if (tapped == TappedOkay) {
            [self btnOpenGallery:nil];
        }
        [alert removeFromSuperview];
    }];
    
    [APPDELEGATE.window addSubview:alert];
}
-(IBAction)btnOpenGallery:(UIButton*)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized)
        {
            
            QBImagePickerController *imagePickerController = [QBImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.minimumNumberOfSelection = 1;
            imagePickerController.maximumNumberOfSelection = 1;
            imagePickerController.showsNumberOfSelectedAssets = YES;
            [self presentViewController:imagePickerController animated:YES completion:NULL];
        } else {
            //No permission. Trying to normally request it
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status != PHAuthorizationStatusAuthorized)
                {
                    //User don't give us permission. Showing alert with redirection to settings
                    //Getting description string from info.plist file
                    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
                    [AppUtils actionWithMessage:accessDescription withMessage:@"To give permissions tap on 'Change Settings' button" alertType:UIAlertControllerStyleAlert button:@[@"Change Settings"] controller:self block:^(NSString *tapped) {
                        if ([tapped isEqualToString:@"Change Settings"]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    }];
                }
            }];
        }
    });
}
-(IBAction)btnCamera:(UIButton*)sender {
    
    if ([DataClass getInstance].crsImages.count == 5) {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
        
    }
}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    selectedVenue.imgV = [UIImage imageWithData: UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.4)];
    
    [selectedVenue.arrImgaes removeAllObjects];
    [selectedVenue.arrImgaes addObject:selectedVenue.imgV];
    
    [tblRight reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Picker Delegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    selectedVenue.imgV = [assets[0] getAssetOriginal];
    [selectedVenue.arrImgaes removeAllObjects];
    [selectedVenue.arrImgaes addObject:selectedVenue.imgV];
    [tblRight reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
   
    NSArray *arr = [place.formattedAddress componentsSeparatedByString:@", "];
    if (arr.count > 1) {
        selectedVenue.address = arr[0];
        selectedVenue.address1 = arr[1];
    }else{
        selectedVenue.address = arr[0];
    }
    
    for(GMSAddressComponent *obj in place.addressComponents){
        NSLog(@"%@",obj.type);
        NSLog(@"%@",obj.name);
        if ([obj.type isEqualToString:@"locality"] || [obj.type isEqualToString:@"postal_town"]) {
            selectedVenue.address1 = [NSString stringWithFormat:@"%@ %@",selectedVenue.address1,obj.name];
        }else if ([obj.type isEqualToString:@"postal_code"]){
            selectedVenue.pincode = obj.name;
        }else if ([obj.type isEqualToString:@"country"]){
            selectedVenue.country = obj.name;
        }
    }
    selectedVenue.latitude = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
    selectedVenue.longitude = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
    
    [tblRight reloadData];

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
