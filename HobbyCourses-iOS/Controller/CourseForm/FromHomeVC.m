//
//  FromHomeVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 18/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromHomeVC.h"

@interface FromHomeVC () {
    NSMutableArray *arrSteps,*arrAge;
}
@end

@implementation FromHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrSteps = [[NSMutableArray alloc] initWithObjects:@"Category & Title",@"Course Introduction",@"Location",@"Additional Details",@"Detailed Description",@"Images",@"Schedule and Price",@"Optional Parameters ", nil];
    arrAge = [[NSMutableArray alloc] initWithObjects:@"3-65",@"18+",@"16-18",@"15-16",@"11-16",@"6-10",@"3-5", nil];
    
    
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    if ([self checkStringValue:self.courseNid]) {
        dataClass.rowID = _courseNidOfflince;
        [dataClass setCourseFromData:dataClass.rowID];
        dataClass.crsNid = nil;
        
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
    [self updateToGoogleAnalytics:@"Steps List submit form Screen"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateChecker];
}
-(IBAction)btnPreview:(id)sender {
    if (![self validation]) {
        showAletViewWithMessage(@"Hold that horse. You’ll need to complete steps 1-8 successfully to preview a course.");
    }else{
        [self performSegueWithIdentifier:@"seguePreview" sender:self];
    }
}
-(BOOL) validation{
    if (!dataClass.isPage1Done) { return NO; }
    if (!dataClass.isPage2Done) { return NO; }
    if (!dataClass.isPage3Done) { return NO; }
    if (!dataClass.isPage4Done) { return NO; }
    if (!dataClass.isPage5Done) { return NO; }
    if (!dataClass.isPage6Done) { return NO; }
    if (!dataClass.isPage7Done) { return NO; }
    if (!dataClass.isPage8Done) { return NO; }
    
    return YES;
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
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrSteps.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    
    cellIdentifier = @"Cell1";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UILabel *lblNo = [cell viewWithTag:11];
    UILabel *lblTitle = [cell viewWithTag:12];
    UIButton *btn = [cell viewWithTag:13];
    lblNo.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
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
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    dataClass.crsAgeGroup = course.age_group;
    dataClass.crsAgeGroupIndex = [course.age_groupIndex integerValue];
    if (course.productArr.count > 0) {
        ProductEntity *pro = course.productArr[0];
        dataClass.crsBatch = pro.batch_size;
        dataClass.crsStock = pro.quantity;
        dataClass.crsTutor = pro.tutor;
    }
    
    dataClass.crsAddress = course.address_1;
    dataClass.crsAddress1 = course.address_2;
    dataClass.crsCity = course.city;
    dataClass.crsPincode = course.postal_code;
    
    dataClass.crsCancellation = course.cancellation_type;
    dataClass.crsYoutubeURL = course.youtube_video;
    dataClass.crsCertificate = [[course.certifications componentsSeparatedByString:@","] mutableCopy];
    
    dataClass.isMoneyBack = @"0";
    dataClass.isTrail = @"0";
    if (!_isStringEmpty(course.field_money_back_guarantee) && [course.field_money_back_guarantee.lowercaseString isEqualToString:@"yes"]) {
        dataClass.isMoneyBack = @"1";
    }
    
    
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
        dataClass.crsAgeGroup = course.age_group;
        NSInteger age = [course.age_groupIndex integerValue];
        NSNumber *num = [NSNumber numberWithInteger:((age > 9) ? 0 : age)];
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
            
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsCategory.tid] feildName:FeildNameCategory];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsSubCategoryEntity.tid] feildName:FeildNameSubCategory];

            
            CourseForm *courseCoreData = [CourseForm getObjectbyRowID:dataClass.rowID];
            for (ImageList *imageList in [courseCoreData.images allObjects]) {
                [ImageList deleteImage:imageList.imgUrl];
            }
            
            for (NSString *uID in dataClass.crsImages) {
                [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[uID] feildName:FeildNameImage];
            }
            
            
            
            dataClass.crsCategoryTbl = courseCoreData.category;
            dataClass.crsSubCategoryTbl = courseCoreData.subcategory;
            
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsCancellation] feildName:FeildNameCancellation];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsBatch] feildName:FeildNameBatchSize];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[dataClass.crsSummary] feildName:FeildNameIntroduction];
            [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[course.address_1,course.address_2,course.city,course.postal_code] feildName:FeildNameLocation];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
