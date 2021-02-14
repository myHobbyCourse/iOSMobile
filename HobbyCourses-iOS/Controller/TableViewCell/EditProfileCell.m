//
//  EditProfileCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 16/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "EditProfileCell.h"

@implementation EditProfileCell
@synthesize viewRoundPrivate,controller;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.tfEmail.userInteractionEnabled = false;
    if (viewRoundPrivate) {
        viewRoundPrivate.layer.borderWidth = 1.0f;
        viewRoundPrivate.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        viewRoundPrivate.layer.cornerRadius = 8;
        
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Set Data
-(void) setData {
    [_imgProfile sd_setImageWithURL:[NSURL URLWithString:userINFO.user_picture]];
    if (_imgProfile) {
        [_imgProfile layoutIfNeeded];
        _imgProfile.layer.cornerRadius = _imgProfile.frame.size.width/2;
        _imgProfile.layer.masksToBounds  = YES;
    }
    _lblWelcome.text = [NSString stringWithFormat:@"%@ Welcome Back",userINFO.name];
    _lblSince.text = [NSString stringWithFormat:@"Member since %@",userINFO.created];
    _tfFirstName.text = userINFO.first_name;
    _tfLastName.text = userINFO.last_name;
    _tfEmail.text = userINFO.mail;
    _tfMobile.text = userINFO.mobile;
    _tfLandline.text = userINFO.landline_numbe;
    _tfAdd1.text = userINFO.address;
    _tfAdd2.text = userINFO.address_2;
    _tfCity.text = userINFO.city;
    _tfPostalCode.text = userINFO.postal_code;
    if ([userINFO.gender isEqualToString:@"Male"]) {
        [self btnGender:_btnMale];
    }else if([userINFO.gender isEqualToString:@"Female"]) {
        [self btnGender:_btnFemale];
    }else if([userINFO.gender isEqualToString:@"Other"]) {
        [self btnGender:_btnOther];
    }
    if (![controller checkStringValue:userINFO.birthDate]) {
        [_btnBirth setTitle:userINFO.birthDate forState:UIControlStateNormal];
    }
    _txtDesc.text = userINFO.educator_introduction;
    if (APPDELEGATE.userCurrent.isVendor) {
        _tfCname.text = userINFO.company_name;
        _tfCno.text = userINFO.company_number;
        _tfCVat.text = userINFO.field_vat_registration_number;
        _tfCwebsite.text = userINFO.website;
    }
}
#pragma mark-
-(IBAction) btnGender:(UIButton*) sender{
    _btnMale.selected = false;
    _btnFemale.selected = false;
    _btnOther.selected = false;
    switch (sender.tag) {
        case 0:{
            _btnMale.selected = true;
            userINFO.gender = @"Male";
        }
            break;
        case 1:{
            _btnFemale.selected = true;
            userINFO.gender = @"Female";
        }
            break;
        case 2:{
            _btnOther.selected = true;
            userINFO.gender = @"Other";
            
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - UITexFeild Method
-(IBAction) textEdit:(UITextField*) textFeild{
    switch (textFeild.tag) {
        case 11: {
            userINFO.first_name = textFeild.text;
        }
            break;
        case 12:{
            userINFO.last_name = textFeild.text;
        }
            break;
        case 31:{
            userINFO.mail = textFeild.text;
        }
            break;
        case 41:{
            userINFO.mobile = textFeild.text;
        }
            break;
        case 42:{
            userINFO.landline_numbe = textFeild.text;
        }
            break;
        case 61:{
            userINFO.address = textFeild.text;
        }
            break;
        case 62:{
            userINFO.address_2 = textFeild.text;
        }
            break;
        case 63:{
            userINFO.city = textFeild.text;
        }
            break;
        case 64:{
            userINFO.postal_code = textFeild.text;
        }
            break;
        case 51:{
            userINFO.company_name = textFeild.text;
        }
            break;
        case 52:{
            userINFO.company_number = textFeild.text;
        }
            break;
        case 53:{
            userINFO.field_vat_registration_number = textFeild.text;
        }
            break;
        case 54:{
            userINFO.website = textFeild.text;
        }
            break;
        default:
            break;
    }
}

-(IBAction)btnOpenImagePicker:(id)sender{
    [AppUtils actionWithMessage:kAppName withMessage:@"Choose image" alertType:UIAlertControllerStyleActionSheet button:@[@"Camera",@"Gallery"] controller:controller block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"Camera"]) {
            [self openCamera];
        }else if ([tapped isEqualToString:@"Gallery"]) {
            [self openGallery];
        }
    }];
}
-(void) openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        [controller presentViewController:picker animated:YES completion:NULL];
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
    if (is_iPad())
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:self.imgProfile.bounds inView:self.imgProfile permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }];
        
    }else{
        [controller presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    _imgProfile.image = image;
    userINFO.userProfile = image;
    userINFO.isChangePic = true;
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Get Location
-(IBAction)btnGetAddress:(id)sender {
    [[UserLocation sharedInstance] fetchUserLocationForOnce:self.controller block:^(CLLocation * location, NSError * error) {
        if (location) {
            [self findAddressFromLocation:location];
        }else{
            showAletViewWithMessage(@"Where’d you go? Failed to get your current location using GPS");
        }
    }];
}

-(void)findAddressFromLocation:(CLLocation*)location
{
    NSLog(@"findAddressFromLocation %@",location);
   
    CLGeocoder *geoCoder;
    
    if (!geoCoder) {
        geoCoder = [[CLGeocoder alloc]init];
    }
    [controller startActivity];
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"geoCoder %@",[error debugDescription]);
         [controller stopActivity];
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
             if (![controller checkStringValue:[placemarks[0] postalCode]]) {
                 _tfPostalCode.text = [placemarks[0] postalCode];
                 userINFO.postal_code  =  _tfPostalCode.text;
             }
             
             if (![controller checkStringValue:[placemarks[0] locality]]) {
                 _tfCity.text = [placemarks[0] locality];
                 userINFO.city  =  _tfCity.text;
             }
             if (![controller checkStringValue:[placemarks[0] thoroughfare]]) {
                 _tfAdd1.text = [placemarks[0] thoroughfare];
                 userINFO.address  =  _tfAdd1.text;
             }
             if (![controller checkStringValue:[placemarks[0] subThoroughfare]]) {
                 _tfAdd2.text = [placemarks[0] subThoroughfare];
                 userINFO.address_2  =  _tfAdd2.text;
             }
             
         }
         
     }];
    
}


@end
