//
//  ReadyToPublishCourseVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 02/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ReadyToPublishCourseVC.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ReadyToPublishCourseVC ()<UploadManagerDelegate>{
    MBProgressHUD *hud;
    IBOutlet UIView *viewTxt;
    IBOutlet UITextField *tfSignature;
    IBOutlet UIButton *btnEmail;
}

@end

@implementation ReadyToPublishCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    viewTxt.layer.borderColor = __THEME_lightGreen.CGColor;
    viewTxt.layer.borderWidth = 1;
    lblNotes.text = @"Can you review course details and confirm that you are happy with what you have entered?/nOnce you have confirmed these details will be published online at website and app.";

    if ([APPDELEGATE.userCurrent.uid isEqualToString:@"396"]) {
        btnEmail.hidden = false;
    }else{
        btnEmail.hidden = true;
    }
        
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Publish course Screen"];
}

-(BOOL) batchValidation{
    for(Batches *objBatches in dataClass.arrCourseBatches) {
        
        NSDate *startDate = [globalDateOnlyFormatter() dateFromString:objBatches.startDate];
        NSDate *endDate = [globalDateOnlyFormatter() dateFromString:objBatches.endDate];
        if (startDate == nil || endDate == nil) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add batch data for class %lu",(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
            return false;
            break;
        }
        
        if (_isStringEmpty(objBatches.price)) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add batch price for class %lu",(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
            return false;
            break;
        }
        
        if (_isStringEmpty(objBatches.sessions)) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add batch sessions for class %lu",(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
            return false;
            break;
        }
        
        
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
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sDate >= %@) AND (sDate <= %@)", firstDateOfMonth, lastDateOfMonth];
            
            NSArray * temp = [objBatches.batchesTimes filteredArrayUsingPredicate:predicate];
            NSLog(@"%lu",(unsigned long)temp.count);
            if (temp.count == 0) {
                showAletViewWithMessage([NSString stringWithFormat:@"Please add atleast one batch for month %@ of class %lu Please enter between start & end date",[frmMONTHFormatter() stringFromDate:firstDateOfMonth],(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
                return false;
                break;
            }
        }
    }
    return true;
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
- (NSDate *)returnDateForMonth:(NSInteger)month year:(NSInteger)year day:(NSInteger)day {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return [CURRENT_CALENDAR dateFromComponents:components];
}
-(void) sendEmail:(NSMutableDictionary*)json{
    // From within your active view controller
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        [mailCont setSubject:@"Any title"];
        [mailCont setMessageBody:convertObjectToJson(json) isHTML:YES];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    // Then implement the delegate method
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)btnEmail:(id)sender{
    if ([self checkStringValue:dataClass.crsNid]) {
        [self sendEmail:[self getCourseDictionaryToSubmit:false]];
    }else{
        [self sendEmail:[self getCourseDictionaryToSubmit:true]];
    }
}
#pragma mark - UIButton
- (IBAction) btnPublish:(UIButton*) sender{
    if ([self checkStringValue:tfSignature.text]) {
        showAletViewWithMessage(@"Enter your Initials ");
        return;
    }
    if (![self batchValidation]) {
        return;
    }
    if (![self validation]) {
        showAletViewWithMessage(@"Hold that horse. You’ll need to complete steps 1-8 successfully to submit a course online.");
        return;
    }
    
    int i = 0;
    for(NSString *str in dataClass.crsYoutubeURL) {
        if (![[str lowercaseString] containsString:@"youtube.com"]) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add valid (%d) youtube video url ex: youtube.com/",i + 1]);
            break;
        }
        i += 1;
    }
    
    
    [hud hide:true];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = [NSString stringWithFormat:@"Uploading 1 of %d",(int)dataClass.crsImages.count];
    [UploadManager sharedInstance].delegate = self;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (id data in dataClass.crsImages) {
        if ([data isKindOfClass:[UIImage class]]) {
            [arr addObject:data];
        }else if ([data isKindOfClass:[NSData class]]) {
            [arr addObject:[UIImage imageWithData:data]];
        }else if([data isKindOfClass:[NSString class]]) {
            NSString *imgString = [[DocumentAccess obj] mediaForNameString:data];
            if (imgString) {
                [arr addObject:[UIImage imageWithContentsOfFile:imgString]];
            }
        }
    }
    if (arr.count>0) {
        [[UploadManager sharedInstance] uploadImagesWithArray:arr];
    }else{
        showAletViewWithMessage(@"A technical error has occurred while posting a course online. Don’t worry and your course isAlert, Alert. Space aliens shot us with technical errors while posting a course online. Don’t worry and your course is saved locally. It will be submitted as soon as internet becomes available.");
    }
}

#pragma mark - Get Dictionay Method
-(NSMutableDictionary *) getCourseDictionaryToSubmit:(BOOL) isForEdit{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (isForEdit) {
        [dict setValue:dataClass.crsNid forKey:@"nid"];
    }
    //    [dict setValue:@"9016596372" forKey:@"mobile"];
    [dict setValue:dataClass.crsTitle forKey:@"title"];
    [dict setValue:@[dataClass.crsCategoryTbl.categoryId,dataClass.crsSubCategoryTbl.subCategoryId] forKey:@"category"];
//    [dict setValue:[globalDateOnlyFormatter() stringFromDate:[NSDate date]] forKey:@"offer_valid_from"];
//    [dict setValue:@"02-Nov-2016"  forKey:@"offer_valid_untill"];
    [dict setValue:(dataClass.isMoneyBack)?@"1":@"0" forKey:@"money_back_guarantee"];
    [dict setValue:(dataClass.crsRequirements == nil) ? @"No requirements" : dataClass.crsRequirements forKey:@"course_requirements"];
    NSMutableArray *arrV = [NSMutableArray new];
    for (NSString *strV in dataClass.crsYoutubeURL) {
        if (!_isStringEmpty(strV)) {
            [arrV addObject:strV];
        }
    }
    [dict setValue:arrV forKey:@"youtube"];
    [dict setValue:dataClass.crsSummary forKey:@"description"];
    [dict setValue:dataClass.crsShortDesc forKey:@"short_description"];
    NSMutableArray *arrCertificate = [NSMutableArray new];
    for (NSString *str in dataClass.crsCertificate) {
        if (!_isStringEmpty(str)) {
            [arrCertificate addObject:str];
        }
    }
    [dict setValue:arrCertificate forKey:@"certification"];
    
    [dict setValue:dataClass.crsAmenities forKey:@"amenities"];
    [dict setValue:dataClass.crsCancellation forKey:@"cancellation"];
    [dict setValue:@"Both" forKey:@"suitable_for"];
    
    NSMutableDictionary *addDict = [NSMutableDictionary new];
    [addDict setValue:dataClass.crsPincode forKey:@"postal_code"];
    [addDict setValue:dataClass.crsAddress forKey:@"venue"];
    [addDict setValue:dataClass.crsAddress1 forKey:@"street"];
    [addDict setValue:dataClass.crsCity forKey:@"city"];
    [addDict setValue:@"gb" forKey:@"country"];
    
    [dict setValue:[NSNumber numberWithInteger:dataClass.crsAgeGroupIndex] forKey:@"age"];

    [dict setValue:addDict forKey:@"address"];
    if (isForEdit) {
        NSMutableArray *arr = [self getMultipleCourseEditDictionary];
        NSMutableArray *arrNew = arr[0];
        NSMutableArray *arrOld = arr[1];
        if (arrNew.count > 0) {
            [dict setValue:arrNew forKey:@"new_products"];
        }
        if(arrOld.count > 0){
            [dict setValue:arrOld forKey:@"products"];
        }
    }else{
        [dict setValue:[self getMultipleCourseDictionary] forKey:@"products"];
    }
    
    return dict;
}
-(NSMutableArray*) getMultipleCourseDictionary {
    NSMutableArray * arrMain = [[NSMutableArray alloc]init];
    for (Batches *batch in dataClass.arrCourseBatches) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        NSMutableArray *arrTimes =[[NSMutableArray alloc]init];
        for (TimeBatch *obj in batch.batchesTimes) {
            NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
            [d setValue:[global24Formatter() stringFromDate:obj.batch_start_date] forKey:@"value"];
            [d setValue:[global24Formatter() stringFromDate:obj.batch_end_date] forKey:@"value2"];
            [arrTimes addObject:d];
        }
        [dict setValue:arrTimes forKey:@"timing"];
        [dict setValue:batch.price forKey:@"initial_price"];
        [dict setValue:batch.startDate forKey:@"start_date"];
        [dict setValue:batch.endDate forKey:@"end_date"];
        [dict setValue:batch.discount forKey:@"discounted_price"];
        [dict setValue:batch.sessions forKey:@"sessions"];
        [dict setValue:dataClass.crsBatch forKey:@"batch_size"];
        [dict setValue:dataClass.crsTutor forKey:@"tutor"];
        [dict setValue:(dataClass.crsStock == nil) ? @"1": dataClass.crsStock forKey:@"stock"];
        [dict setValue:@"0" forKey:@"sold"];
        
        [dict setValue:@"1" forKey:@"status"];
        [dict setValue:(dataClass.isTrail) ? @"1" : @"0" forKey:@"trial_class"];
        [arrMain addObject:dict];
        
    }
    return arrMain;
}
-(NSMutableArray*) getMultipleCourseEditDictionary {
    NSMutableArray * arrMain = [[NSMutableArray alloc]init];
    NSMutableArray * arrNewProduct = [[NSMutableArray alloc]init];
    NSMutableArray * arrOldProduct = [[NSMutableArray alloc]init];
    
    for (Batches *batch in dataClass.arrCourseBatches) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        NSMutableArray *arrTimes =[[NSMutableArray alloc]init];
        for (TimeBatch *obj in batch.batchesTimes) {
            NSMutableDictionary *d = [[NSMutableDictionary alloc]init];
            [d setValue:[global24Formatter() stringFromDate:obj.batch_start_date] forKey:@"value"];
            [d setValue:[global24Formatter() stringFromDate:obj.batch_end_date] forKey:@"value2"];
            [arrTimes addObject:d];
        }
        [dict setValue:arrTimes forKey:@"timing"];
        [dict setValue:[NSNumber numberWithInteger:dataClass.crsAgeGroupIndex] forKey:@"age"];
        [dict setValue:batch.price forKey:@"initial_price"];
        [dict setValue:batch.startDate forKey:@"start_date"];
        [dict setValue:batch.endDate forKey:@"end_date"];
        [dict setValue:batch.discount forKey:@"discounted_price"];
        [dict setValue:batch.sessions forKey:@"sessions"];
        [dict setValue:dataClass.crsBatch forKey:@"batch_size"];
        [dict setValue:dataClass.crsTutor forKey:@"tutor"];
        
        [dict setValue:dataClass.crsStock forKey:@"stock"];
        [dict setValue:@"0" forKey:@"sold"];
        
        [dict setValue:@"1" forKey:@"status"];
        [dict setValue:(dataClass.isTrail) ? @"1" : @"0" forKey:@"trial_class"];
        if (![self checkStringValue:batch.batchID] && dataClass.crsNid) {
            [arrOldProduct addObject:dict];
            [dict setValue:batch.batchID forKey:@"product_id"];
        }else{
            [arrNewProduct addObject:dict];
        }
        
    }
    [arrMain addObject:arrNewProduct];
    [arrMain addObject:arrOldProduct];
    
    return arrMain;
}

#pragma mark - API Call
-(void) postCourseAPI:(NSArray*) arrPic {
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    NSMutableDictionary *dict = [self getCourseDictionaryToSubmit:false];
    [dict setValue:arrPic forKey:@"images_fids"];
    NSLog(@"%@", convertObjectToJson(dict));
    
    [[NetworkManager sharedInstance] postRequestFullUrl:apiPostCourse paramter:dict withCallback:^(id jsonData, WebServiceResult result)
     {
         [hud hide:true];
         if (result == WebServiceResultSuccess) {
             // remove object in db as well from var & calls sync again for new object.
             NSString *nid = [NSString stringWithFormat:@"%@",jsonData[@"nid"]];
             [self publishCourse:@{@"nid":nid,@"publish":@"1",@"initials":tfSignature.text}];
         }else{
             [hud hide:true];
             showAletViewWithMessage(@"Alert, Alert. Space aliens shot us with technical errors while posting a course online. Don’t worry and your course is saved locally. It will be submitted as soon as internet becomes available.");
         }
     }];
}
-(void) editCourseAPI:(NSArray*) arrPic{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    NSMutableDictionary *dict = [self getCourseDictionaryToSubmit:true];
    [dict setValue:arrPic forKey:@"images_fids"];
    
    NSLog(@"%@", convertObjectToJson(dict));
    
    [[NetworkManager sharedInstance] postRequestFullUrl:apiUpdateCourse paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
         if (result == WebServiceResultSuccess) {
            [hud hide:true];
            NSString * nid = [NSString stringWithFormat:@"%@",jsonData[@"nid"]];
             if (_isStringEmpty(nid)) {
                 nid = dataClass.rowID;
             }
            [self publishCourse:@{@"nid":nid,@"publish":@"1",@"initials":tfSignature.text}];
            
        } else {
            [hud hide:true];
            [self stopActivity];
            
            showAletViewWithMessage(@"Error occurs while course edting.Your course saved and will be submitted as soon internet available");
        }
    }];
}
-(void) publishCourse:(NSDictionary*)dict {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait..";
    [[NetworkManager sharedInstance] postRequestFullUrl:apiPublish paramter:dict withCallback:^(id jsonData, WebServiceResult result)
     {
         [hud hide:true];
         if (result == WebServiceResultSuccess) {
             
             ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Post Data successfully. do you want to see course online" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
                 if (tapped == TappedOkay) {
                     [[JPUtility shared] performOperation:0.1 block:^{
                         UINavigationController *nav = (UINavigationController*)APPDELEGATE.window.rootViewController;
                         if (is_iPad()) {
                             CourseDetailsVC_iPad *vc = [getStoryBoardDeviceBased(StoryboardLearnerMain) instantiateViewControllerWithIdentifier:@"CourseDetailsVC_iPad"];
                             vc.NID = dict[@"nid"];
                             [nav pushViewController:vc animated:true];
                         }else{
                             CourseDetailsVC *vc = [getStoryBoardDeviceBased(StoryboardLearnerMain) instantiateViewControllerWithIdentifier:@"CourseDetailsVC"];
                             vc.NID = dict[@"nid"];
                             [nav pushViewController:vc animated:true];
                         }
                     }];
                     [self.navigationController popToRootViewControllerAnimated:true];
                     
                 }else{
                     [self.navigationController popToRootViewControllerAnimated:true];
                 }
                 [alert removeFromSuperview];
             }];
             [APPDELEGATE.window addSubview:alert];
             
             [CourseForm deleteCourseForm:dataClass.rowID];
             [dataClass flushClass];
             if (_isStringEmpty(dataClass.crsNid)) {
                 [dataClass setCourseFromData:dataClass.rowID];
             }
         } else {
             showAletViewWithMessage(@"Error occurs while course publish You can edit from my course screen.");
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
    if ([self checkStringValue:dataClass.crsNid]) {
        [self performSelector:@selector(postCourseAPI:) withObject:arrayFids afterDelay:1.0];
    }else{
        [self performSelector:@selector(editCourseAPI:) withObject:arrayFids afterDelay:1.0];
    }
    
    [UploadManager sharedInstance].delegate = nil;
}
- (void)uploadFailed
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading failed, Please try again.";
    showAletViewWithMessage(@"Your course saved and will be submitted as soon internet available");
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

@end
