
#import "CreateCourseiPadViewController.h"
#import "Constants.h"
#import "ImageUtility.h"
#import "MBProgressHUD.h"

#define YoutubeBaseUrl @"https://www.youtube.com/"

@interface CreateCourseiPadViewController ()<PopUpViewControllerProtocol,SelectTimeDelegate>
{
    NSMutableArray *arrTextField,*arrTxtCertificateField,*arrPics;
    BOOL isMediaOpen;
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    NSMutableArray *arrTBLData;
    NSMutableArray *arrCategory;
    BOOL isSelectedBtn;
    NSIndexPath *selectedCatIndex;
    NSString *Base64ConvertImage;
    
    NSMutableArray *arrImgFID;
    NSMutableArray *cellUploadImageArray;
    NSMutableArray *arrHinttext;
    
    NSString *catID;
    NSString *subcatID;
    UIImage *tempImg;
    NSMutableArray *arrOffline;
    MBProgressHUD *hud;
    NSString *UUIDString;
    int scrollHeight;
    int temptxtDescHeight;
    int txtDescHeight;
    
    NSString *strYoutube1;
    NSString *strCetificate1;
    JTMaterialSwitch *jswTrialClass;
    JTMaterialSwitch *jswStatus;
    JTMaterialSwitch *jswMoneyBack;
    
    IBOutlet NSLayoutConstraint * txtHeight;
    IBOutlet NSLayoutConstraint * collectionHeight;
    IBOutlet UICollectionView *cvBatches;
    NSTimer *timer;
    NSMutableArray *arrSheet;
    CourseFrom *courseFrom;
    
    NSString *signature;
    NSString *newNID;
    int batchcount;
    NSInteger selectedBatch;
    UIColor *selectedColor;
}
@end

@implementation CreateCourseiPadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrSheet = [[NSMutableArray alloc]init];
    arrTextField = [[NSMutableArray alloc]init];
    arrTxtCertificateField = [[NSMutableArray alloc]init];
    arrTBLData = [[NSMutableArray alloc]init];
    arrCategory = [[NSMutableArray alloc]init];
    arrImgFID = [[NSMutableArray alloc]init];
    cellUploadImageArray = [[NSMutableArray alloc]init];
    arrOffline =  [[NSMutableArray alloc]init];
    arrPics = [[NSMutableArray alloc]init];
    strYoutube1 = YoutubeBaseUrl;
    strCetificate1 = @"";
    tblPreview.rowHeight = UITableViewAutomaticDimension;
    tblPreview.estimatedRowHeight = 70;
    viewPreview.hidden = true;
    [self initWidget];
    [self configureLabelSlider];
    [self configureDatePicker];
    [self configureTimePicker];
    
    if (is_iPad()) {
        scrollHeight = 2900;
    } else {
        scrollHeight = 2150;
    }
    temptxtDescHeight = 150;
    txtDescHeight = 150;
    scrollHeight = scrollHeight + (cvPics.frame.size.width/5 - 150);
    mainViewheight.constant = scrollHeight;
    // Check for edit or new
    NSData *data = [UserDefault objectForKey:kCategoryKey];
    if (data)
    {
        NSArray *arrCat = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (NSDictionary *dict in arrCat)
        {
            CategoryEntity *entity = [[CategoryEntity alloc]initWithDictionary:dict];
            [arrCategory addObject:entity];
        }
    }
    isMediaOpen = false;
    if(![self checkStringValue:self.nid])
    {
        [self performSelector:@selector(getCourseDetailToEdit) withObject:self afterDelay:0.5];
        tempImg = [[UIImage alloc]init];
        self.title = @"Edit a Course";
    }else if(self.manageObj)
    {
        [self setCourseEntityFromDict];
        self.title = @"Edit a Course";
    } else {
        [self setPreferenceValue];
        self.title = @"Create a Course";
        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTimeriPad) userInfo:nil repeats:YES];
    }
    txt.layer.borderWidth = 0.0f;
    txt.layer.masksToBounds = true;
    txt.dataSource = self;
    
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
-(void)viewWillAppear:(BOOL)animated{
    if (is_iPad()) {
        tblPreview.contentInset = UIEdgeInsetsMake(140, 0, 0, 0);
    }
    [self updateToGoogleAnalytics:@"Create or Update course Screen"];

}
-(void)viewDidAppear:(BOOL)animated
{
    jswTrialClass.center = [swTrial center];
    swTrial.hidden = YES;
    [self initSwitchProperty:jswTrialClass];
    [viewMain addSubview:jswTrialClass];
    
    jswStatus.center = [swStatus center];
    swStatus.hidden = YES;
    [self initSwitchProperty:jswStatus];
    [viewMain addSubview:jswStatus];
    
    jswMoneyBack.center = [swMoneyBack center];
    swMoneyBack.hidden = YES;
    [self initSwitchProperty:jswMoneyBack];
    [viewMain addSubview:jswMoneyBack];
    
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, scrollHeight)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) updateTimeriPad{
    if ([txt.htmlString length] > 0) {
        [UserDefault setValue:txt.htmlString forKey:CFDescription];
    }
}
- (void) orientationChanged:(NSNotification *)note
{
    if (!is_iPad()) {
        return;
    }
    jswTrialClass.center = [swTrial center];
    swTrial.hidden = YES;
    [self initSwitchProperty:jswTrialClass];
    [viewMain addSubview:jswTrialClass];
    
    jswStatus.center = [swStatus center];
    swStatus.hidden = YES;
    [self initSwitchProperty:jswStatus];
    [viewMain addSubview:jswStatus];
    
    jswMoneyBack.center = [swMoneyBack center];
    swMoneyBack.hidden = YES;
    [self initSwitchProperty:jswMoneyBack];
    [viewMain addSubview:jswMoneyBack];
    [tblTimeTable reloadData];
    
}
#pragma mark: timeDelegate
-(void)selectedDatesTime:(NSString *)start EndTime:(NSString *)end copy:(NSString *)untillDate {
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [format dateFromString:start];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *compare = [format stringFromDate:date];
    NSLog(@"Compare : %@",compare);
    
    [BatchTimeTable insertTimes:courseFrom.courseBatchId from:start to:end Compare:compare UUID:UUIDString];
    BatchCell *cell = [tblTimeTable visibleCells][0];
    [cell.weekView reloadData];
    if (untillDate) {
        [cell copyUntill:untillDate startDate:start];
    }


}
-(void)reloadBatchesAfterDelete{
    BatchCell *cell = [tblTimeTable visibleCells][0];
    [cell.weekView reloadData];
}
-(void)selectedValue:(NSString *)val selectedCatIndex:(NSIndexPath *)index type:(BOOL)category
{
    if (!category)
    {
        tfSubCategory.text = val;
        SubCategoryEntity *entity = arrTBLData[index.row];
        subcatID = entity.tid;
        [UserDefault setValue:val forKey:CFSubcategoryCategory];
        [UserDefault setValue:subcatID forKey:CFSubcategoryCategoryID];
    }else
    {
        tfCategory.text = val;
        selectedCatIndex = index;
        tfSubCategory.text = @"SubCategory";
        [arrTBLData removeAllObjects];
        CategoryEntity *entity = arrCategory[index.row];
        [arrTBLData addObjectsFromArray:entity.subCategories];
        catID = entity.tid;
        [UserDefault setValue:val forKey:CFCategory];
        [UserDefault setValue:catID forKey:CFCategoryID];
        [UserDefault removeObjectForKey:CFSubcategoryCategory];
        [UserDefault removeObjectForKey:CFSubcategoryCategoryID];
        
    }
}

#pragma mark - Others
- (void) initWidget
{
    jswTrialClass = [[JTMaterialSwitch alloc] init];
    jswTrialClass.center = [swTrial center];
    swTrial.hidden = YES;
    jswTrialClass.delegate = self;
    [self initSwitchProperty:jswTrialClass];
    [viewMain addSubview:jswTrialClass];
    
    
    jswStatus = [[JTMaterialSwitch alloc] init];
    jswStatus.center = [swStatus center];
    swStatus.hidden = YES;
    [self initSwitchProperty:jswStatus];
    [viewMain addSubview:jswStatus];
    
    
    
    jswMoneyBack = [[JTMaterialSwitch alloc] init];
    jswMoneyBack.center = [swMoneyBack center];
    swMoneyBack.hidden = YES;
    [self initSwitchProperty:jswMoneyBack];
    [viewMain addSubview:jswMoneyBack];
    
    arrHinttext = [[NSMutableArray alloc] initWithObjects:hintTittle,hintLocation,
                   hintPrice,
                   hintDiscount,
                   hintAge,
                   hintQuality,
                   hintSold,
                   hintOfferFrom ,
                   hintOfferUntill,
                   hintStartDate,
                   hintEnddate,
                   hintTrial,
                   hintStatus ,
                   hintMoneyBack,
                   hinttimes,
                   hintNOS,
                   hintBatchSize ,
                   hintCourseReq,
                   hintYouTube ,
                   hintCertificate,
                   hintShortDesc,
                   hintDescription,
                   hintImages,
                   nil];
}
- (void)switchStateChanged:(JTMaterialSwitchState)currentState selected:(id)switchControl
{
    //    if (switchControl == jswTrialClass && currentState == JTMaterialSwitchStateOn) {
    //        trialNO.hidden = true;
    //        trialYES.hidden = false;
    //    }else{
    //        trialNO.hidden = false;
    //        trialYES.hidden = true;
    //    }
    //    if (switchControl == jswMoneyBack && currentState == JTMaterialSwitchStateOn) {
    //        moneyNO.hidden = true;
    //        moneyYES.hidden = false;
    //    }else{
    //        moneyNO.hidden = false;
    //        moneyYES.hidden = true;
    //    }
    //    if (switchControl == jswStatus && currentState == JTMaterialSwitchStateOn) {
    //        statusNO.hidden = true;
    //        statusYES.hidden = false;
    //    }else{
    //        statusNO.hidden = false;
    //        statusYES.hidden = true;
    //    }
}
-(IBAction) hindPopUp:(UIButton*) sender
{
    [self dismissAllPopTipViews];
    
    if (sender == self.currentPopTipViewTarget) {
        // Dismiss the popTipView and that is all
        self.currentPopTipViewTarget = nil;
    }  else {
        NSString *contentMessage = nil;
        contentMessage = [arrHinttext objectAtIndex:sender.tag];
        UIColor *backgroundColor = [UIColor whiteColor];
        UIColor *textColor = [UIColor darkGrayColor];
        CMPopTipView *popTipView;
        popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
        popTipView.delegate = self;
        
        popTipView.preferredPointDirection = PointDirectionDown;
        popTipView.cornerRadius = 2.0;
        
        if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
            popTipView.backgroundColor = backgroundColor;
        }
        if (textColor && ![textColor isEqual:[NSNull null]]) {
            popTipView.textColor = textColor;
        }
        
        popTipView.animation = arc4random() % 2;
        popTipView.has3DStyle = NO;//(BOOL)(arc4random() % 2);
        popTipView.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        popTipView.dismissTapAnywhere = YES;
        //        [popTipView autoDismissAnimated:YES atTimeInterval:1.0];
        
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sender;
            [popTipView presentPointingAtView:button inView:self.view animated:YES];
        }
        else {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
        }
        
        [self.visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = sender;
    }
}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}
- (void)dismissAllPopTipViews
{
    while ([self.visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:YES];
        [self.visiblePopTipViews removeObjectAtIndex:0];
    }
}
-(void)saveCurentOfflineCourseToDatabase:(NSMutableArray*)imagesArr{
    NSData *imageDataToSave = [NSKeyedArchiver archivedDataWithRootObject:imagesArr];
    NSData *courseDataToSave = [NSKeyedArchiver archivedDataWithRootObject:[self getCourseDictionaryToSubmit]];
    if (self.manageObj)
    {
        [self.manageObj setValue:imageDataToSave forKey:@"courseImage"];
        [self.manageObj setValue:courseDataToSave forKey:@"courseDetails"];
        UUIDString = [self.manageObj valueForKey:@"uid"];
        NSLog(@"UUID:%@",UUIDString);
        
    }else{
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"CourseOfflineEntity" inManagedObjectContext:APPDELEGATE.managedObjectContext];
        [object setValue:imageDataToSave forKey:@"courseImage"];
        [object setValue:courseDataToSave forKey:@"courseDetails"];
        //        UUIDString = [[NSUUID UUID] UUIDString];
        [object setValue:UUIDString forKey:@"uid"];
        NSLog(@"UUID:%@",UUIDString);
    }
    [APPDELEGATE saveContext];
    
}
- (void) initSwitchProperty:(JTMaterialSwitch*) jtSwitch {
    jtSwitch.thumbOnTintColor = UIColorFromRGB(0xfe3480);
    jtSwitch.thumbOffTintColor = UIColorFromRGB(0xa4a4a4);
    jtSwitch.trackOnTintColor = UIColorFromRGB(0xf892b8);
    jtSwitch.trackOffTintColor = UIColorFromRGB(0xcacaca);
}
-(NSArray*)getUnsubmittedDetailsFromDatabase{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CourseOfflineEntity" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    [request setEntity:entity];
    NSArray *results = [APPDELEGATE.managedObjectContext executeFetchRequest:request error:nil];
    if (results != nil && [results count] > 0)
    {
        return results;
    }
    return [[NSArray alloc] init];
}
-(void) saveToDB
{
    NSMutableArray *arrImages = [[NSMutableArray alloc]init];
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        for (id obj in cellUploadImageArray)
        {
            if ([obj isKindOfClass:[UIImage class]])
            {
                NSData *imageData = UIImageJPEGRepresentation(obj, 0.7);
                [arrImages addObject:imageData];
            }else
            {
                NSData* theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
                if (theData)
                {
                    tempImg = [UIImage imageWithData:theData];
                    NSData *imageData = UIImageJPEGRepresentation(tempImg, 0.7);
                    [arrImages addObject:imageData];
                }else if([obj isKindOfClass:[NSString class]])
                {
                    [arrImages addObject:obj];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            if (arrImages.count>0)
            {
                [self saveCurentOfflineCourseToDatabase:arrImages];
                NSArray *arrCourse = [self getUnsubmittedDetailsFromDatabase];
                if (arrCourse.count>0)
                {
                    for (NSManagedObject* courseObject in arrCourse)
                    {
                        if ([UUIDString isEqualToString:[courseObject valueForKey:@"uid"]])
                        {
                            [arrOffline removeAllObjects];
                            [arrOffline addObject:courseObject];
                            [self stopActivity];
                            [self syscOfflineCourse];
                            break;
                        }
                    }
                }else
                {
                    showAletViewWithMessage(@"Something went wrong.");
                    [self stopActivity];
                    
                }
                
            }
        });
    });
}
-(void) syscOfflineCourse
{
    if (arrOffline.count == 0) {
        return;
    }
    [timer invalidate];
    timer = nil;
    [self removePreferenceData];
    NSManagedObject* courseObject = [arrOffline firstObject];
    NSArray* courseImageArr = [NSKeyedUnarchiver unarchiveObjectWithData:[courseObject valueForKey:@"courseImage"]];
    [hud hide:true];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = [NSString stringWithFormat:@"Uploading 1 of %d",(int)courseImageArr.count];
    [UploadManager sharedInstance].delegate = self;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (id data in courseImageArr)
    {
        if ([data isKindOfClass:[NSData class]])
        {
            
            [arr addObject:[UIImage imageWithData:data]];
        }else if([data isKindOfClass:[NSString class]])
        {
            
            NSData* theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:data]];
            if (theData)
            {
                tempImg = [UIImage imageWithData:theData];
                [arr addObject:tempImg];
                
            }
        }
    }
    if (arr.count>0)
    {
        [[UploadManager sharedInstance] uploadImagesWithArray:arr];
    }else{
        showAletViewWithMessage(@"Error occurs while course posting.Your course saved and will be submitted as soon internet available");
        [self clearData];
    }
    
    
}
-(void) uploadOfflineCourseToServer:(NSArray*) arrPic
{
    NSManagedObject* courseObject = [arrOffline firstObject];
    NSDictionary* courseDataDic = [NSKeyedUnarchiver unarchiveObjectWithData:[courseObject valueForKey:@"courseDetails"]];
    
    NSLog(@"courseDataDic:%@",courseDataDic);
    NSMutableDictionary *dict = [courseDataDic mutableCopy];
    [dict setValue:arrPic forKey:@"images_fids"];
    NSLog(@"courseDataDic set imageID:%@",dict);
    
    if (dict[@"nid"])
    {
        // Edit course
        [self editCourse:dict];
    }
    else
    {
        // post new course
        [self postCourse:dict];
        
    }
}
-(void) getCourseDetailToEdit
{
    [self startActivity];
    [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@",apiCourseDetailUrl,self.nid] paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *d = [jsonData mutableCopy];
                [d handleNullValue];
                self.courseEdit = [[CourseDetail alloc]initWith:d];
                NSLog(@"courseEntity : :%@",self.self.courseEdit);
                [self setValueUI:true];
            }
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
-(void) setCourseEntityFromDict
{
    NSDictionary* courseDataDic = [NSKeyedUnarchiver unarchiveObjectWithData:[self.manageObj valueForKey:@"courseDetails"]];
    
    NSLog(@"courseDataDic:%@",courseDataDic);
    UUIDString = [self.manageObj valueForKey:@"uid"];
    selectedColor =  [UIColor randomColor];
    selectedBatch = 0;
    batchcount = 1;
    if (![self checkStringValue:UUIDString]) {
        NSArray *batchesArr = [MyCourseOffline getobjectbyId:UUIDString];
        if (batchesArr && batchesArr.count > 0) {
            for (MyCourseOffline *obj in batchesArr) {
                CourseFrom * newCourse = [[CourseFrom alloc]init];
                newCourse.courseBatchId = obj.mBatchId;
                newCourse.coursestartDate = obj.mStartDate;
                newCourse.courseEndDate = obj.mEndDate;
                newCourse.coursePrice = obj.mPrice;
                newCourse.courseDiscount = obj.mDiscount;
                newCourse.courseSession = obj.mSession;
                newCourse.courseBatchSize = obj.mBatchSize;
                [arrSheet addObject:newCourse];
                batchcount = batchcount + 1;
            }
            
        }
    }
    if (arrSheet.count > 0) {
        courseFrom = [arrSheet firstObject];
    }
    [tblTimeTable reloadData];
    [cvBatches reloadData];
    
    self.courseEdit = [[CourseDetail alloc]init];
    self.courseEdit.nid = courseDataDic[@"nid"];
    NSArray * arr = courseDataDic[@"products"];
    if (arr && arr.count>0) {
        NSDictionary * dict = arr[0];
        if (dict) {
            NSDictionary *age = dict[@"age"];//
            if (age.count > 1)
            {
                NSString *from = age[@"from"];
                NSString *to = age[@"to"];
                [self.labelSlider setLowerValue:[from floatValue]];
                [self.labelSlider setUpperValue:[to floatValue]];
            }
            self.courseEdit.sold = dict[@"sold"];
            self.courseEdit.tutor = dict[@"tutor"];
            self.courseEdit.quantity = dict[@"stock"];
            self.courseEdit.status = dict[@"status"];
        }
    }
    self.courseEdit.offer_valid_from = courseDataDic[@"offer_valid_from"];
    self.courseEdit.offer_valid_untill = courseDataDic[@"offer_valid_untill"];
    
    NSArray *arrCert = courseDataDic[@"certification"];
    if (arrCert.count > 1) {
        NSString * result = [[arrCert valueForKey:@"description"] componentsJoinedByString:@","];
        self.courseEdit.certifications  = result;
    }else if(arrCert.count >0 )
    {
        self.courseEdit.certifications = [arrCert firstObject];
    }
    self.courseEdit.course_requirements = courseDataDic[@"course_requirements"];
    
    NSArray *arrCatSub = courseDataDic[@"category"];
    for (CategoryEntity *entity in arrCategory)
    {
        if ([entity.tid isEqual:arrCatSub[0]])
        {
            tfCategory.text = entity.category;
            self.courseEdit.category = entity.category;
            catID = entity.tid;
        }
        
        for(SubCategoryEntity *subEnt in entity.subCategories)
        {
            if ([subEnt.tid isEqual:arrCatSub[1]])
            {
                tfSubCategory.text = subEnt.subCategory;
                self.courseEdit.subcategory = subEnt.subCategory;
                subcatID = subEnt.tid;
            }
        }
    }
    self.courseEdit.youtube_video = [[NSMutableArray alloc]init];
    [self.courseEdit.youtube_video addObjectsFromArray:courseDataDic[@"youtube"]];
    NSDictionary *addDict = courseDataDic[@"address"];
    self.courseEdit.address_1 = addDict[@"thoroughfare"];
    self.courseEdit.address_2 = addDict[@"premise"];
    self.courseEdit.city = addDict[@"locality"];
    self.courseEdit.postal_code = addDict[@"postal_code"];
    self.courseEdit.title = courseDataDic[@"title"];
    self.courseEdit.Description = courseDataDic[@"description"];
    self.courseEdit.short_description = courseDataDic[@"short_description"];
    self.courseEdit.field_money_back_guarantee = courseDataDic[@"money_back_guarantee"];
    
    self.courseEdit.field_deal_image = [[NSMutableArray alloc]init];
    NSArray* courseImageArr = [NSKeyedUnarchiver unarchiveObjectWithData:[self.manageObj valueForKey:@"courseImage"]];
    for (id data in courseImageArr)
    {
        if ([data isKindOfClass:[NSData class]])
        {
            [self.courseEdit.field_deal_image addObject:[UIImage imageWithData:data]];
        }else if([data isKindOfClass:[NSString class]])
        {
            [self.courseEdit.field_deal_image addObject:data];
        }
    }
    [self setValueUI:false];
}
-(void) setValueUI:(BOOL) isNewToInsert
{
    tfTittle.text = self.courseEdit.title;
    tfaddress1.text = self.courseEdit.address_1;
    tfaddress2.text = self.courseEdit.address_2;
    tfcity.text = self.courseEdit.city;
    tfPincode.text = self.courseEdit.postal_code;
    if (self.courseEdit.productArr.count > 0) {
        ProductEntity * proObj = self.courseEdit.productArr[0];
        tfquantity.text = proObj.quantity;
        tfsold.text = proObj.sold;
        tfTutorName.text = proObj.tutor;
        
        NSArray *arrAge = [proObj.field_age_group componentsSeparatedByString:@"-"];
        if (arrAge.count == 2)
        {
            [self.labelSlider setLowerValue:[arrAge[0] floatValue]];
            [self.labelSlider setUpperValue:[arrAge[1] floatValue]];
        }
        if ([[proObj.status uppercaseString] isEqualToString:@"1"])
        {
            [jswStatus setOn:YES animated:NO];
        }else{
            [jswStatus setOn:NO animated:NO];
        }
    }else{
        tfTutorName.text = self.courseEdit.tutor;
        tfquantity.text = self.courseEdit.quantity;
        tfsold.text = self.courseEdit.sold;
        if ([[self.courseEdit.status uppercaseString] isEqualToString:@"1"])
        {
            [jswStatus setOn:YES animated:NO];
        }else{
            [jswStatus setOn:NO animated:NO];
        }
    }
    
    
    if (![self checkStringValue:self.courseEdit.offer_valid_from])
    {
        tfOfferStartDate.text = self.courseEdit.offer_valid_from;
    }
    if (![self checkStringValue:self.courseEdit.offer_valid_untill])
    {
        tfOfferEndDate.text = self.courseEdit.offer_valid_untill;
    }
    
    if (![self checkStringValue:self.courseEdit.course_requirements]) {
        txtRequirement.text = self.courseEdit.course_requirements;
        lblRequirment.hidden =true;
    }
    
    if (![self checkStringValue:self.courseEdit.Description])
    {
        [self setHtmlStringDescription:self.courseEdit.Description];
    }
    if (![self checkStringValue:self.courseEdit.short_description])
    {
        txtShortDesc.text = self.courseEdit.short_description;
        lblShortDesc.hidden =true;
    }
    
    if (![self checkStringValue:self.courseEdit.certifications])
    {
        NSMutableArray *arrTemp = [[self.courseEdit.certifications componentsSeparatedByString:@","] mutableCopy];
        if (arrTemp && arrTemp.count>0)
        {
            strCetificate1 = arrTemp[0];
            [arrTemp removeObjectAtIndex:0];
            if (arrTemp.count>0)
            {
                [arrTxtCertificateField addObjectsFromArray:arrTemp];
            }
            [self increseViewSize];
            
            tblCertificatesHeightConstraints.constant = tbltxtCertificates.contentSize.height;
            [tbltxtCertificates reloadData];
            
        }
    }
    if (self.courseEdit.youtube_video && self.courseEdit.youtube_video.count>0)
    {
        int i = 0;
        for (NSString *str in self.courseEdit.youtube_video)
        {
            if (i == 0)
            {
                strYoutube1 =str;
                i++;
            }
            else
            {
                [arrTextField addObject: str];
            }
            [self increseViewSize];
            
        }
        [tbltxtYoutube reloadData];
        tblHeightConstraints.constant = tbltxtYoutube.contentSize.height;
        [self.view layoutIfNeeded];
    }
    for (CategoryEntity *entity in arrCategory)
    {
        NSString *str = [self.courseEdit.category stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
        
        NSLog(@"STORE : %@ AND PASS : %@",entity.category,str);
        
        if ([entity.category isEqualToString:str])
        {
            tfCategory.text = entity.category;
            catID = entity.tid;
        }
        
        for(SubCategoryEntity *subEnt in entity.subCategories)
        {
            NSString *str = [self.courseEdit.subcategory stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
            if ([subEnt.subCategory isEqualToString:str]) {
                tfSubCategory.text = str;
                subcatID = subEnt.tid;
            }
        }
        
    }
    if ([[self.courseEdit.field_money_back_guarantee uppercaseString] isEqualToString:@"0"])
    {
        [jswMoneyBack setOn:NO animated:NO];
    }else{
        [jswMoneyBack setOn:YES animated:NO];
    }
    if ([[self.courseEdit.field_trial_class uppercaseString] isEqualToString:@"1"])
    {
        [jswTrialClass setOn:YES animated:NO];
    }else{
        [jswTrialClass setOn:NO animated:NO];
    }
    
    if ([self.courseEdit.field_deal_image isKindOfClass:[NSArray class]])
    {
        cellUploadImageArray = self.courseEdit.field_deal_image;
    }else if([self.courseEdit.field_deal_image isKindOfClass:[NSString class]]) {
        [cellUploadImageArray addObject:self.courseEdit.field_deal_image];
    }
    
    [cvPics reloadData];
    if (!isNewToInsert) {
        return;
    }
    //New
    UUIDString = [[NSUUID UUID] UUIDString];
    selectedColor =  [UIColor randomColor];
    selectedBatch = 0;
    batchcount = 1;
    
    NSDateFormatter *format11 = [[NSDateFormatter alloc]init];
    [format11 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDateFormatter *format33 = [[NSDateFormatter alloc]init];
    [format33 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    NSDateFormatter *format22 = [[NSDateFormatter alloc]init];
    [format22 setDateFormat:@"yyyy-MM-dd"];
    
    for(ProductEntity * obj in self.courseEdit.productArr) {
        CourseFrom * newCourse = [[CourseFrom alloc]init];
        newCourse.courseBatchId = obj.product_id;// GetTimeStampString;
        newCourse.coursestartDate = obj.course_start_date;
        newCourse.courseEndDate = obj.course_end_date;
        NSString* totalString = [obj.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
        NSString* discountString = [obj.price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
        newCourse.coursePrice = totalString;
        newCourse.courseDiscount = discountString;
        newCourse.courseSession = obj.sessions_number;
        newCourse.courseBatchSize = obj.batch_size;
        [MyCourseOffline insertCourse:newCourse uid:UUIDString];
        
        for(NSDictionary *d in obj.timings) {
            if (d[@"value"] != nil && d[@"value2"] != nil) {
                NSString *start = d[@"value"];
                NSString *end = d[@"value2"];
                NSDate *date = [format11 dateFromString:start]; // For the compare
                NSDate *s1 = [format11 dateFromString:start];
                NSDate *e2 = [format11 dateFromString:end];
                if (s1 && e2) {
                    NSString  *startDate = [format33 stringFromDate:s1];
                    NSString *endDate = [format33 stringFromDate:e2];
                    if (date) {
                        NSString *compare = [format22 stringFromDate:date];
                        [BatchTimeTable insertTimes:newCourse.courseBatchId from:startDate to:endDate Compare:compare UUID:UUIDString];
                    }
                }
            }
        }
        [arrSheet addObject:newCourse];
        batchcount = batchcount + 1;
    }
    if (arrSheet.count > 0) {
        courseFrom = [arrSheet firstObject];
    }
    [tblTimeTable reloadData];
    [cvBatches reloadData];
    
}
-(void) setHtmlStringDescription:(NSString *) str {
    NSString *string = [str stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'PROXIMANOVA-REGULAR'; font-size:17px;}</style>"]];
    
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                  documentAttributes:nil
                                                                               error:nil];
    
    NSMutableAttributedString *res = [attributedString1 mutableCopy];
    [res beginEditing];
    [res enumerateAttribute:NSFontAttributeName
                    inRange:NSMakeRange(0, res.length)
                    options:0
                 usingBlock:^(id value, NSRange range, BOOL *stop) {
                     if (value) {
                         UIFont *oldFont = (UIFont *)value;
                         UIFont *newFont = (is_iPad())?[oldFont fontWithSize:17]:[oldFont fontWithSize:15];
                         [res addAttribute:NSFontAttributeName value:newFont range:range];
                     }
                 }];
    [res endEditing];
    
    txt.attributedText = res;
    txtHeight.constant = ([txt contentSize].height <150)?150:[txt contentSize].height;
    
    if ([txt contentSize].height > 150)
    {
        txtDescHeight = [txt contentSize].height;
        scrollHeight = scrollHeight + ([txt contentSize].height - 150);
        mainViewheight.constant = scrollHeight;
        [self viewDidLayoutSubviews];
    }
    lblCaptionDesc.hidden =true;
    
}

-(BOOL) validationFrom
{
    if ([self checkStringValue:catID]) {
        showAletViewWithMessage(@"Please select category.");
        return false;
    }
    
    if ([self checkStringValue:subcatID]) {
                showAletViewWithMessage(@"Please select subcategory.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfTittle]) {
        
        showAletViewWithMessage(@"Please enter valid course tittle.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfaddress1]) {
        showAletViewWithMessage(@"Please enter valid address1.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfaddress2]) {
        showAletViewWithMessage(@"Please enter valid address2.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfcity]) {
        showAletViewWithMessage(@"Please enter valid city.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfPincode]) {
        showAletViewWithMessage(@"Please enter valid pincode.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfquantity]) {
        showAletViewWithMessage(@"Please enter valid quantity.");
        return false;
    }
    
    if ([tfquantity.text intValue] > 49 || [tfquantity.text intValue] <= 0 ) {
        showAletViewWithMessage(@"Please enter quanity between 1 to 49.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfsold]) {
        showAletViewWithMessage(@"Please enter valid sold.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfOfferStartDate]) {
        showAletViewWithMessage(@"Please enter offer start date.");
        return false;
    }
    if ([self checkTextfieldValue:tfOfferEndDate]) {
        showAletViewWithMessage(@"Please enter offer end date.");
        return false;
    }
    
    NSDateFormatter *outputFormatter1 = [[NSDateFormatter alloc] init];
    [outputFormatter1 setDateFormat:@"dd-EEE-yy"]; //24hr time format
    NSDate *date1 = [outputFormatter1 dateFromString:tfOfferStartDate.text];
    NSDate *date2 = [outputFormatter1 dateFromString:tfOfferEndDate.text];
    
    if ([date1 compare:date2] == NSOrderedDescending)
    {
        showAletViewWithMessage(@"Offer end date can’t be earlier than start date.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfTutorName]) {
        showAletViewWithMessage(@"Please enter tutor name.");
        return false;
    }
    
    if ([txtRequirement.text isEqualToString:@"Course requirement"] || [txtRequirement.text isEqualToString:@""])
    {
        showAletViewWithMessage(@"Please enter course requirements");
        return false;
    }
    return true;
}
-(BOOL) validationFrom:(id)txtField
{
    if ([self checkTextfieldValue:tfTittle] && txtField == tfTittle) {
        showAletViewWithMessage(@"Please enter valid course tittle.");
        return false;
    }
    
    
    if ([self checkTextfieldValue:tfaddress1] && txtField == tfaddress1) {
        showAletViewWithMessage(@"Please enter valid address1.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfaddress2] && txtField == tfaddress2) {
        showAletViewWithMessage(@"Please enter valid address2.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfcity] && txtField == tfcity) {
        showAletViewWithMessage(@"Please enter valid city.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfPincode] && txtField == tfPincode) {
        showAletViewWithMessage(@"Please enter valid pincode.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfquantity] && txtField == tfquantity) {
        showAletViewWithMessage(@"Please enter valid quantity.");
        return false;
    }
    
    if (([tfquantity.text intValue] > 49 || [tfquantity.text intValue] <= 0) && txtField == tfquantity) {
        showAletViewWithMessage(@"Please enter quanity between 1 to 49.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfsold] && txtField == tfsold) {
        showAletViewWithMessage(@"Please enter valid sold.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfOfferStartDate] && txtField == tfOfferStartDate) {
        showAletViewWithMessage(@"Please enter offer start date.");
        return false;
    }
    if ([self checkTextfieldValue:tfOfferEndDate] && txtField == tfOfferEndDate) {
        showAletViewWithMessage(@"Please enter offer end date.");
        return false;
    }
    
    NSDateFormatter *outputFormatter1 = [[NSDateFormatter alloc] init];
    [outputFormatter1 setDateFormat:@"dd-EEE-yy"]; //24hr time format
    NSDate *date1 = [outputFormatter1 dateFromString:tfOfferStartDate.text];
    NSDate *date2 = [outputFormatter1 dateFromString:tfOfferEndDate.text];
    
    if ([date1 compare:date2] == NSOrderedDescending)
    {
        showAletViewWithMessage(@"Offer end date can’t be earlier than start date.");
        return false;
    }
    
    if ([self checkTextfieldValue:tfTutorName] && txtField == tfTutorName) {
        showAletViewWithMessage(@"Please enter tutor name.");
        return false;
    }
    
    if (([txtRequirement.text isEqualToString:@"Course requirement"] || [txtRequirement.text.tringString isEqualToString:@""]) && txtField == txtRequirement)
    {
        showAletViewWithMessage(@"Please enter course requirements");
        return false;
    }
    if (([txtShortDesc.text isEqualToString:@"Short Description"] || [txtShortDesc.text.tringString isEqualToString:@""]) && txtField == txtShortDesc)
    {
        showAletViewWithMessage(@"Please enter short description");
        return false;
    }
    return true;
}

-(BOOL) validationMutipleTabs {
    //getobjectbyStartDate
    if (![self checkStringValue:self.nid]) {
        return true;
    }
    int i = 0;
    for (CourseFrom * course in arrSheet)
    {
        i = i + 1;
        NSArray *arr = [BatchTimeTable getobjectbyBatchID:course.courseBatchId];
        if (arr.count == 0) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please enter valid time for batch %d",i]);
            return false;
            break;
        }
       
        NSDate *startDate = [globalDateOnlyFormatter() dateFromString:course.coursestartDate];
        NSDate *endDate = [globalDateOnlyFormatter() dateFromString:course.courseEndDate];
        NSDateComponents *monthDifference = [[NSDateComponents alloc] init];
        NSMutableSet *dates = [[NSMutableSet alloc]init];
        NSUInteger monthOffset = 0;
        NSDate *nextDate = startDate;
        do {
            [dates addObject:nextDate];
            [monthDifference setMonth:monthOffset++];
            NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:monthDifference toDate:startDate options:0];
            nextDate = d;
        } while([nextDate compare:endDate] == NSOrderedAscending);
        
        [dates addObject:endDate];
        for (NSDate *date in dates) {
            NSDateComponents *dateComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
          
            NSDate * firstDateOfMonth = [self returnDateForMonth:dateComponents.month year:dateComponents.year day:1];
            NSDate * lastDateOfMonth = [self returnDateForMonth:dateComponents.month+1 year:dateComponents.year day:0];
            
            NSString *fDate =[globalDateFormatter() stringFromDate:firstDateOfMonth];
            NSString *lDate =[globalDateFormatter() stringFromDate:lastDateOfMonth];
            NSArray * temp = [BatchTimeTable getTimeForMonth:fDate endDate:lDate];
            NSLog(@"%d",temp.count);
            if (temp.count == 0) {
                showAletViewWithMessage([NSString stringWithFormat:@"Please add atleast one batch for month %@",[frmMONTHFormatter() stringFromDate:firstDateOfMonth]]);
                return false;
                break;
            }
        }
    }
    
    
    return true;
}
- (NSDate *)returnDateForMonth:(NSInteger)month year:(NSInteger)year day:(NSInteger)day {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return [CURRENT_CALENDAR dateFromComponents:components];
}
-(NSString *) getFeildName:(int) index {
    if (index == 0) {
        return @"field_mon";
    }else if (index == 1){
        return @"field_tue";
    }else if (index == 2){
        return @"field_wed";
    }else if (index == 3){
        return @"field_thu";
    }else if (index == 4){
        return @"field_fri";
    }else if (index == 5){
        return @"field_sat";
    }else if (index == 6){
        return @"field_sun";
    }
    return @"";
}
-(NSMutableArray*) getMultipleCourseEditDictionary {
    NSMutableArray * arrMain = [[NSMutableArray alloc]init];
    NSMutableArray * arrNewProduct = [[NSMutableArray alloc]init];
    NSMutableArray * arrOldProduct = [[NSMutableArray alloc]init];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (int j=0; j< arrSheet.count; j++) {
        
        CourseFrom * course = arrSheet[j];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        NSArray * arr = [BatchTimeTable getobjectbyBatchID:course.courseBatchId];
        NSMutableArray *arrTimes =[[NSMutableArray alloc]init];
        for (BatchTimeTable *obj in arr) {
            
            NSDateFormatter *formater2 = [[NSDateFormatter alloc]init];
            [formater2 setDateFormat:@"yyyy-MM-dd hh:mm a"];
            NSDate *ds= [formater2 dateFromString:obj.mStartTime];
            NSDate *de= [formater2 dateFromString:obj.mEndTime];
            
            NSString *sss = [formater stringFromDate:ds];
            NSString *eee = [formater stringFromDate:de];
            NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
            [d setValue:sss forKey:@"value"];
            [d setValue:eee forKey:@"value2"];
            [arrTimes addObject:d];
            
        }
        if (course.courseBatchId.length > 7) {
            NSLog(@"course.courseBatchId: %@",course.courseBatchId);
        }else{
            [dict setValue:course.courseBatchId forKey:@"product_id"];
        }
        [dict setValue:arrTimes forKey:@"timing"];
        [dict setValue:@{@"from":self.lowerLabel.text,@"to":self.upperLabel.text} forKey:@"age"];
        [dict setValue:course.coursePrice forKey:@"initial_price"];
        [dict setValue:course.coursestartDate forKey:@"start_date"];
        [dict setValue:course.courseEndDate forKey:@"end_date"];
        [dict setValue:course.courseDiscount forKey:@"discounted_price"];
        [dict setValue:course.courseSession forKey:@"sessions"];
        [dict setValue:course.courseBatchSize forKey:@"batch_size"];
        [dict setValue:tfTutorName.text forKey:@"tutor"];
        
        [dict setValue:tfTutorName.text forKey:@"tutor"];
        [dict setValue:tfquantity.text forKey:@"stock"];
        [dict setValue:tfsold.text forKey:@"sold"];
        
        NSString *strTrial,*strStatus;
        
        if ([jswStatus getSwitchState]){ strStatus = @"1";
        }else{strStatus = @"0";}
        if ([jswTrialClass getSwitchState]){ strTrial = @"1";
        }else{strTrial = @"0";}
        
        [dict setValue:strStatus forKey:@"status"];
        [dict setValue:strTrial forKey:@"trial_class"];
        if (course.courseBatchId.length > 7) {
            [arrNewProduct addObject:dict];
        }else{
            [arrOldProduct addObject:dict];
        }
    }
    [arrMain addObject:arrNewProduct];
    [arrMain addObject:arrOldProduct];
    return arrMain;
}

-(NSMutableArray*) getMultipleCourseDictionary {
    NSMutableArray * arrMain = [[NSMutableArray alloc]init];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (int j=0; j< arrSheet.count; j++) {
        CourseFrom * course = arrSheet[j];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        NSArray * arr = [BatchTimeTable getobjectbyBatchID:course.courseBatchId];
        NSMutableArray *arrTimes =[[NSMutableArray alloc]init];
        for (BatchTimeTable *obj in arr) {
            
            NSDateFormatter *formater2 = [[NSDateFormatter alloc]init];
            [formater2 setDateFormat:@"yyyy-MM-dd hh:mm a"];
            NSDate *ds= [formater2 dateFromString:obj.mStartTime];
            NSDate *de= [formater2 dateFromString:obj.mEndTime];
            
            NSString *sss = [formater stringFromDate:ds];
            NSString *eee = [formater stringFromDate:de];
            NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
            [d setValue:sss forKey:@"value"];
            [d setValue:eee forKey:@"value2"];
            [arrTimes addObject:d];
            
        }
        [dict setValue:arrTimes forKey:@"timing"];
        [dict setValue:@{@"from":self.lowerLabel.text,@"to":self.upperLabel.text} forKey:@"age"];
        [dict setValue:course.coursePrice forKey:@"initial_price"];
        [dict setValue:course.coursestartDate forKey:@"start_date"];
        [dict setValue:course.courseEndDate forKey:@"end_date"];
        [dict setValue:course.courseDiscount forKey:@"discounted_price"];
        [dict setValue:course.courseSession forKey:@"sessions"];
        [dict setValue:course.courseBatchSize forKey:@"batch_size"];
        [dict setValue:tfTutorName.text forKey:@"tutor"];
        
        [dict setValue:tfTutorName.text forKey:@"tutor"];
        [dict setValue:tfquantity.text forKey:@"stock"];
        [dict setValue:tfsold.text forKey:@"sold"];
        
        NSString *strTrial,*strStatus;
        
        if ([jswStatus getSwitchState]){ strStatus = @"1";
        }else{strStatus = @"0";}
        if ([jswTrialClass getSwitchState]){ strTrial = @"1";
        }else{strTrial = @"0";}
        
        [dict setValue:strStatus forKey:@"status"];
        [dict setValue:strTrial forKey:@"trial_class"];
        [arrMain addObject:dict];
    }
    return arrMain;
}

-(NSDictionary *) getCourseDictionaryToSubmit{
    
    NSString *strMoney;
    if ([jswMoneyBack getSwitchState]){ strMoney = @"1";
    } else { strMoney = @"0"; }
    
    if (self.manageObj) {
        
    }
    if([self checkStringValue:self.nid] && self.manageObj == nil) // create new course
    {
        NSDictionary * dict = @{
                                @"title":tfTittle.text,
                                @"category":@[catID,subcatID],
                                @"offer_valid_from":tfOfferStartDate.text,
                                @"offer_valid_untill":tfOfferEndDate.text,
                                @"money_back_guarantee":strMoney,
                                @"course_requirements":txtRequirement.text,
                                @"youtube":[self getYoutubeData],
                                @"description":txt.htmlString,
                                @"short_description":txtShortDesc.text,
                                @"certification":[self getCertificatesData],
                                @"products":[self getMultipleCourseDictionary],
                                @"address":@{@"postal_code":tfPincode.text,@"thoroughfare":tfaddress1.text,@"premise":tfaddress2.text,@"locality":tfcity.text,@"administrative_area":@"sss"}};
        
        NSLog(@"%@", convertObjectToJson(dict));
        
        return dict;
    } else {
        if ([self checkStringValue:self.nid]) { //Create new course first time fail empty nid
            NSDictionary * dict = @{
                                    @"title":tfTittle.text,
                                    @"category":@[catID,subcatID],
                                    @"offer_valid_from":tfOfferStartDate.text,
                                    @"offer_valid_untill":tfOfferEndDate.text,
                                    @"money_back_guarantee":strMoney,
                                    @"course_requirements":txtRequirement.text,
                                    @"youtube":[self getYoutubeData],
                                    @"description":txt.htmlString,
                                    @"short_description":txtShortDesc.text,
                                    @"certification":[self getCertificatesData],
                                    @"products":[self getMultipleCourseDictionary],
                                    @"address":@{@"postal_code":tfPincode.text,@"thoroughfare":tfaddress1.text,@"premise":tfaddress2.text,@"locality":tfcity.text,@"administrative_area":@"sss"}};
            
            NSLog(@"%@", convertObjectToJson(dict));
            
            return dict;
        }else{
            NSMutableArray *arr = [self getMultipleCourseEditDictionary];
            NSMutableArray *arrNew = arr[0];
            NSMutableArray *arrOld = arr[1];
            if (arrNew.count > 0) {
                NSDictionary * dict = @{
                                        @"nid":self.courseEdit.nid,
                                        @"title":tfTittle.text,
                                        @"category":@[catID,subcatID],
                                        @"offer_valid_from":tfOfferStartDate.text,
                                        @"offer_valid_untill":tfOfferEndDate.text,
                                        @"money_back_guarantee":strMoney,
                                        @"course_requirements":txtRequirement.text,
                                        @"youtube":[self getYoutubeData],
                                        @"description":txt.htmlString,
                                        @"short_description":txtShortDesc.text,
                                        @"certification":[self getCertificatesData],
                                        @"products":arrOld,
                                        @"new_products":arrNew,
                                        @"address":@{@"postal_code":tfPincode.text,@"thoroughfare":tfaddress1.text,@"premise":tfaddress2.text,@"locality":tfcity.text,@"administrative_area":@"sss"}};
                
                NSLog(@"%@", convertObjectToJson(dict));
                return dict;
                
            }else{
                NSDictionary * dict = @{
                                        @"nid":self.courseEdit.nid,
                                        @"title":tfTittle.text,
                                        @"category":@[catID,subcatID],
                                        @"offer_valid_from":tfOfferStartDate.text,
                                        @"offer_valid_untill":tfOfferEndDate.text,
                                        @"money_back_guarantee":strMoney,
                                        @"course_requirements":txtRequirement.text,
                                        @"youtube":[self getYoutubeData],
                                        @"description":txt.htmlString,
                                        @"short_description":txtShortDesc.text,
                                        @"certification":[self getCertificatesData],
                                        @"products":arrOld,
                                        @"address":@{@"postal_code":tfPincode.text,@"thoroughfare":tfaddress1.text,@"premise":tfaddress2.text,@"locality":tfcity.text,@"administrative_area":@"sss"}};
                
                NSLog(@"%@", convertObjectToJson(dict));
                return dict;
            }
        }
    }
    
    return nil;
}

-(NSMutableArray*) getYoutubeData
{
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    if (btnVideIgnore.selected)
    {
        return arrData;
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    YoutubeCell *cell = [tbltxtYoutube cellForRowAtIndexPath:index];
    if (![self checkStringValue:cell.tfYoutube.text]) {
        [arrData addObject:cell.tfYoutube.text];
    }
    
    for (int i= 0; i < arrTextField.count; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:1];
        YoutubeCell *cell = [tbltxtYoutube cellForRowAtIndexPath:index];
        if (![self checkStringValue:cell.tfYoutube.text]) {
            [arrData addObject:cell.tfYoutube.text];
        }
    }
    return arrData;
    
}

-(NSMutableArray*) getCertificatesData
{
    NSMutableArray *arrData = [[NSMutableArray alloc]init];
    
    if (btnCertificateIgnore.selected) {
        return arrData;
    }
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    CertificatesCell *cell = [tbltxtCertificates cellForRowAtIndexPath:index];
    if (![self checkStringValue:cell.tfCertificates.text]) {
        [arrData addObject:cell.tfCertificates.text];
    }
    
    for (int i= 0; i < arrTxtCertificateField.count; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:1];
        CertificatesCell *cell = [tbltxtCertificates cellForRowAtIndexPath:index];
        if (![self checkStringValue:cell.tfCertificates.text]) {
            [arrData addObject:cell.tfCertificates.text];
        }
    }
    return arrData;
}



#pragma mark - UIbutton Action
-(IBAction)btnSubmit:(id)sender
{
    if (![self validationFrom])
    {
        return;
    }
    if (![self validationMutipleTabs]) {
        return;
    }
    NSMutableArray * arrYoutube = [self getYoutubeData];
    if (arrYoutube.count == 0 && !btnVideIgnore.selected)
    {
        showAletViewWithMessage(@"Please enter youtube video url.");
        return;
    }
    
    NSMutableArray * arrCert = [self getCertificatesData];
    if (arrCert.count == 0 && !btnCertificateIgnore.selected)
    {
        showAletViewWithMessage(@"Please enter certificate.");
        return;
    }
    
    if ([self checkStringValue:txt.text.tringString])
    {
        showAletViewWithMessage(@"You must enter a Course Description , tell me more on your course");
        return;
    }
    
    
    
    if (cellUploadImageArray.count > 0)
    {
        [self startActivity];
        [self saveToDB];
        
    }else{
        showAletViewWithMessage(@"Please select picture.");
    }
}


-(IBAction)btnPopUp:(UIButton*)sender
{
    
    // Alter the code for genric pop up
    if (sender.tag == 22)
    {
        PopUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpViewController"];
        vc.view.backgroundColor = [UIColor clearColor];
        vc.isTypeCat = true;
        vc.delegate = self;
        vc.frame = (is_iPad())?(self.view.frame.size.width * 0.4):(self.view.frame.size.width * 0.9);
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
        
    }else
    {
        if ([self checkTextfieldValue:tfCategory]) {
            return;
        }
        PopUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpViewController"];
        vc.view.backgroundColor = [UIColor clearColor];
        vc.isTypeCat = false;
        vc.delegate = self;
        vc.frame = (is_iPad())?(self.view.frame.size.width * 0.4):(self.view.frame.size.width * 0.9);
        vc.selectedCatIndex = selectedCatIndex;
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
    }
}

-(IBAction)btnYoutubeIgnore:(UIButton*)sender
{
    if (sender.selected)
    {
        sender.selected = false;
    }else{
        sender.selected = true;
    }
}
-(IBAction)btnCertificateIgnore:(UIButton*)sender
{
    if (sender.selected)
    {
        sender.selected = false;
    }else{
        sender.selected = true;
    }
}
#pragma mark - UITableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tbltxtYoutube || tableView == tbltxtCertificates) {
        return 2;
    }
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblPreview) {
        return 1;
    }
    if (tableView == tbltxtYoutube)
    {
        if (section == 0) {
            return 1;
        }else if(section == 1)
        {
            return arrTextField.count;
        }
    }else if(tableView ==tbltxtCertificates)
    {
        if (section == 0)
        {
            return 1;
        }
        else if(section == 1)
        {
            return arrTxtCertificateField.count;
        }
    }
    return arrSheet.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblTimeTable) {
        if (!is_iPad()) {
            return 606;
        }
        return 845;
    }
    if (tableView == tblPreview) {
        UIFont *font = [UIFont fontWithName:@"PROXIMANOVA-REGULAR" size:(is_iPad())?17:15];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Course is unpublished and saved as a draft. Print out course schedule to confirm that you are happy with what you have entered. Then confirm you have printed and checked the course details. Once you have confirmed then only these details will be published online at website and app. You can go to the course page or go to the course edit page All your published and unpublished courses are available on this page" attributes:attrsDictionary];
       
        CGRect rect = [attributedString boundingRectWithSize:CGSizeMake( _screenSize.width - 50, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        
        return (rect.size.height + (is_iPad())) ? 330:195;
    }
    if (is_iPad()) {
        return 70;
    }else{return 40;}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblPreview) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPreview" forIndexPath:indexPath];
        UITextView *txtClick = [cell viewWithTag:777];
        
        UIFont *font = [UIFont fontWithName:@"PROXIMANOVA-REGULAR" size:(is_iPad())?17:15];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];

        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Course is unpublished and saved as a draft. Print out course schedule to confirm that you are happy with what you have entered. Then confirm you have printed and checked the course details. Once you have confirmed then only these details will be published online at website and app. You can go to the course page or go to the course edit page All your published and unpublished courses are available on this page" attributes:attrsDictionary];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:@"username://marcelofabri_"
                                 range:[[attributedString string] rangeOfString:@"on this page"]];
        
        [attributedString addAttribute:NSLinkAttributeName
                                 value:@"editcourse://marcelofabri_"
                                 range:[[attributedString string] rangeOfString:@"go to the course edit "]];
        [attributedString addAttribute:NSLinkAttributeName
                                 value:@"page://marcelofabri_"
                                 range:[[attributedString string] rangeOfString:@"go to the course page"]];
        
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                         NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        
        
        
        // assume that textView is a UITextView previously created (either by code or Interface Builder)
        txtShortDesc.linkTextAttributes = linkAttributes; // customizes the appearance of links
        txtClick.attributedText = attributedString;
        txtClick.delegate = self;
        return cell;
        
    }
    if (tableView == tbltxtYoutube)
    {
        if (indexPath.section == 0)
        {
            YoutubeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCellYoutube" forIndexPath:indexPath];
            [cell.btnYoutube addTarget:self action:@selector(btnAddYoutubeTextField:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnYoutube.tag = indexPath.row;
            cell.tfYoutube.text = strYoutube1;
            cell.tfYoutube.tag = 100;
            //[cell setDelegate:self];
            if (indexPath.row != 0 ) {
                [cell.btnYoutube setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            }
            cell.backgroundColor = [UIColor clearColor];
            return cell;
            
        }else{
            YoutubeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellYoutube" forIndexPath:indexPath];
            [cell.btnYoutube addTarget:self action:@selector(btnRemoveoutubeField:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnYoutube.tag = indexPath.row+1;
            cell.tfYoutube.tag = (indexPath.row+1)+100;
            
            switch (indexPath.row+1)
            {
                case 1:
                    cell.tfYoutube.text = arrTextField[0];
                    break;
                case 2:
                    cell.tfYoutube.text = arrTextField[1];
                    break;
                case 3:
                    cell.tfYoutube.text = arrTextField[2];
                    break;
                case 4:
                    cell.tfYoutube.text = arrTextField[3];
                    break;
                default:
                    break;
            }
            
            if (indexPath.row != 0 ) {
                [cell.btnYoutube setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            }
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }
    }else if(tblTimeTable == tableView) {
        BatchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cellsheet" forIndexPath:indexPath];
        UITextField *tfCourseDate = [cell viewWithTag:501];
        UITextField *tfCourseDateEnd = [cell viewWithTag:502];
        UITextField *tfCoursePrice = [cell viewWithTag:503];
        UITextField *tfCourseDiscount = [cell viewWithTag:504];
        UITextField *tfCourseSession = [cell viewWithTag:505];
        UITextField *tfCourseBatchSize = [cell viewWithTag:506];
        UIButton *btnRemove = [cell viewWithTag:560];
        [btnRemove addTarget:self action:@selector(btnRemoveTabs:) forControlEvents:UIControlEventTouchUpInside];
        tfCourseDate.text = courseFrom.coursestartDate;
        tfCourseDateEnd.text = courseFrom.courseEndDate;
        tfCoursePrice.text = courseFrom.coursePrice;
        tfCourseDiscount.text = courseFrom.courseDiscount;
        tfCourseSession.text = courseFrom.courseSession;
        tfCourseBatchSize.text = courseFrom.courseBatchSize;
        [cell layoutIfNeeded];
        if (indexPath.row == 0) {
            btnRemove.hidden = true;
        }else{
            btnRemove.hidden = false;
        }
        cell.controller = self;
        cell.dataSet = courseFrom;
        [cell setData:courseFrom];
        if (indexPath.row == selectedBatch) {
            cell.hidden = false;
            
        }else{
            cell.hidden = true;
        }
        cell.backgroundColor = selectedColor;
        return cell;
    }else{
        if (indexPath.section == 0) {
            CertificatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCellCertificates" forIndexPath:indexPath];
            [cell.btnCertificates addTarget:self action:@selector(btnAddCertiTextField:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCertificates.tag = indexPath.row;
            
            cell.tfCertificates.text = strCetificate1;
            cell.tfCertificates.tag = 200;
            cell.tfCertificates.delegate = self;
            
            
            if (indexPath.row != 0 ) {
                [cell.btnCertificates setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            }
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }else{
            CertificatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCertificates" forIndexPath:indexPath];
            [cell.btnCertificates addTarget:self action:@selector(btnRemoveCertiTextField:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnCertificates.tag = indexPath.row;
            cell.tfCertificates.tag = (indexPath.row+1)+200;
            
            switch (indexPath.row+1)
            {
                case 1:
                    cell.tfCertificates.text = arrTxtCertificateField[0];
                    break;
                case 2:
                    cell.tfCertificates.text = arrTxtCertificateField[1];
                    break;
                case 3:
                    cell.tfCertificates.text = arrTxtCertificateField[2];
                    break;
                case 4:
                    cell.tfCertificates.text = arrTxtCertificateField[3];
                    break;
                default:
                    break;
            }
            if (indexPath.row != 0 ) {
                [cell.btnCertificates setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
            }
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
    }
}
-(IBAction)btnHideConfirmPop:(UIButton*)sender {
    viewPreview.hidden = true;
}
-(IBAction)btnSelectDate:(UIButton*)sender
{
    DateCalenderPickerVC  *vc =(DateCalenderPickerVC*) [(!is_iPad())?getStoryBoardDeviceBased(StoryboardPop): self.storyboard instantiateViewControllerWithIdentifier: @"DateCalenderPickerVC"];
    vc.delegate = self;
    if (sender.tag == 44) {
        vc.selectTxt = 44;
    }else{
        vc.selectTxt = 45;
    }
    if (is_iPad()) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:sender.frame inView:[tblTimeTable visibleCells][0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }];
        
    }else{
        [self presentViewController:vc animated:true completion:nil];
    }
}
#pragma mark CalenderPicker Delegate
-(void)selectedCalenderDate:(NSString *)date index:(NSInteger)pos
{
    BatchCell *cell =[tblTimeTable visibleCells][0];
    if (pos == 44) {
        courseFrom.coursestartDate = date;
        UITextField *tfCourseDate = [cell viewWithTag:501];
        tfCourseDate.text = date;
    }else{
        courseFrom.courseEndDate = date;
        
        UITextField *tfCourseEndDate = [cell viewWithTag:502];
        tfCourseEndDate.text = date;
        
    }
    [cell setData:courseFrom];
    [BatchTimeTable deleteTimeSlot:courseFrom.courseBatchId];
    [MyCourseOffline insertCourse:courseFrom uid:UUIDString];
}
-(void) btnRemoveTabs:(UIButton*) sender
{
    [self.view endEditing:true];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblTimeTable];
    NSIndexPath *indexPath = [tblTimeTable indexPathForRowAtPoint:buttonPosition];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAppName message:@"Are you sure want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             CourseFrom *course = [arrSheet objectAtIndex:indexPath.row];
                             MyCourseOffline * obj = [MyCourseOffline getobjectbyBatchId:course.courseBatchId];
                             if (obj!= nil) {
                                 [APPDELEGATE.managedObjectContext deleteObject:obj];
                                 [arrSheet removeObjectAtIndex:indexPath.row];
                                 batchcount = batchcount - 1;
                                 selectedBatch = selectedBatch - 1;
                                 [APPDELEGATE saveContext];
                                 [cvBatches reloadData];
                                 [tblTimeTable reloadData];
                                 [tblTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selectedBatch inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:false];
                                 selectedColor =  [UIColor randomColor];
                                 courseFrom = [arrSheet objectAtIndex:selectedBatch];
                             }
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark DatePicker
-(void) configureDatePicker
{
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 200)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.hidden=NO;
    datePicker.date=[NSDate date];
    datePicker.minimumDate =[NSDate date];
    tfOfferStartDate.inputView = datePicker;
    tfOfferEndDate.inputView = datePicker;
}
-(void) configureTimePicker
{
    timePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 200)];
    timePicker.datePickerMode=UIDatePickerModeTime;
    timePicker.hidden=NO;
    
}
- (void)editStarted:(NSString *)field;
{
    NSLog(@"%@",field);
}
#pragma mark - Button method
-(IBAction) btnSetAddress:(UIButton*) sender
{
    [self findAddressFromLocation:[MyLocationManager sharedInstance].CurrentLocation];
    
}

-(void) SelectedDayPlaceHolderColor:(UITextField*)textfield color:(UIColor*) color
{
    [textfield setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

-(void) increseViewSize
{
    if (is_iPad()) {
        scrollHeight = scrollHeight + 70;
    }else{scrollHeight = scrollHeight + 40;}
    mainViewheight.constant = scrollHeight;
    [self viewDidLayoutSubviews];
}
-(void) decreaseViewSize
{
    if (is_iPad()) {
        scrollHeight = scrollHeight - 70;
    }else{    scrollHeight = scrollHeight - 40;}
    
    mainViewheight.constant = scrollHeight;
    [self viewDidLayoutSubviews];
}
-(void) btnAddYoutubeTextField:(UIButton*) sender
{
    if ( arrTextField.count < 4)
    {   // add
        [arrTextField addObject:YoutubeBaseUrl];
        [self increseViewSize];
    }
    [tbltxtYoutube reloadData];
    
    [UIView animateWithDuration:0.25 animations:^{
        NSLog(@"add Youtube %f",tbltxtYoutube.contentSize.height);
        tblHeightConstraints.constant = tbltxtYoutube.contentSize.height;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished)
     {
     }];
}
-(void) btnRemoveoutubeField:(UIButton*) sender
{
    [self.view endEditing:true];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbltxtYoutube];
    NSIndexPath *indexPath = [tbltxtYoutube indexPathForRowAtPoint:buttonPosition];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAppName message:@"Are you sure want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             [arrTextField removeObjectAtIndex:indexPath.row];
                             [tbltxtYoutube reloadData];
                             [UserDefault setValue:arrTextField forKey:CFYoutubeArr];
                             
                             [self decreaseViewSize];
                             [UIView animateWithDuration:0.25 animations:^{
                                 NSLog(@"remove Youtube %f",tbltxtYoutube.contentSize.height);
                                 tblHeightConstraints.constant = tbltxtYoutube.contentSize.height;
                                 [self.view layoutIfNeeded];
                             }completion:^(BOOL finished)
                              {
                              }];
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    [tbltxtYoutube reloadData];
    
    
}
-(void) btnAddCertiTextField:(UIButton*) sender
{
    if (arrTxtCertificateField.count < 4)
    {   // add
        [arrTxtCertificateField addObject:@""];
        [self increseViewSize];
    }    [tbltxtCertificates reloadData];
    
    [UIView animateWithDuration:0.25 animations:^{
        NSLog(@"add Certificate %f",tbltxtCertificates.contentSize.height);
        tblCertificatesHeightConstraints.constant = tbltxtCertificates.contentSize.height;
        [self.view layoutIfNeeded];
    }completion:nil];
}
-(void) btnRemoveCertiTextField:(UIButton*) sender
{
    [self.view endEditing:true];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tbltxtCertificates];
    NSIndexPath *indexPath = [tbltxtCertificates indexPathForRowAtPoint:buttonPosition];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAppName message:@"Are you sure want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             [arrTxtCertificateField removeObjectAtIndex:indexPath.row];
                             [tbltxtCertificates reloadData];
                             [UserDefault setValue:arrTxtCertificateField forKey:CFCertificateArr];
                             
                             [self decreaseViewSize];
                             
                             [UIView animateWithDuration:0.25 animations:^{
                                 NSLog(@"remove Certificate %f",tbltxtCertificates.contentSize.height);
                                 
                                 tblCertificatesHeightConstraints.constant = tbltxtCertificates.contentSize.height;
                                 [self.view layoutIfNeeded];
                             }completion:^(BOOL finished)
                              {
                              }];
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    [tbltxtCertificates reloadData];
    
    
    //    [self.view layoutIfNeeded];
    
    
}
- (RichTextEditorFeature)featuresEnabledForRichTextEditor:(RichTextEditor *)richTextEditor
{
    return RichTextEditorFeatureDone| RichTextEditorFeatureFontSize |
    RichTextEditorFeatureBold |
    RichTextEditorFeatureParagraphIndentation |
    RichTextEditorFeatureItalic |
    RichTextEditorFeatureUnderline |
    RichTextEditorFeatureStrikeThrough |
    RichTextEditorFeatureTextAlignmentLeft |
    RichTextEditorFeatureTextAlignmentCenter |
    RichTextEditorFeatureTextAlignmentRight |
    RichTextEditorFeatureTextAlignmentJustified |
    RichTextEditorFeatureTextBackgroundColor |
    RichTextEditorFeatureTextForegroundColor |
    RichTextEditorFeatureParagraphIndentation |
    RichTextEditorFeatureParagraphFirstLineIndentation;
}
-(void)btnHideTextEditor:(id)sender
{
    [self.view layoutSubviews];
    [txt resignFirstResponder];
    if ([txt.htmlString length] > 0) {
        [UserDefault setValue:txt.htmlString forKey:CFDescription];
    }
}
#pragma mark -
#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 5;
    self.labelSlider.maximumValue = 65;
    
    self.labelSlider.lowerValue = 5;
    self.labelSlider.upperValue = 65;
    
    self.labelSlider.minimumRange = 1;
    self.labelSlider.trackImage = [self imageWithColor:[UIColor colorWithRed:242.0/255.0 green:23.0/255.0 blue:110.0/255.0 alpha:1.0]];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 3.0f, 3.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
    [UserDefault setValue:self.upperLabel.text forKey:CFUpper];
    [UserDefault setValue:self.lowerLabel.text forKey:CFLower];
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}
#pragma mark - Actionsheet
-(IBAction)btnAttachment:(id)sender
{
    if (cellUploadImageArray.count >= 10)
    {
        showAletViewWithMessage(@"You can upload max 10 picture.");
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil  otherButtonTitles:@"Camera",@"Gallery",nil];
    
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == 0) {
        [self openCamera];
    }else if (buttonIndex == 1)
    {
        [self openGallery];
    }
    
}
-(void) openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        isMediaOpen = true;
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
        
    }
    
}
-(void) openGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage,nil];
    isMediaOpen = true;
    if (is_iPad())
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:btnAttachment.bounds inView:btnAttachment permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }];
        
    }else{
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isMediaOpen = false;
    [cellUploadImageArray addObject:info[UIImagePickerControllerEditedImage]];
    NSData *dataVal = [NSKeyedArchiver archivedDataWithRootObject:cellUploadImageArray];
    [UserDefault setObject:dataVal forKey:CFPicArr];
    [UserDefault synchronize];
    
    if (cellUploadImageArray.count > 5)
    {
        [cvPics layoutIfNeeded];
        mainViewheight.constant = scrollHeight - (cvPics.frame.size.width*2)/5;
        collectionHeight.constant = (cvPics.frame.size.width/5)*2;
        scrollHeight = scrollHeight + cvPics.frame.size.width/5;
        mainViewheight.constant = scrollHeight;
    }else{
        collectionHeight.constant = cvPics.frame.size.width/5;
        scrollHeight = scrollHeight + cvPics.frame.size.width/5;
        mainViewheight.constant = scrollHeight;
        
    }
    [cvPics reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    isMediaOpen = false;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == cvPics) {
        return cellUploadImageArray.count;
    }
    
    return batchcount;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == cvPics) {
        return CGSizeMake(collectionView.frame.size.width/5, collectionView.frame.size.width/5);
    }
    return CGSizeMake(40, collectionView.frame.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == cvBatches) {
        
        CollectionBatchesCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        if (selectedBatch == indexPath.row) {
            cell.heightView.constant = 50;
            cell.containerView.backgroundColor = selectedColor;
            
        }else{
            cell.heightView.constant = 40;
            cell.containerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        }
        if (batchcount-1 == indexPath.row) {
            cell.lblTittle.text = @"";
            cell.imgPlus.hidden = false;
        }else{
            cell.lblTittle.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
            cell.imgPlus.hidden = true;
        }
        
        return cell;
        
    } else {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellImg" forIndexPath:indexPath];
        UIImageView *img = [cell viewWithTag:11];
        UIButton *btnDelete = [cell viewWithTag:5];
        [btnDelete addTarget:self action:@selector(btnDeletePics:) forControlEvents:UIControlEventTouchUpInside];
        
        id obj = cellUploadImageArray[indexPath.row];
        if ([obj isKindOfClass:[UIImage class]]) {
            img.image = cellUploadImageArray[indexPath.row];
        }else
        {
            [img sd_setImageWithURL:[NSURL URLWithString:obj]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
        }
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView != cvPics)
    {
        if (batchcount - 1 == indexPath.row)
        {
            if (batchcount == 25) {
                showAletViewWithMessage(@"You can add max 25 batches.");
                return;
            }
            NSArray *arr = [BatchTimeTable getobjectbyBatchID:courseFrom.courseBatchId];
            if (arr.count == 0) {
                showAletViewWithMessage([NSString stringWithFormat:@"Please enter valid time for current batch"]);
                return;
            }
            
            batchcount = batchcount + 1;
            selectedBatch = batchcount - 2;
            CourseFrom * course =  [arrSheet lastObject];
            CourseFrom *newFrom = [[CourseFrom alloc]init];
            
            newFrom.courseBatchId = GetTimeStampString;
            newFrom.coursestartDate = course.coursestartDate;
            newFrom.courseEndDate = course.courseEndDate;
            newFrom.coursePrice = course.coursePrice;
            newFrom.courseDiscount = course.courseDiscount;
            newFrom.courseSession = course.courseSession;
            newFrom.courseBatchSize = course.courseBatchSize;
            
            [arrSheet addObject:newFrom];
            BOOL success = [MyCourseOffline insertCourse:newFrom uid:UUIDString];
            if (success) {
                CourseFrom *temp = [arrSheet firstObject];
                BOOL stored = [BatchTimeTable copyBatchTimeToNew:temp.courseBatchId toBatch:newFrom.courseBatchId];
                NSLog(@"%hhd",stored);
            }
            [tblTimeTable reloadData];
            [tblTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selectedBatch  inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:false];
            
        }else{
            selectedBatch = indexPath.row;
            [tblTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selectedBatch inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:false];
            
        }
        selectedColor =  [UIColor randomColor];
        courseFrom = [arrSheet objectAtIndex:selectedBatch];
        [cvBatches reloadData];
        [tblTimeTable reloadData];
    }
}


-(void) btnDeletePics:(UIButton*) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:cvPics];
    NSIndexPath *indexPath = [cvPics indexPathForItemAtPoint:buttonPosition];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAppName message:@"Are you sure want to delete photo?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             [cellUploadImageArray removeObjectAtIndex:indexPath.row];
                             NSData *dataVal = [NSKeyedArchiver archivedDataWithRootObject:cellUploadImageArray];
                             [UserDefault setObject:dataVal forKey:CFPicArr];
                             [UserDefault synchronize];
                             [cvPics reloadData];
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void) saveInPreferenceTempData:(UITextField*) textField
{
    NSString *value = textField.text.tringString;
    if (textField == tfTittle) {
        [UserDefault setValue:value forKey:CFTittle];
    }
    if (textField == tfaddress1) {
        [UserDefault setValue:value forKey:CFAdd1];
    }
    if (textField == tfaddress2) {
        [UserDefault setValue:value forKey:CFAdd2];
    }
    if (textField == tfcity) {
        [UserDefault setValue:value forKey:CFCity];
    }
    if (textField == tfPincode) {
        [UserDefault setValue:value forKey:CFPostalCode];
    }
    if (textField == tfquantity) {
        [UserDefault setValue:value forKey:CFQuality];
    }
    if (textField == tfsold) {
        [UserDefault setValue:value forKey:CFSold];
    }
    if (textField == tfOfferStartDate) {
        [UserDefault setValue:value forKey:CFOfferValidFrom];
    }
    if (textField == tfOfferEndDate) {
        [UserDefault setValue:value forKey:CFOfferValidUntil];
    }
    if (textField == tfTutorName) {
        [UserDefault setValue:value forKey:CFTutor];
    }
    
}
-(void) removePreferenceData{
    [UserDefault removeObjectForKey:CFID];
    [UserDefault removeObjectForKey:CFTittle];
    [UserDefault removeObjectForKey:CFAdd1];
    [UserDefault removeObjectForKey:CFAdd2];
    [UserDefault removeObjectForKey:CFCity];
    [UserDefault removeObjectForKey:CFPostalCode];
    [UserDefault removeObjectForKey:CFPrice];
    [UserDefault removeObjectForKey:CFDiscount];
    [UserDefault removeObjectForKey:CFQuality];
    [UserDefault removeObjectForKey:CFSold];
    [UserDefault removeObjectForKey:CFOfferValidFrom];
    [UserDefault removeObjectForKey:CFOfferValidUntil];
    [UserDefault removeObjectForKey:CFStart];
    [UserDefault removeObjectForKey:CFEnd];
    [UserDefault removeObjectForKey:CFTutor];
    [UserDefault removeObjectForKey:CFBatchSize];
    [UserDefault removeObjectForKey:CFCourseReq];
    [UserDefault removeObjectForKey:CFSortDesc];
    [UserDefault removeObjectForKey:CFCategory];
    [UserDefault removeObjectForKey:CFCategoryID];
    [UserDefault removeObjectForKey:CFSubcategoryCategory];
    [UserDefault removeObjectForKey:CFSubcategoryCategoryID];
    [UserDefault removeObjectForKey:CFYoutube];
    [UserDefault removeObjectForKey:CFYoutubeArr];
    [UserDefault removeObjectForKey:CFCertificate];
    [UserDefault removeObjectForKey:CFCertificateArr];
    [UserDefault removeObjectForKey:CFDescription];
    [UserDefault removeObjectForKey:CFLower];
    [UserDefault removeObjectForKey:CFUpper];
    [UserDefault removeObjectForKey:CFPicArr];
    [UserDefault synchronize];
}

-(void) setPreferenceValue
{
    selectedBatch = 0;
    batchcount = 1;
    selectedColor =  [UIColor randomColor];
    UUIDString = [self removeNull:[UserDefault valueForKey:CFID]];
    if ([self checkStringValue:UUIDString]) {
        UUIDString = [[NSUUID UUID] UUIDString];
        [UserDefault setValue:UUIDString forKey:CFID];
        
        if (courseFrom == nil) {
            courseFrom = [[CourseFrom alloc]init];
            courseFrom.courseBatchId = GetTimeStampString;
        }
        
        [MyCourseOffline insertCourse:courseFrom uid:UUIDString];
        
        [arrSheet addObject:courseFrom];
        batchcount = 2;
        [tblTimeTable reloadData];
        [cvBatches reloadData];
    }else{
        
        NSArray * arrTabs = [MyCourseOffline getobjectbyId:UUIDString];
        if (arrTabs.count > 0) {
            for (MyCourseOffline *obj in arrTabs) {
                CourseFrom * course = [[CourseFrom alloc]init];
                course.courseBatchId = obj.mBatchId;
                course.coursestartDate = obj.mStartDate;
                course.courseEndDate = obj.mEndDate;
                course.coursePrice = obj.mPrice;
                course.courseDiscount = obj.mDiscount;
                course.courseSession = obj.mSession;
                course.courseBatchSize = obj.mBatchSize;
                
                [arrSheet addObject:course];
                batchcount = batchcount + 1;
            }
            courseFrom = [arrSheet firstObject];
        }
        [cvBatches reloadData];
        [tblTimeTable reloadData];
    }
    
    
    tfTittle.text = [self removeNull:[UserDefault valueForKey:CFTittle]];
    tfaddress1.text = [self removeNull:[UserDefault valueForKey:CFAdd1]] ;
    tfaddress2.text = [self removeNull:[UserDefault valueForKey:CFAdd2]];
    tfcity.text = [self removeNull:[UserDefault valueForKey:CFCity]];
    tfPincode.text = [self removeNull:[UserDefault valueForKey:CFPostalCode]];
    
    tfquantity.text = [self removeNull:[UserDefault valueForKey:CFQuality]];
    tfsold.text = [self removeNull:[UserDefault valueForKey:CFSold]];
    tfOfferStartDate.text = [self removeNull:[UserDefault valueForKey:CFOfferValidFrom]];
    tfOfferEndDate.text = [self removeNull:[UserDefault valueForKey:CFOfferValidUntil]];
    tfTutorName.text = [self removeNull:[UserDefault valueForKey:CFTutor]];
    NSString *strReq = [self removeNull:[UserDefault valueForKey:CFCourseReq]];
    if ([strReq length] > 0) {
        lblRequirment.hidden = true;
    }
    txtRequirement.text = strReq;
    
    NSString *strShortDes = [self removeNull:[UserDefault valueForKey:CFSortDesc]];
    if ([strShortDes length] > 0) {
        lblShortDesc.hidden = true;
    }
    txtShortDesc.text = strShortDes;
    tfCategory.text = [self removeNull:[UserDefault valueForKey:CFCategory]];
    catID = [self removeNull:[UserDefault valueForKey:CFCategoryID]];
    tfSubCategory.text = [self removeNull:[UserDefault valueForKey:CFSubcategoryCategory]];
    subcatID = [self removeNull:[UserDefault valueForKey:CFSubcategoryCategoryID]];
    
    strYoutube1 = [self removeNull:[UserDefault valueForKey:CFYoutube]];
    arrTextField = [UserDefault valueForKey:CFYoutubeArr];
    arrTextField = arrTextField.mutableCopy;
    if (arrTextField == nil) {
        arrTextField = [[NSMutableArray alloc]init];
    }else if(arrTextField.count > 0)
    {
        for (id t in arrTextField) {
            [self increseViewSize];
        }
        [tbltxtYoutube reloadData];
        tblHeightConstraints.constant = tbltxtYoutube.contentSize.height;
    }
    
    strCetificate1 = [self removeNull:[UserDefault valueForKey:CFCertificate]];
    arrTxtCertificateField = [UserDefault valueForKey:CFCertificateArr];
    arrTxtCertificateField = arrTxtCertificateField.mutableCopy;
    if (arrTxtCertificateField == nil) {
        arrTxtCertificateField = [[NSMutableArray alloc]init];
    }else if(arrTxtCertificateField.count > 0)
    {
        for (id t in arrTxtCertificateField) {
            [self increseViewSize];
        }
        [tbltxtCertificates reloadData];
        tblCertificatesHeightConstraints.constant = tbltxtCertificates.contentSize.height;
        
    }
    [tbltxtYoutube reloadData];
    [tbltxtCertificates reloadData];
    
    NSArray* courseImageArr = [NSKeyedUnarchiver unarchiveObjectWithData:[UserDefault valueForKey:CFPicArr]];
    
    if (courseImageArr != nil) {
        [cellUploadImageArray addObjectsFromArray:courseImageArr];
    }
    [cvPics reloadData];
    if (cellUploadImageArray.count == 0) {
        collectionHeight.constant = 0;
    }else{
        if (cellUploadImageArray.count > 5) {
            collectionHeight.constant = (cvPics.frame.size.width/5)*2;
        }else{
            collectionHeight.constant = cvPics.frame.size.width/5;
        }
    }
    
    NSString *html = [self removeNull:[UserDefault valueForKey:CFDescription]];
    if (![self checkStringValue:html])
    {
        [self setHtmlStringDescription:html];
    }
    
    NSString *upper = [self removeNull:[UserDefault valueForKey:CFUpper]];
    if (![self checkStringValue:upper]) {
        self.labelSlider.upperValue = [upper floatValue];
    }
    
    NSString *lower = [self removeNull:[UserDefault valueForKey:CFLower]];
    if (![self checkStringValue:lower]) {
        self.labelSlider.lowerValue = [lower floatValue];
    }
    [self updateSliderLabels];
    
}
-(NSString*) removeNull:(NSString *) str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (str == nil) {
        return @"";
    }
    return str;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 778) {
        signature = textField.text;
    }
    [textField resignFirstResponder];
    NSDateFormatter *outputFormatter1 = [[NSDateFormatter alloc] init];
    [outputFormatter1 setDateFormat:@"dd-MMM-yyyy"];
    NSString *dateString1 = [outputFormatter1 stringFromDate:datePicker.date];
    
    
    if (textField == tfOfferStartDate)
    {
        tfOfferStartDate.text = dateString1;
    }else if (textField == tfOfferEndDate)
    {
        tfOfferEndDate.text = dateString1;
    }else if (textField.tag == 503){
        courseFrom.coursePrice = textField.text;
        [tblTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selectedBatch inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
        [MyCourseOffline insertCourse:courseFrom uid:UUIDString];
    }else if (textField.tag == 504){
        courseFrom.courseDiscount = textField.text;
        [tblTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selectedBatch inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
        [MyCourseOffline insertCourse:courseFrom uid:UUIDString];
        
    }else if (textField.tag == 505){
        courseFrom.courseSession = textField.text;
        [tblTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selectedBatch inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
        [MyCourseOffline insertCourse:courseFrom uid:UUIDString];
    }else if (textField.tag == 506){
        courseFrom.courseBatchSize = textField.text;
        [tblTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:selectedBatch inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
        [MyCourseOffline insertCourse:courseFrom uid:UUIDString];
    }
    if (textField.tag == 100)
    {
        strYoutube1 = textField.text;
        [UserDefault setValue:strYoutube1 forKey:CFYoutube];
    }else if (textField.tag == 101)
    {
        if (arrTextField.count > 0)
        {
            [arrTextField replaceObjectAtIndex:0 withObject:textField.text];
        }else{
            [arrTextField addObject:textField.text];
        }
        
    }else if (textField.tag == 102)
    {
        if (arrTextField.count > 1)
        {
            [arrTextField replaceObjectAtIndex:1 withObject:textField.text];
        }else{
            [arrTextField addObject:textField.text];
        }
        
    }else if (textField.tag == 103)
    {
        if (arrTextField.count > 2)
        {
            [arrTextField replaceObjectAtIndex:2 withObject:textField.text];
        }else{
            [arrTextField addObject:textField.text];
        }
        
    }else if (textField.tag == 104)
    {
        if (arrTextField.count > 3)
        {
            [arrTextField replaceObjectAtIndex:3 withObject:textField.text];
        }else{
            [arrTextField addObject:textField.text];
        }
        
    }else if (textField.tag == 200)
    {
        strCetificate1 = textField.text;
        [UserDefault setValue:strCetificate1 forKey:CFCertificate];
        
        
    }else if (textField.tag == 201)
    {
        [arrTxtCertificateField replaceObjectAtIndex:0 withObject:textField.text];
    }else if (textField.tag == 202)
    {
        [arrTxtCertificateField replaceObjectAtIndex:1 withObject:textField.text];
    }else if (textField.tag == 203)
    {
        [arrTxtCertificateField replaceObjectAtIndex:2 withObject:textField.text];
    }else if (textField.tag == 204)
    {
        [arrTxtCertificateField replaceObjectAtIndex:3 withObject:textField.text];
    }
    [UserDefault setValue:arrTextField forKey:CFYoutubeArr];
    [UserDefault setValue:arrTxtCertificateField forKey:CFCertificateArr];
    [self saveInPreferenceTempData:textField];
    [self validationFrom:textField];
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if ((textField == tfquantity || textField == tfsold || textField.tag == 505 ||textField.tag == 506) && newLength > 2) {
        return NO;
    }else if ( textField.tag == 503 && newLength > 7) {
        return NO;
    }else if ( textField.tag == 504 && newLength > 7) {
        return NO;
    }
    // Prevent invalid character input, if keyboard is numberpad
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            return NO;
        }
    }
    return YES;
}
-(void) setNewheightForTextDescription
{
    scrollHeight = scrollHeight + (temptxtDescHeight - txtDescHeight);
    mainViewheight.constant = scrollHeight;
    [self viewDidLayoutSubviews];
}
#pragma mark TextView Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == txt)
    {
        if ([txt contentSize].height > 150)
        {
            txtHeight.constant =  [txt contentSize].height;
            temptxtDescHeight = [txt contentSize].height;
            [self setNewheightForTextDescription];
            txtDescHeight = temptxtDescHeight;
            [self.view layoutIfNeeded];
        }
    }
    return true;
}
-(void) textViewDidEndEditing:(UITextView *)textView
{
    if (textView == txtRequirement ) {
        [UserDefault setValue:textView.text forKey:CFCourseReq];
    }
    if (textView == txtShortDesc ) {
        [UserDefault setValue:textView.text forKey:CFSortDesc];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == txt) {
        lblCaptionDesc.hidden =true;
    }
    if (textView.tag == 11) {
        lblRequirment.hidden = true;
    }
    if (textView.tag == 12) {
        lblShortDesc.hidden = true;
    }
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self validationFrom:textView];
    if (textView == txt && txt.text.length == 0)
    {
        lblCaptionDesc.hidden = false;
    }
    if (textView.tag == 11 && txtRequirement.text.length == 0) {
        lblRequirment.hidden = false;
    }
    if (textView.tag == 12 && txtShortDesc.text.length == 0) {
        lblShortDesc.hidden = false;
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {

    UIStoryboard *mainStoryboard = getStoryBoardDeviceBased(StoryboardMain);
    if ([[URL scheme] isEqualToString:@"username"]) {
        UIViewController  *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MyCoursesViewController"];
        [self.navigationController pushViewController:vc animated:true];
    }else if ([[URL scheme] isEqualToString:@"editcourse"]){
        viewPreview.hidden = true;
        if(![self checkStringValue:self.nid])
        {
            [self performSelector:@selector(getCourseDetailToEdit) withObject:self afterDelay:0.5];
            tempImg = [[UIImage alloc]init];
            self.title = @"Edit a Course";
        }
        
    }else if ([[URL scheme] isEqualToString:@"page"]) {
        UIViewController  *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CoursesListViewController"];
        [self.navigationController pushViewController:vc animated:true];
   
    }
    return NO;
    
}
#pragma mark ----
/*
 #pragma mark - Navigation
 v // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)findAddressFromLocation:(CLLocation*)location
{
    if (location == nil) {
        showAletViewWithMessage(@"Failed to get your current location using GPS");
        return;
    }
    CLGeocoder *geoCoder;
    if (!geoCoder) {
        geoCoder = [[CLGeocoder alloc]init];
    }
    [self startActivity];
    __weak CreateCourseiPadViewController *weakSelf = self;
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"geoCoder %@",[error debugDescription]);
         [self stopActivity];
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
             if (![weakSelf checkStringValue:[placemarks[0] postalCode]]) {
                 tfPincode.text = [placemarks[0] postalCode];
                 [UserDefault setValue:tfPincode.text forKey:CFPostalCode];
             }
             
             if (![weakSelf checkStringValue:[placemarks[0] locality]]) {
                 tfcity.text = [placemarks[0] locality];
                 [UserDefault setValue:tfcity.text forKey:CFCity];
             }
             if (![weakSelf checkStringValue:[placemarks[0] thoroughfare]]) {
                 tfaddress1.text = [placemarks[0] thoroughfare];
                 [UserDefault setValue:tfaddress1.text forKey:CFAdd1];
             }
             if (![weakSelf checkStringValue:[placemarks[0] subThoroughfare]]) {
                 tfaddress2.text = [placemarks[0] subThoroughfare];
                 [UserDefault setValue:tfaddress2.text forKey:CFAdd2];
             }
             
         }
         
     }];
    
}


#pragma mark - Upload Manager Delegate
- (void)updateProgress:(NSNumber *)completed total:(NSNumber *)totalUpload{
    hud.progress = ([completed intValue] * 100/[totalUpload intValue])/100.0f;
    hud.labelText = [NSString stringWithFormat:@"Uploading %d of %d",(int)[completed intValue]+1,(int)[totalUpload intValue]];
}
- (void)uploadCompleted:(NSArray *)arrayFids{
    hud.labelText = @"Upload completed.";
    [self performSelector:@selector(uploadOfflineCourseToServer:) withObject:arrayFids afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}
- (void)uploadFailed
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading failed, Please try again.";
    showAletViewWithMessage(@"Your course saved and will be submitted as soon internet available");
    [self clearData];
    [hud hide:YES afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}


#pragma mark - Offline course re-Send
-(IBAction)btnPublishAction:(UIButton*)sender{
    [self.view endEditing:true];
    if (sender.tag == 21) {
        if (![self checkStringValue:signature]) {
            [self publishCourse:@{@"nid":self.nid,@"publish":@"1",@"initials":signature}];
        }else{
            showAletViewWithMessage(@"Please enter intials.");
        }
    }else{
        [self publishCourse:@{@"nid":self.nid,@"publish":@"0",@"initials":@""}];
    }
    
    
}
-(void) publishCourse:(NSDictionary*)dict {

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait..";
    [[NetworkManager sharedInstance] postRequestFullUrl:apiPublish paramter:dict withCallback:^(id jsonData, WebServiceResult result)
     {
         [hud hide:true];
         if (result == WebServiceResultSuccess)
         {
             [self.navigationController popViewControllerAnimated:true];
          
         } else {
             showAletViewWithMessage(@"Error occurs while course publish You can edit from my course screen.");
         }
     }];
}
-(void) postCourse:(NSDictionary *)dict
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    NSLog(@"XXXX:%@", convertObjectToJson(dict));
    [[NetworkManager sharedInstance] postRequestFullUrl:apiPostCourse paramter:dict withCallback:^(id jsonData, WebServiceResult result)
     {
         if (result == WebServiceResultSuccess)
         {
             // remove object in db as well from var & calls sync again for new object.
             NSManagedObject *courseObject = [arrOffline firstObject];
             [self deleteEntityFromDatabase:courseObject.objectID];
             [arrOffline removeObjectAtIndex:0];
             if (arrOffline.count>0)
             {
                 [self syscOfflineCourse];
             }else
             {
                 [hud hide:true];
                 NSString *str = [NSString stringWithFormat:@"%@",jsonData[@"nid"]];
                 [self clearAllField:str];
             }
         }
         else
         {
             [hud hide:true];
             showAletViewWithMessage(@"Error occurs while course posting.Your course saved and will be submitted as soon internet available");
             [self clearData];
         }
     }];
    
}
-(void) editCourse:(NSDictionary*)dict
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    NSLog(@"EEEXXXX:%@", convertObjectToJson(dict));
    
    [[NetworkManager sharedInstance] postRequestFullUrl:apiUpdateCourse paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        
        if (result == WebServiceResultSuccess)
        {
            NSManagedObject *obj = [arrOffline firstObject];
            [self deleteEntityFromDatabase:obj.objectID];
            [arrOffline removeObjectAtIndex:0];
            if (arrOffline.count>0)
            {
                [self syscOfflineCourse];
            }else
            {
                [hud hide:true];
                NSString * str = [NSString stringWithFormat:@"%@",jsonData[@"nid"]];
                [self clearAllField:str];
            }
        }
        else
        {
            [hud hide:true];
            [self stopActivity];
            showAletViewWithMessage(@"Error occurs while course edting.Your course saved and will be submitted as soon internet available");
            [self clearData];
        }
    }];
}
-(void)deleteEntityFromDatabase:(NSManagedObjectID *) ID
{
    NSArray* course = [self getUnsubmittedDetailsFromDatabase];
    for (NSManagedObject* courseObject in course)
    {
        if ([courseObject.objectID isEqual:ID])
        {
            [APPDELEGATE.managedObjectContext deleteObject:courseObject];
            [APPDELEGATE saveContext];
            break;
        }
    }
}
-(void) clearData
{
    [cellUploadImageArray removeAllObjects];
    tfCategory.text =  @"";
    catID = @"";
    tfSubCategory.text = @"";
    subcatID = @"";
    tfTittle.text = @"";
    tfTutorName.text = @"";
    
    tfsold.text = @"";
    tfquantity.text = @"";
    tfPincode.text = @"";
    tfOfferStartDate.text = @"";
    tfOfferEndDate.text = @"";
    tfcity.text = @"";
    tfaddress2.text = @"";
    tfaddress1.text = @"";
    [cvPics reloadData];
    txt.text = @"";
    txtRequirement.text = @"";
    txtShortDesc.text = @"";
    [arrTextField removeAllObjects];
    [arrTxtCertificateField removeAllObjects];
    [tbltxtCertificates reloadData];
    [tbltxtYoutube reloadData];
    
}
-(void) clearAllField:(NSString*) nid
{
    [tblPreview reloadData];
    viewPreview.hidden = false;
    self.nid = nid;
    newNID = nid;
}



@end



