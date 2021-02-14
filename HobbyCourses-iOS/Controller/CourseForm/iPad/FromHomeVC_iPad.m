//
//  FromHomeVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromHomeVC_iPad.h"

@interface FromHomeVC_iPad ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSMutableArray *arrSteps,*arrAge;
    IBOutlet UITableView *tblPhotos;
}

@end

@implementation FromHomeVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSteps = [[NSMutableArray alloc] initWithObjects:@"Category & Title",@"Course Introduction",@"Location",@"Additional Details",@"Detailed Description",@"Images",@"Schedule and Price",@"Optional Parameters ", nil];
    arrAge = [[NSMutableArray alloc] initWithObjects:@"3-65",@"18+",@"16-18",@"15-16",@"11-16",@"6-10",@"3-5", nil];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblPhotos.estimatedRowHeight = 100;
    tblPhotos.rowHeight = UITableViewAutomaticDimension;
    
    if ([self checkStringValue:self.courseNid]) {
        dataClass.rowID = _courseNidOfflince;
        [dataClass setCourseFromData:dataClass.rowID];
    }else{
        dataClass.rowID = self.courseNid;
        dataClass.crsNid = self.courseNid;
        [self getCourseDetails:self.courseNid];
    }
    
    [DefaultCenter addObserver:self selector:@selector(updateChecker) name:@"updateChecker" object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad Steps List submit form Screen"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateChecker];
}

-(void) updateChecker{
    [self checkForm1];
    [self checkForm2];
    [self checkForm3];
    [self checkForm4];
    [self checkForm5];
    [self checkForm6];
    [self checkForm7];
    [self checkForm8];
    [tblParent reloadData];
    [tblPhotos reloadData];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblPhotos) {
        return dataClass.crsImages.count + 1;
    }
    return arrSteps.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    if (tableView == tblPhotos) {
        cellIdentifier = @"Cell0";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UIImageView *imgV = [cell viewWithTag:11];
        UIImageView *imgVIcon = [cell viewWithTag:12];
        UILabel *lblAddPic = [cell viewWithTag:13];
        if (dataClass.crsImages.count  == indexPath.row) {
            lblAddPic.hidden = false;
            imgVIcon.hidden = false;
            imgV.image = [UIImage imageNamed:@"ic_f_cameraLayer"];
        }else{
            if (indexPath.row < dataClass.crsImages.count) {
                
                NSURL *imgUrl = [[DocumentAccess obj] mediaForName:dataClass.crsImages[indexPath.row]];
                if (imgUrl) {
                    imgV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl] scale:0.8];
                }
                lblAddPic.hidden = true;
                imgVIcon.hidden = true;
            }
        }
        return cell;
    }else{
        cellIdentifier = @"Cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UILabel *lblNo = [cell viewWithTag:11];
        UILabel *lblTitle = [cell viewWithTag:12];
        UIButton *btn = [cell viewWithTag:13];
        UIButton *btn1 = [cell viewWithTag:14];
        lblNo.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        lblTitle.text = arrSteps[indexPath.row];
        btn.selected = false;
        switch (indexPath.row) {
            case 0:
                btn.selected = dataClass.isPage1Done;
                break;
            case 1:
                btn.selected = dataClass.isPage2Done;
                break;
            case 2:
                btn.selected = dataClass.isPage3Done;
                break;
            case 3:
                btn.selected = dataClass.isPage4Done;
                break;
            case 4:
                btn.selected = dataClass.isPage5Done;
                break;
            case 5:
                btn.selected = dataClass.isPage6Done;
                break;
            case 6:
                btn.selected = dataClass.isPage7Done;
                break;
            case 7:
                btn.selected = dataClass.isPage8Done;
                break;
            default:
                break;
        }
        btn1.selected = btn.selected;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblPhotos) {
        if (indexPath.row ==  dataClass.crsImages.count) {
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
        return;
    }
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"segueCourseType" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"segueSummary" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"segueLocation" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"segueCourseDetail" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"segueCourseDesc" sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"segueSelectPics" sender:self];
            break;
        case 6:
            [self performSegueWithIdentifier:@"segueSchedule" sender:self];
            break;
        case 7:
            [self performSegueWithIdentifier:@"segueOptional" sender:self];
            break;
            
        default:
            break;
    }
}
#pragma mark - API
-(void) getCourseDetails:(NSString *) courseNID
{
    if (![self isNetAvailable]) {
        return;
    }else{
        [self startActivity];
        [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@",apiCourseDetailUrl,courseNID] paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
            [self stopActivity];
            if (result == WebServiceResultSuccess) {
                if ([jsonData isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *d = [jsonData mutableCopy];
                    [d handleNullValue];
                    CourseDetail *course = [[CourseDetail alloc]initWith:d];
                    [self fillFormData:course];
                }
            } else {
                showAletViewWithMessage(kFailAPI);
                [self.navigationController popViewControllerAnimated:true];
            }
        }];
    }
}

-(void) fillFormData:(CourseDetail*) course {
    [self startActivity];
    
    dataClass.crsTitle = course.title;
    [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsTitle] feildName:FeildNameTitle];
    
    for (CategoryEntity *entity in _arrCategoryC) {
        NSString *str = [course.category stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
        if ([entity.category isEqualToString:str]) {
            dataClass.crsCategory = entity;
        }
        
        for(SubCategoryEntity *subEnt in entity.subCategories) {
            NSString *str = [course.subcategory stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            if ([subEnt.subCategory isEqualToString:str]) {
                dataClass.crsSubCategoryEntity = subEnt;
            }
        }
    }
    dataClass.crsRequirements = course.course_requirements;
    dataClass.crsShortDesc = course.short_description;
    dataClass.crsSummary = course.Description;
    dataClass.crsAgeGroup = course.age_groupIndex;

    if (course.productArr.count > 0) {
        ProductEntity *pro = course.productArr[0];
        
        dataClass.crsAgeGroupIndex = 1;
        dataClass.crsBatch = pro.batch_size;
        dataClass.crsStock = pro.quantity;
        dataClass.crsTutor = pro.tutor;
    }
    
    dataClass.crsAddress = course.address_1;
    dataClass.crsAddress1 = course.address_2;
    dataClass.crsCity = course.city;
    dataClass.crsPincode = course.postal_code;
    
    dataClass.crsAmenities = [course.amenities mutableCopy];
    dataClass.crsCancellation = course.cancellation_type;
    dataClass.crsYoutubeURL = course.youtube_video;
    dataClass.crsCertificate = [[course.certifications componentsSeparatedByString:@","] mutableCopy];
    
    dataClass.isMoneyBack = @"0";
    dataClass.isTrail = @"0";
    if (!_isStringEmpty(course.field_money_back_guarantee) && [course.field_money_back_guarantee.lowercaseString isEqualToString:@"yes"]) {
        dataClass.isMoneyBack = @"1";
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@",course.address_1,course.city,course.postal_code];
    [geocoder geocodeAddressString:str completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks) {
            // Process the placemark.
            dataClass.crslat = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
            dataClass.crslng = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
        }
    }];
    
    [dataClass.arrCourseBatches removeAllObjects];

    for (ProductEntity *entity in course.productArr) {
        Batches *batch = [[Batches alloc]init];
        batch.startDate = entity.course_start_date;
        batch.endDate = entity.course_end_date;
        batch.sessions = entity.sessions_number;
        batch.classSize = entity.batch_size;
        batch.price = [entity.initial_price removeSymbols];
        batch.discount = [entity.price removeSymbols];
        batch.batchesTimes = entity.timingsDate;
        batch.batchID = entity.product_id;

        [ClassList insertOrUpdate:batch.batchID objects:@[batch] feildName:BatchSignleAll];
        
        for (TimeBatch *time in entity.timingsDate) {
            [ScheduleList insertOrUpdate:time classRow:batch.batchID];
        }
        
        [dataClass.arrCourseBatches addObject:batch];
    }
    
    if (course.age_groupIndex) {
        dataClass.crsAgeGroup = course.age_groupIndex;
        NSInteger age = [course.age_groupIndex integerValue];
        NSNumber *num = [NSNumber numberWithInteger:((age > 9) ? 0 : dataClass.crsAgeGroupIndex)];
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[num,course.age_group] feildName:FeildNameAgeGp];
    }else{
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[@8,@"Don't Care"] feildName:FeildNameAgeGp];
        
    }

    [dataClass.crsImages removeAllObjects];
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        
        for (id obj in course.field_deal_image)
        {
            NSData* theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
            if (theData){
                NSString *uID = GetTimeStampString;
                if ([[DocumentAccess obj] setMedia:theData forName:uID]) {
                    [dataClass.crsImages addObject:uID];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self stopActivity];
            CourseForm *courseCoreData = [CourseForm getObjectbyRowID:dataClass.rowID];
            for (ImageList *imageList in [courseCoreData.images allObjects]) {
                [ImageList deleteImage:imageList.imgUrl];
            }
            
            for (NSString *uID in dataClass.crsImages) {
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[uID] feildName:FeildNameImage];
            }
            
            
            
            dataClass.crsCategoryTbl = courseCoreData.category;
            dataClass.crsSubCategoryTbl = courseCoreData.subcategory;
            
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsCategory.tid] feildName:FeildNameCategory];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsSubCategoryEntity.tid] feildName:FeildNameSubCategory];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsCancellation] feildName:FeildNameCancellation];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsBatch] feildName:FeildNameBatchSize];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsSummary] feildName:FeildNameIntroduction];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[course.address_1,course.address_2,course.city,course.postal_code] feildName:FeildNameLocation];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[@1,@""] feildName:FeildNameAgeGp];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.isMoneyBack] feildName:FeildNameIsMoney];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.isTrail] feildName:FeildNameIsTrial];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsStock] feildName:FeildNamePlaceA];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsShortDesc] feildName:FeildNameDescription];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsTutor] feildName:FeildNameTutor];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsRequirements] feildName:FeildNameCourseReq];
            
            for (Amenities *strAm in course.amenities) {
                [AmeitiesList insertAmeities:strAm.title courseForm:courseCoreData];
                [dataClass.crsAmenities addObject:strAm.title];
            }
            
            int i = 0;
            for (NSString *cert in dataClass.crsCertificate) {
                NSString *vIdx = [NSString stringWithFormat:@"%d",i];
                [CertificateList insertCertificate:cert index:vIdx courseForm:courseCoreData];
                i++;
            }
            i = 0;
            for (NSString *video in dataClass.crsYoutubeURL) {
                NSString *vIdx = [NSString stringWithFormat:@"%d",i];
                [VideoList insertVideos:video index:vIdx courseForm:courseCoreData];
                i++;
            }
            [dataClass setCourseFromData:dataClass.rowID];
            
            [self updateChecker];
            [tblPhotos reloadData];
            
        });
    });
}

#pragma mark - Check Data
-(void) checkForm1 {
    dataClass.isPage1Done = false;
    if ([self checkStringValue:dataClass.crsTitle]) { return; }
    if (dataClass.crsCategoryTbl == nil) { return; }
    if (dataClass.crsSubCategoryTbl == nil) { return; }
    if ([self checkStringValue:dataClass.crsBatch]) { return; }
    if ([self checkStringValue:dataClass.crsCancellation]) { return; }
    dataClass.isPage1Done = true;
}
-(void) checkForm2 {
    dataClass.isPage2Done = false;
    if ([self checkStringValue:dataClass.crsSummary]) { return; }
    if (dataClass.crsSummary.length < 50) { return; }
    dataClass.isPage2Done = true;
}
-(void) checkForm3 {
    dataClass.isPage3Done = false;
    if ([self checkStringValue:dataClass.crsAddress]) { return; }
    //    if ([self checkStringValue:dataClass.crsAddress1]) { return; }
    if ([self checkStringValue:dataClass.crsPincode]) { return; }
    if ([self checkStringValue:dataClass.crsCity]) { return; }
    dataClass.isPage3Done = true;
}
-(void) checkForm4 {
    dataClass.isPage4Done = false;
    if (dataClass.crsAgeGroupIndex == -1) { return; }
    if ([self checkStringValue:dataClass.crsAgeGroup]) { return; }
    dataClass.isPage4Done = true;
}
-(void) checkForm5 {
    dataClass.isPage5Done = false;
    if ([self checkStringValue:dataClass.crsShortDesc]) { return; }
    if (dataClass.crsShortDesc.length < 50){return;}
    //    if ([self checkStringValue:dataClass.crsRequirements]) { return; }
    dataClass.isPage5Done = true;
}
-(void) checkForm6 {
    dataClass.isPage6Done = false;
    if (dataClass.crsImages.count == 0) { return; }
    dataClass.isPage6Done = true;
}
-(void) checkForm7 {
    dataClass.isPage7Done = false;
    for (Batches *batch in dataClass.arrCourseBatches) {
        if (batch.batchesTimes.count == 0) {
            dataClass.isPage7Done = false;
            break;
        }else{
            dataClass.isPage7Done = true;
        }
    }
}
-(void) checkForm8 {
    dataClass.isPage8Done = false;
    if ([self checkStringValue:dataClass.crsTutor]) { return; }
    if (dataClass.crsAmenities.count == 0) { return; }
    dataClass.isPage8Done = true;
}


-(IBAction)btnOpenGallery:(UIButton*)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized)
        {
            if ([DataClass getInstance].crsImages.count == 5) {
                return;
            }
            QBImagePickerController *imagePickerController = [QBImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.minimumNumberOfSelection = 1;
            imagePickerController.maximumNumberOfSelection = 5 - [DataClass getInstance].crsImages.count;
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
    NSString *uID = GetTimeStampString;
    if ([[DocumentAccess obj] setMedia:UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.4) forName:uID]) {
        [dataClass.crsImages addObject:uID];
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[uID] feildName:FeildNameImage];
    }
    
    [tblParent reloadData];
    [tblPhotos reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Picker Delegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    for (PHAsset *asset in assets) {
        // Do something with the asset
        NSString *uID = GetTimeStampString;
        if ([[DocumentAccess obj] setMedia:UIImageJPEGRepresentation([asset getAssetOriginal], 0.4) forName:uID]) {
            [[DataClass getInstance].crsImages addObject:uID];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[uID] feildName:FeildNameImage];
            
        }
    }
    
    
    [DataClass getInstance].selectedPreviewImg = 0;
    [tblParent reloadData];
    [tblPhotos reloadData];
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

@end
