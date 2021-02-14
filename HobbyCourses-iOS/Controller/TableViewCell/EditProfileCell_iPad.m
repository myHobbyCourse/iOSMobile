//
//  EditProfileCell_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 22/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "EditProfileCell_iPad.h"
#import "NSMutableArray+Extension.h"

@implementation EditProfileCell_iPad
@synthesize viewRoundPrivate,controller;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.tfEmail.userInteractionEnabled = false;
    if (viewRoundPrivate) {
        viewRoundPrivate.layer.borderWidth = 1.0f;
        viewRoundPrivate.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        viewRoundPrivate.layer.cornerRadius = 8;
    
        viewRoundPrivate.layer.shadowColor = __THEME_lightGreen.CGColor;
        viewRoundPrivate.layer.shadowOffset = CGSizeMake(3, 3);
        viewRoundPrivate.layer.shadowOpacity = 1;
        viewRoundPrivate.layer.shadowRadius = 5.0;
        viewRoundPrivate.backgroundColor = [UIColor whiteColor];
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Set Data
-(void) setData {
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
        _tfBirthDate.text = userINFO.birthDate;
    }
    if (APPDELEGATE.userCurrent.isVendor) {
        _tfCname.text = userINFO.company_name;
        _tfCno.text = userINFO.company_number;
        _tfCVat.text = userINFO.field_vat_registration_number;
        _tfCwebsite.text = userINFO.website;
        _viewCompany.hidden = false;
        _companyTitle.hidden = false;
    }else{
        _viewCompany.hidden = true;
        _companyTitle.hidden = true;
    }
    
    if(userINFO.hobbies.count > 0)
    {
        _lblHobby1.text = userINFO.hobbies[0];
        _lblHobby1.textColor = [UIColor blackColor];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.category == [c] %@",userINFO.hobbies[0]];
        NSArray<CategoryEntity*> *arr = [_arrCategoryC filteredArrayUsingPredicate:pred];
        if (arr.count > 0) {
            [_imgHobby1 sd_setImageWithURL:[NSURL URLWithString:arr[0].image]];
        }
    }else{
        _lblHobby1.text = @"Your Hobby";
        _lblHobby1.textColor = [UIColor lightGrayColor];
        _imgHobby1.image = nil;
    }


    if(userINFO.hobbies.count > 1)
    {
        _lblHobby2.text = userINFO.hobbies[1];
        _lblHobby2.textColor = [UIColor blackColor];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.category == [c] %@",userINFO.hobbies[1]];
        NSArray<CategoryEntity*> *arr = [_arrCategoryC filteredArrayUsingPredicate:pred];
        if (arr.count > 0) {
            [_imgHobby2 sd_setImageWithURL:[NSURL URLWithString:arr[0].image]];
        }
        
    }else{
        _lblHobby2.text = @"Your Hobby";
        _lblHobby2.textColor = [UIColor lightGrayColor];
        _imgHobby2.image = nil;
    }


    if(userINFO.hobbies.count > 2)
    {
        _lblHobby3.text = userINFO.hobbies[2];
        _lblHobby3.textColor = [UIColor blackColor];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.category == [c] %@",userINFO.hobbies[2]];
        NSArray<CategoryEntity*> *arr = [_arrCategoryC filteredArrayUsingPredicate:pred];
        if (arr.count > 0) {
            [_imgHobby3 sd_setImageWithURL:[NSURL URLWithString:arr[0].image]];
        }
    }else{
        _lblHobby3.text = @"Your Hobby";
        _lblHobby3.textColor = [UIColor lightGrayColor];
        _imgHobby3.image = nil;
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
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _tfFirstName || textField == _tfLastName) {
        return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:60 withSpace:NO];
    }else if(textField == _tfMobile){
        return [AppUtils numericValidation:textField range:range string:string length:12 withFloat:false];

    }else if(textField == _tfLandline){
        return [AppUtils numericValidation:textField range:range string:string length:12 withFloat:false];
    }else if(textField == _tfCname){
        return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:50 withSpace:YES];
    }else if(textField == _tfCno){
        return [AppUtils numericValidation:textField range:range string:string length:8 withFloat:false];
    }else if(textField == _tfCVat){
        return [AppUtils numericValidation:textField range:range string:string length:9 withFloat:false];
    }else if(textField == _tfCwebsite){
        return [AppUtils textValidation:textField shouldChangeCharactersInRange:range replacementString:string length:60 withSpecialChars:YES];
    }else if(textField == _tfAdd1 || textField == _tfAdd2){
        return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:30 withSpace:YES];
    }
    return YES;
}

-(IBAction) textEdit:(UITextField*) textFeild {
    if (textFeild == _tfFirstName) {
        userINFO.first_name = textFeild.text;
    }else if (textFeild == _tfLastName) {
        userINFO.last_name = textFeild.text;
    }else if (textFeild == _tfEmail) {
        userINFO.mail = textFeild.text;
    }else if (textFeild == _tfMobile) {
        userINFO.mobile = textFeild.text;
    }else if (textFeild == _tfLandline) {
        userINFO.landline_numbe = textFeild.text;
    }else if (textFeild == _tfAdd1) {
        userINFO.address = textFeild.text;
    }else if (textFeild == _tfAdd2) {
        userINFO.address_2 = textFeild.text;
    }else if (textFeild == _tfCity) {
        userINFO.city = textFeild.text;
    }
    
    else if (textFeild == _tfPostalCode) {
        userINFO.postal_code = textFeild.text;
    }else if (textFeild == _tfCname) {
        userINFO.company_name = textFeild.text;
    }else if (textFeild == _tfCno) {
        userINFO.company_number = textFeild.text;
    }else if (textFeild == _tfCVat) {
        userINFO.field_vat_registration_number = textFeild.text;
    }else if (textFeild == _tfCwebsite) {
        userINFO.website = textFeild.text;
    }
}


#pragma mark - Get Location
-(IBAction)btnGetAddress:(id)sender {
    [self.controller startActivity];
    [[UserLocation sharedInstance] fetchUserLocationForOnce:self.controller block:^(CLLocation * location, NSError * error) {
        [self.controller stopActivity];
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
    if (location == nil)
    {
        showAletViewWithMessage(@"Where’d you go? Failed to get your current location using GPS");
        return;
    }
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
