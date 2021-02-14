//
//  AddTutorVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 29/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AddTutorVC_iPad.h"
#import "MBProgressHUD.h"

@interface AddTutorVC_iPad ()<QBImagePickerControllerDelegate,UploadManagerDelegate,GMSAutocompleteViewControllerDelegate> {
    IBOutlet UITableView *tblLeft;
    IBOutlet UITableView *tblRight;
    IBOutlet UIView *viewShadow;
    NSInteger currentIndex;
    NSMutableArray<TutorsEntity*> *arrTuttors;
    MBProgressHUD *hud;
   // GMSPlacePicker *_placePicker;
    
}

@end

@implementation AddTutorVC_iPad
@synthesize selectedTutor;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addShaowForiPad:viewShadow];
    tblRight.estimatedRowHeight = 100;
    tblRight.rowHeight = UITableViewAutomaticDimension;
    tblLeft.estimatedRowHeight = 100;
    tblLeft.rowHeight = UITableViewAutomaticDimension;
    tblLeft.tableFooterView = [UIView new];
    arrTuttors = [NSMutableArray new];
    currentIndex = -1;
    if (is_iPad()) {
        [self getTutorList];
    }else if (self.selectedTutor != nil) {
        [arrTuttors addObject:self.selectedTutor];
    }else{
        [self btnAddNewTutor:nil];
    }
    [tblRight reloadData];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Add Tutor Screen"];
}
-(BOOL) isValid {
    if (_isStringEmpty(selectedTutor.tutor_name)) {
        showAletViewWithMessage(@"Please enter tutor name");
        return false;
    }
    if (_isStringEmpty(selectedTutor.tutor_details)) {
        showAletViewWithMessage(@"Please enter tutor description");
        return false;
    }
    if (_isStringEmpty(selectedTutor.pincode)) {
        showAletViewWithMessage(@"Please enter postal code");
        return false;
    }
    if (_isStringEmpty(selectedTutor.address)) {
        showAletViewWithMessage(@"Please enter address");
        return false;
    }
    
    if (_isStringEmpty(selectedTutor.city)) {
        showAletViewWithMessage(@"Please enter city");
        return false;
    }
    
    if (_isStringEmpty(selectedTutor.tutor_id) && selectedTutor.imgV == nil) {
        showAletViewWithMessage(@"Please choose picture");
        return false;
    }
    return true;
}
#pragma mark - Button Action
-(IBAction)btnAddNewTutor:(UIButton*)sender {
    TutorsEntity *new = [[TutorsEntity alloc] init];
    [arrTuttors addObject:new];
    selectedTutor = new;
    currentIndex = arrTuttors.count - 1;
    [tblLeft reloadData];
    [tblRight reloadData];
}
-(IBAction)btnSaveTutor:(UIButton*)sender {
    
    if (![self isValid]) {
        return;
    }
    
    if (selectedTutor.imgV) {
        [hud hide:true];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = [NSString stringWithFormat:@"Uploading 1 of %d",(int)dataClass.crsImages.count + 1];
        [UploadManager sharedInstance].delegate = self;
        [[UploadManager sharedInstance] uploadImagesWithArray:@[selectedTutor.imgV]];
        
    }else{
        [self addUpdateDeleteTutor:nil];
    }
}
-(IBAction)btnDelete:(UIButton*)sender {
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableDictionary *tutorDict = [NSMutableDictionary new];
    [tutorDict setObject:@"delete" forKey:@"action"];
    [tutorDict setObject:selectedTutor.tutor_id forKey:@"item_id"];
    [tutorDict setObject:selectedTutor.tutor_name forKey:@"name"];
    [tutorDict setObject:selectedTutor.tutor_details forKey:@"details"];
    
    [dict setObject:@[tutorDict] forKey:@"tutors"];
    [[NetworkManager sharedInstance] postRequestUrl:update_del_Tutor paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [self getTutorList];
        }else{
            
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
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblLeft) {
        return (arrTuttors.count == 0) ? 1 :arrTuttors.count;
    } else{
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblRight) {
        if (indexPath.row == 3) {
            AddTutorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
            cell.controller = self;
            [cell.collectionV reloadData];
            return cell;
        }else{
            NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
            AddTutorCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controller = self;
            switch (indexPath.row) {
                case 0:{
                    UITextField *viewBorder = [cell viewWithTag:11];
                    UITextField *tfTutorName = [cell viewWithTag:12];
                    tfTutorName.text = (selectedTutor) ? selectedTutor.tutor_name : @"";
                    viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
                    viewBorder.layer.borderWidth = 1.0;
                }   break;
                case 1:{
                    UITextView *txtV = [cell viewWithTag:11];
                    txtV.layer.borderColor = [UIColor darkGrayColor].CGColor;
                    txtV.text = (selectedTutor) ? selectedTutor.tutor_details : @"";
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
                    cell.tfAdd1.text = selectedTutor.address;
                    cell.tfAdd2.text = selectedTutor.city;
                    cell.tfPostalCode.text = selectedTutor.pincode;
                    cell.tfCountry.text = selectedTutor.country;
                }   break;
                default:
                    break;
            }
            return cell;
        }
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:11];
        lbl.text = [NSString stringWithFormat:@"Tutor %ld",indexPath.row + 1];
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
        selectedTutor = arrTuttors[indexPath.row];
        [tblLeft reloadData];
        [tblRight reloadData];
    }
}
-(void) makeBorder :(UIView*) viewBorder {
    viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
    viewBorder.layer.borderWidth = 1.0;
}

#pragma mark API Calls
-(void) fetchTutorImage {
    [self startActivity];
    
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:selectedTutor.imagePath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if(image){
            selectedTutor.imgV = image;
            [selectedTutor.arrImgaes removeAllObjects];
            [selectedTutor.arrImgaes addObject:selectedTutor.imgV];
            [tblRight reloadData];
        }
    }];
    
    /*
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:selectedTutor.imagePath] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self stopActivity];
        if(image){
            selectedTutor.imgV = image;
            [selectedTutor.arrImgaes removeAllObjects];
            [selectedTutor.arrImgaes addObject:selectedTutor.imgV];
            [tblRight reloadData];
        }
    }];*/
}
-(void) getTutorList {
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiTutorList paramter:@{@"uid":APPDELEGATE.userCurrent.uid,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [arrTuttors removeAllObjects];
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                TutorsEntity * objTutor = [[TutorsEntity alloc]initWith:d];
                [arrTuttors addObject:objTutor];
            }
        }if (arrTuttors.count > 0) {
            currentIndex = 0;
            selectedTutor = arrTuttors[0];
        }else{
            showAletViewWithMessage(@"No tutors found!!");
        }
        [tblLeft reloadData];
        [tblRight reloadData];
    }];
}

-(void) addUpdateDeleteTutor:(NSString*) fid {
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:APPDELEGATE.userCurrent.name forKey:@"title"];

    NSMutableDictionary *tutorDict = [NSMutableDictionary new];
    if (selectedTutor.tutor_id) {
        [tutorDict setObject:selectedTutor.tutor_id forKey:@"item_id"];
    }
    [tutorDict setObject:selectedTutor.tutor_name forKey:@"name"];
    [tutorDict setObject:selectedTutor.tutor_details forKey:@"details"];
    [tutorDict setObject:@[@{@"city":selectedTutor.city, @"street":selectedTutor.address, @"postal_code":self.selectedTutor.pincode}] forKey:@"location"];

    if (fid){
        [tutorDict setObject:fid forKey:@"fid"];
    }
    
    [dict setObject:@[tutorDict] forKey:@"tutors"];
    [[NetworkManager sharedInstance] postRequestUrl:update_del_Tutor paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if (is_iPad()) {
                [self getTutorList];    
            }else{
                [DefaultCenter postNotificationName:@"refreshTutorList" object:nil];
            }
        }else{
            showAletViewWithMessage(kFailAPI);
        }
    }];
}
#pragma mark - Google place picker
-(void) openGooglePicker{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}

#pragma mark- Camera Picker
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

    selectedTutor.imgV = [UIImage imageWithData: UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.4)];

    [selectedTutor.arrImgaes removeAllObjects];
    [selectedTutor.arrImgaes addObject:selectedTutor.imgV];
    
    [tblRight reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Picker Delegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    selectedTutor.imgV = [assets[0] getAssetOriginal];
    [selectedTutor.arrImgaes removeAllObjects];
    [selectedTutor.arrImgaes addObject:selectedTutor.imgV];
    [tblRight reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Upload Manager Delegate
- (void)updateProgress:(NSNumber *)completed total:(NSNumber *)totalUpload{
    hud.progress = ([completed intValue] * 100/[totalUpload intValue])/100.0f;
    hud.labelText = [NSString stringWithFormat:@"Uploading %d of %d",(int)[completed intValue]+1,(int)[totalUpload intValue]];
}
- (void)uploadCompleted:(NSArray *)arrayFids{
    hud.labelText = @"Upload completed.";
    [hud hide:true];
    [self performSelector:@selector(addUpdateDeleteTutor:) withObject:arrayFids.firstObject afterDelay:0.5];
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
    
    selectedTutor.address = place.formattedAddress;
    
    for(GMSAddressComponent *obj in place.addressComponents){
        NSLog(@"%@",obj.type);
        NSLog(@"%@",obj.name);
        if ([obj.type isEqualToString:@"locality"] || [obj.type isEqualToString:@"postal_town"]) {
            selectedTutor.city = obj.name;
        }else if ([obj.type isEqualToString:@"postal_code"]){
            selectedTutor.pincode = obj.name;
        }else if ([obj.type isEqualToString:@"country"]){
            selectedTutor.country = obj.name;
        }
    }
    
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
