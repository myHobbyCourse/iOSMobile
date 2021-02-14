//
//  EditProfileVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 16/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "EditProfileVC.h"
#import "MBProgressHUD.h"

@interface EditProfileVC ()<UploadManagerDelegate> {
    IBOutlet UIView *viewPicker;
    IBOutlet UIDatePicker *datePicker;
    MBProgressHUD *hud;
}
@end

@implementation EditProfileVC
//@synthesize userdetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 200;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
    [self getUserProfile];
    [self.view layoutIfNeeded];
    viewPicker.hidden = true;
    datePicker.maximumDate = [NSDate date];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Edit Profile Screen"];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
#pragma mark - Date selection
-(IBAction)btnDonePicker:(UIButton*)sender {
    userINFO.birthDate = [globalDateOnlyFormatter() stringFromDate:datePicker.date];
    viewPicker.hidden = true;
    [tblParent reloadData];

}
-(IBAction)btnHidePicker:(UIButton*)sender{
    viewPicker.hidden = true;
}
-(IBAction)btnSelectDate:(UIButton*)sender
{
    viewPicker.hidden = false;
    [tblParent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    /*DateCalenderPickerVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"DateCalenderPickerVC"];
    vc.strTitle = @"Select Date";
    [vc getRefreshBlock:^(NSString *anyValue) {
        userINFO.birthDate = anyValue;
        [tblParent reloadData];
    }];
    [self presentViewController:vc animated:true completion:nil];*/
}
#pragma mark CalenderPicker Delegate
-(void)selectedCalenderDate:(NSString *)date index:(NSInteger)pos {
    userINFO.birthDate = date;
    [tblParent reloadData];
}
#pragma mark- UITextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    userINFO.educator_introduction = textView.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag) {
        case 11:
        case 12: {
            return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:60 withSpace:NO];
        }   break;
        case 41:{
            return [AppUtils numericValidation:textField range:range string:string length:12 withFloat:false];
        }
            break;
        case 42:{
            return [AppUtils numericValidation:textField range:range string:string length:12 withFloat:false];
        }
            break;
        case 61:{
            return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:30 withSpace:YES];
        }
            break;
        case 62:{
            return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:30 withSpace:YES];
        }
            break;
        case 51:{
            return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:50 withSpace:YES];
        }
            break;
        case 52:{
            return [AppUtils numericValidation:textField range:range string:string length:8 withFloat:false];
        }
            break;
        case 53:{
            return [AppUtils numericValidation:textField range:range string:string length:9 withFloat:false];
        }
            break;
        case 54:{
            return [AppUtils textValidation:textField shouldChangeCharactersInRange:range replacementString:string length:60 withSpecialChars:YES];
        }
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (userINFO) {
        return 11;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!APPDELEGATE.userCurrent.isVendor && indexPath.row == 5) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ids = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    EditProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:ids forIndexPath:indexPath];
    cell.controller = self;
    [cell setData];
    switch (indexPath.row) {
        case 7:
            if(userINFO.hobbies.count > 0)
            {
                cell.lblHobby1.text = userINFO.hobbies[0];
                cell.lblHobby1.textColor = [UIColor blackColor];
            }else{
                cell.lblHobby1.text = @"Your Hobby";
                cell.lblHobby1.textColor = [UIColor lightGrayColor];
            }
            break;
        case 8:
            if(userINFO.hobbies.count > 1)
            {
                cell.lblHobby2.text = userINFO.hobbies[1];
                cell.lblHobby2.textColor = [UIColor blackColor];
            }else{
                cell.lblHobby2.text = @"Your Hobby";
                cell.lblHobby2.textColor = [UIColor lightGrayColor];
            }
            break;
        case 9:
            if(userINFO.hobbies.count > 2)
            {
                cell.lblHobby3.text = userINFO.hobbies[2];
                cell.lblHobby3.textColor = [UIColor blackColor];
            }else{
                cell.lblHobby3.text = @"Your Hobby";
                cell.lblHobby3.textColor = [UIColor lightGrayColor];
            }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UIbuttom Method
-(IBAction)btnSelectValue:(UIButton*)sender {
    ValueSelectorVC  *vc =(ValueSelectorVC*) [getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"ValueSelectorVC"];
        vc.screenTitle = @"Select Category";
        vc.arrTittle = _arrCategoryC;
        vc.type = SelectionTypeCategory;
        [vc getRefreshBlock:^(NSString *anyValue) {
            CategoryEntity *selected;
            for (CategoryEntity *entity in _arrCategoryC) {
                if ([entity.category isEqualToString:anyValue]) {
                    selected = entity;
                    break;
                }
            }
            
            if ((sender.tag - 11) < userINFO.hobbies.count) {
                [userINFO.hobbiesIds replaceObjectAtIndex:(sender.tag - 11) withObject:selected.tid];
                [userINFO.hobbies replaceObjectAtIndex:(sender.tag - 11) withObject:selected.category];
            }else{
                [userINFO.hobbiesIds addObject:selected.tid];
                [userINFO.hobbies addObject:selected.category];
            }
            [tblParent reloadData];
            
            
        }];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark- API Calls
-(void) getUserProfile
{
    if (![self isNetAvailable]) {
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:@"http://myhobbycourses.com/myhobbycourses_endpoint/user_details_service/get_info" paramter:nil withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         NSLog(@"%@",jsonData);
         if (result == WebServiceResultSuccess) {
             if ([jsonData isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = jsonData;
                 NSMutableDictionary *d = [dict mutableCopy];
                 [d handleNullValue];
                 userINFO = [[UserDetail alloc]initWith:d];
                 
                 NSData *data = [UserDefault objectForKey:kUserInformationKey];
                 NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                 NSDictionary *user = [retrievedDictionary[@"user"] mutableCopy];
                 id obj = user[@"picture"];
                 if ([obj isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *picDict = obj[@"picture"];
                     [picDict setValue:userINFO.user_picture forKey:@"url"];
                     [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:retrievedDictionary] forKey:kUserInformationKey];
                     [UserDefault synchronize];
                 }
                 [self.view layoutIfNeeded];
                 [tblParent reloadData];
                 if (self.moveToIndexPath) {
                     [tblParent scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.moveToIndexPath inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
                 }
                 
             }
         }else{
             [self showAlertWithTitle:kAppName forMessage:kFailAPI];
         }
     }];
}
-(void) saveProfile:(NSArray *)fids
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    if (userINFO.isChangePic)
    {
        NSDictionary *dict = @{@"mail":userINFO.mail,
                               @"picture":fids[0],
                               @"field_first_name":userINFO.first_name,
                               @"field_last_name":userINFO.last_name,
                               @"field_phone":userINFO.mobile,
                               @"field_company_name":userINFO.company_number,
                               @"field_address":userINFO.address,
                               @"field_address_2":userINFO.address_2,
                               @"field_city":userINFO.city,
                               @"field_postal_code":userINFO.postal_code,
                               @"field_landline_number":userINFO.landline_numbe,
                               @"field_company_number":userINFO.company_number,
                               @"field_vat_registration_number":userINFO.field_vat_registration_number,
                               @"field_description":userINFO.educator_introduction,
                               @"field_site":userINFO.website,
                               @"hobbies":userINFO.hobbiesIds,
                               @"gender":userINFO.gender,
                               @"date_of_birth":userINFO.birthDate,
                               };
        [[NetworkManager sharedInstance] postRequestFullUrl:apiEditUserUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result)
         {
             if (result == WebServiceResultSuccess)
             {
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
                 NSString *documentsDirectory = [paths objectAtIndex:0];
                 NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"MyProfileImage.png"];
                 EditProfileCell *cell = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                 NSData *imageData = UIImagePNGRepresentation(cell.imgProfile.image);
                 [imageData writeToFile:getImagePath atomically:NO];
                 [hud hide:true];
                 userINFO.isChangePic = false;
                 if (_refreshBlock) {
                     [self.navigationController popViewControllerAnimated:false];
                     _refreshBlock(@"");
                 }else{
                     showAletViewWithMessage(@"All set, your profile information was successfully saved");
                 }
                 
             }else
             {
                 [hud hide:true];
                 showAletViewWithMessage(@"An error occurred while updating profile information");
             }
         }];
        
        
    }else{
        NSDictionary *dict = @{@"mail":userINFO.mail,
                               @"field_first_name":userINFO.first_name,
                               @"field_last_name":userINFO.last_name,
                               @"field_phone":userINFO.mobile,
                               @"field_company_name":userINFO.company_number,
                               @"field_address":userINFO.address,
                               @"field_address_2":userINFO.address_2,
                               @"field_city":userINFO.city,
                               @"field_postal_code":userINFO.postal_code,
                               @"field_landline_number":userINFO.landline_numbe,
                               @"field_company_number":userINFO.company_number,
                               @"field_vat_registration_number":userINFO.field_vat_registration_number,
                               @"field_description":userINFO.educator_introduction,
                               @"field_site":userINFO.website,
                               @"hobbies":userINFO.hobbiesIds,
                               @"gender":userINFO.gender,
                               @"date_of_birth":userINFO.birthDate,
                               };
        [[NetworkManager sharedInstance] postRequestFullUrl:apiEditUserUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result)
         {
             [hud hide:true];
             if (result == WebServiceResultSuccess)
             {
                 userINFO.isChangePic = false;
                 if (_refreshBlock) {
                     [self.navigationController popViewControllerAnimated:false];
                     _refreshBlock(@"");
                 }
                 showAletViewWithMessage(@"All set, your profile information was successfully saved");
             }else
             {
                 showAletViewWithMessage(@"An error occurred while updating profile information");
             }
         }];
        
    }
    
}
#pragma mark- Validation
-(BOOL) validateFrm
{
    if (_isStringEmpty(userINFO.first_name)) {
        showAletViewWithMessage(@"Sorry, what was your First name again?");
        return false;
    }else if (userINFO.first_name.length < 2) {
        showAletViewWithMessage(@"Your First name must be at least 2 letters.");
        return false;
    }else if (_isStringEmpty(userINFO.last_name)) {
        showAletViewWithMessage(@"Half of you is missing, please enter last name");
        return false;
    }else if (userINFO.last_name.length < 2) {
        showAletViewWithMessage(@"We appreciate traveling light, but your last name must be at least 2 letters.");
        return false;
    }
    
    if ([self checkStringValue:userINFO.mobile]) {
        showAletViewWithMessage(@"Don’t dash without dropping the digits. Enter mobile phone number");
        return false;
    }
    NSString *phoneRegex = @"^((07))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:userINFO.mobile]){
        showAletViewWithMessage(@"Please enter valid mobile number start with 07");
        return false;
    }
    
    if (userINFO.mobile.length < 10) {
        showAletViewWithMessage(@"We didn’t get that, please enter a valid, 10 digit UK mobile number.");
        return false;
    }

    if (!_isStringEmpty(userINFO.landline_numbe)) {
        if (userINFO.landline_numbe.length > 9) {
            NSString * newString = [userINFO.landline_numbe substringWithRange:NSMakeRange(0, 2)];
            if([newString isEqualToString:@"01"] || [newString isEqualToString:@"02"] || [newString isEqualToString:@"03"])
            { }else{
                showAletViewWithMessage(@"Please enter valid landline number start with 01 | 02 | 03");
                return false;

            }
        }else{
            showAletViewWithMessage(@"Please enter valid landline number 9 to 12 char long.");
            return false;

        }
    }
    
    if ([self checkStringValue:userINFO.city])
    {
        showAletViewWithMessage(@"From (London) to (Leeds), please Select City of choice");
        return false;
    }
    if ([self checkStringValue:userINFO.postal_code])
    {
        showAletViewWithMessage(@"h01d UP…Please Enter Postcode of location");
        return false;
    }
    
    if (userINFO.educator_introduction.tringString.length < 50) {
        showAletViewWithMessage(@"Please enter min 50 charater about you.");
        return false;
    }

    if (APPDELEGATE.userCurrent.isVendor)
    {
        if (!_isStringEmpty(userINFO.company_name)  && userINFO.company_name.length < 5)
        {
            showAletViewWithMessage(@"No ABC’s…Company name must be at least 5 char long");
            return false;
        }
        if (!_isStringEmpty(userINFO.company_number)  && userINFO.company_number.length < 8)
        {
            showAletViewWithMessage(@"Please enter company number atleat 8 char long.");
            return false;
        }
        if (!_isStringEmpty(userINFO.field_vat_registration_number)  && userINFO.field_vat_registration_number.length < 9)
        {
            showAletViewWithMessage(@"Please enter company vat reg. number atleat 9 char long.");
            return false;
        }
    }
    
    return true;
}
-(IBAction)btnSave:(id)sender
{
    if (![self validateFrm])
    {
        return;
    }
    if (userINFO.isChangePic)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = [NSString stringWithFormat:@"Uploading 1 of 1"];
        [UploadManager sharedInstance].delegate = self;
        [[UploadManager sharedInstance] uploadImagesWithArray:@[userINFO.userProfile]];
    }
    else
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self saveProfile:nil];
    }
    
}
#pragma mark - Upload Manager Delegate
- (void)updateProgress:(NSNumber *)completed total:(NSNumber *)totalUpload{
    hud.progress = ([completed intValue] * 100/[totalUpload intValue])/100.0f;
    hud.labelText = [NSString stringWithFormat:@"Uploading %d of %d",(int)[completed intValue]+1,(int)[totalUpload intValue]];
}
- (void)uploadCompleted:(NSArray *)arrayFids{
    hud.labelText = @"Upload completed.";
    [self performSelector:@selector(saveProfile:) withObject:arrayFids afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}
- (void)uploadFailed{
    hud.labelText = @"Uploading failed. Please try again.";
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
