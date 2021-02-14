//
//  SignupViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/12/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()<SFSafariViewControllerDelegate>{
    NSArray *arrBasic,*arrContact,*arrAdress,*arrCompany;
}

@end

@implementation SignupViewController
@synthesize userdetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[MyLocationManager sharedInstance] getCurrentLocation];
    btnCustomer.selected = true;
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    arrBasic = [[NSArray alloc] initWithObjects:@"Username",@"Email", nil];
    arrContact = [[NSArray alloc] initWithObjects:@"First name",@"Last name",@"Mobile",@"Landline", nil];
    arrAdress = [[NSArray alloc] initWithObjects:@"Address1",@"Address2",@"City",@"Postal Code", nil];
    arrCompany = [[NSArray alloc] initWithObjects:@"Name",@"Number",@"Vat Reg. Number",@"Website",@"Reference full name",@"Offer code", nil];
    userdetail = [[UserDetail alloc]init];
    [self btnCourseWithMultipleSession:btnCourseWithMutipleSession];
    [self btnTypeOption:btnEducator];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Signup Screen"];
}

#pragma mark- UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (btnCustomer.selected){
        if (section == 0) {
            return 2;
        }else if(section == 4){
            return 1;
        }else{
            return 0;
        }
    }else{
        switch (section) {
            case 0:
                return 2;
            case 1:
                return 4;
            case 2:
                return 4;
            case 3:
                if (btnCustomer.selected && section == 3) {
                    return 0.01;
                }
                if (btnCourseWithMutipleSession.selected){
                    return 4;
                }
                return 6;
            case 4:
                return 1;
                
        }
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (btnCustomer.selected) {
        return 0.01;
    }else{
        if (section == 0 || section == 4) {
            return 0.01;
        }
        return 50;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"BatchHeader" owner:self options:nil];
    UIView *view = [viewArray objectAtIndex:1];
    UILabel *lblTitle = [view viewWithTag:111];
    switch (section) {
        case 1:
            lblTitle.text = @"CONTACT DETAILS";
            break;
        case 2:
            lblTitle.text = @"ADDRESS INFO";
            break;
        case 3:
            lblTitle.text = @"COMPANY INFO";
            break;
            
        default:
            break;
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        UIButton *btnLogin = [cell viewWithTag:44];
        btnLogin.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
        btnLogin.layer.borderWidth = 1;
        return cell;
    }
    SignUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell0" forIndexPath:indexPath];
    cell.tfInput.tag = [[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] intValue];
    cell.controller = self;
    NSString *placeHolder;
    switch (indexPath.section) {
        case 0:
            placeHolder = arrBasic[indexPath.row];
            if (indexPath.row == 0) {
                cell.tfInput.text = userdetail.name;
            }else if(indexPath.row == 1) {
                cell.tfInput.text = userdetail.mail;
            }
            break;
        case 1:
            placeHolder = arrContact[indexPath.row];
            if (indexPath.row == 0) {
                cell.tfInput.text = userdetail.first_name;
            }else if(indexPath.row == 1) {
                cell.tfInput.text = userdetail.last_name;
            }else if (indexPath.row == 2) {
                cell.tfInput.text = userdetail.mobile;
            }else if(indexPath.row == 3) {
                cell.tfInput.text = userdetail.landline_numbe;
            }
            break;
        case 2:
            placeHolder = arrAdress[indexPath.row];
            if (indexPath.row == 0) {
                cell.tfInput.text = userdetail.address;
            }else if(indexPath.row == 1) {
                cell.tfInput.text = userdetail.address_2;
            }else if(indexPath.row == 2) {
                cell.tfInput.text = userdetail.city;
            }else if(indexPath.row == 3) {
                cell.tfInput.text = userdetail.postal_code;
            }
            break;
        case 3:

            placeHolder = arrCompany[indexPath.row];
            if (indexPath.row == 0) {
                cell.tfInput.text = userdetail.company_name;
            }else if(indexPath.row == 1) {
                cell.tfInput.text = userdetail.company_number;
            }else if(indexPath.row == 2) {
                cell.tfInput.text = userdetail.field_vat_registration_number;
            }else if(indexPath.row == 3) {
                cell.tfInput.text = userdetail.website;
            }
            else if(indexPath.row == 4) {
                cell.tfInput.text = userdetail.reference;
            }else if(indexPath.row == 5) {
                cell.tfInput.text = userdetail.offerCode;
            }
            break;
            
        default:
            break;
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{ NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.7] }];
    cell.tfInput.attributedPlaceholder = str;
    return cell;
}

#pragma mark - Button method

- (IBAction)btnCourseWithMultipleSession:(UIButton *)sender {
    [self resetBtn:sender];

}

- (IBAction)btnIChargeBYHour:(UIButton *)sender {
    [self resetBtn:sender];
}

-(void)resetBtn:(UIButton *)sender{
    btnIChargeByHour.selected = NO;
    btnCourseWithMutipleSession.selected = NO;
    sender.selected = YES;
    [tblParent reloadData];
}

-(IBAction)btnTerms:(id)sender{
    SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:kTermURL]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
-(IBAction)btnPolicy:(id)sender{
    SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:kPrivacyURL]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)btnTypeOption:(UIButton *)sender
{
    if (sender ==  btnCustomer && !sender.selected)
    {
        viewTutor.hidden = true;
        btnCustomer.selected = true;
        btnEducator.selected = false;
        
    }else if (sender == btnEducator && !sender.selected)
    {
        btnCustomer.selected = false;
        btnEducator.selected = true;
        viewTutor.hidden = false;
    }
    [tblParent reloadData];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSignup:(id)sender {
    
    if (![self checValidation])
    {
        return;
    }
    [self startActivity];
    NSDictionary *dic;
    if (btnCustomer.isSelected)
    {
        dic = @{@"name":userdetail.name.tringString,@"mail":userdetail.mail.tringString,@"field_customer_or_educator":@{@"und":@"1"}};
    }else
    {
        dic = @{@"name":userdetail.name.tringString,
                @"mail":userdetail.mail.tringString,
                @"field_customer_or_educator":@{@"und":@"0"},
                @"field_first_name":@{@"und":@[@{@"value":userdetail.first_name.tringString}]},
                @"field_last_name":@{@"und":@[@{@"value":userdetail.last_name.tringString}]},
                @"field_phone":@{@"und":@[@{@"value":userdetail.mobile.tringString}]},
                @"field_company_name":@{@"und":@[@{@"value":(userdetail.company_name) ? userdetail.company_name.tringString: @""}]},
                @"field_address":@{@"und":@[@{@"value":userdetail.address.tringString}]},
                @"field_address_2":@{@"und":@[@{@"value":userdetail.address_2.tringString}]},
                @"field_city":@{@"und":@[@{@"value":userdetail.city.tringString}]},
                @"field_landline_number":@{@"und":@[@{@"value":(userdetail.landline_numbe) ? userdetail.landline_numbe.tringString:@""}]},
                @"field_company_number":@{@"und":@[@{@"value":(userdetail.company_number) ?userdetail.company_number.tringString:@""}]},
                @"field_vat_registration_number":@{@"und":@[@{@"value":(userdetail.field_vat_registration_number) ?userdetail.field_vat_registration_number.tringString:@""}]},@"field_postal_code":@{@"und":@[@{@"value":userdetail.postal_code}]}};
    }
    NSLog(@"Dict %@",dic);
    [[NetworkManager sharedInstance] postRequestUrl:apiRegisterUrl paramter:dic withCallback:^(NSDictionary *jsonData, WebServiceResult result)
     {
         NSLog(@"%@",jsonData);
         [self stopActivity];
         if (result == WebServiceResultSuccess)
         {
             showAletViewWithMessage(@"You are successfully registered,Please check your mail inbox to activate your account.");
             [self.navigationController popViewControllerAnimated:YES];
         }else if(result == WebServiceResultError) {
             NSDictionary *dict = jsonData;
             
             if ([dict isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *erorDict = [dict valueForKey:@"form_errors"];
                 if ([erorDict valueForKey:@"mail"])
                 {
                     showAletViewWithMessage([erorDict valueForKey:@"mail"]);
                 }else if ([erorDict valueForKey:@"name"]){
                     showAletViewWithMessage([erorDict valueForKey:@"name"]);
                 }else {
                     showAletViewWithMessage([[erorDict allValues] componentsJoinedByString:@"\n"]);
                 }
             }else {
                 showAletViewWithMessage(@"something went wrong.");
             }
         }
         
     }];
}

-(BOOL) checValidation
{
    if (btnCustomer.isSelected)
    {
        if ([self checkStringValue:userdetail.name])
        {
            showAletViewWithMessage(@"Please enter valid username.");
            return false;
        }
        if (userdetail.name.length < 2) {
            showAletViewWithMessage(@"Please enter username atleat 2 char long.");
            return false;
        }
        
        
        if ([self checkStringValue:userdetail.mail])
        {
            showAletViewWithMessage(@"Please enter valid email address.");
            return false;
        }
        if (!validateEmail(userdetail.mail)) {
            showAletViewWithMessage(@"Please enter valid email address.");
            return false;
        }
        
        return true;
    }else
    {
        if (![self checkValidationNext]) {
            return false;
        }
        
        if (![self checkValidationLast]) {
            return false;
        }
        
        return true;
    }
}
-(BOOL) checkValidationNext
{

    if (!validateEmail(userdetail.mail)) {
        showAletViewWithMessage(@"Please enter valid email address.");
        return false;
    }

    if ([self checkStringValue:userdetail.name])
    {
        showAletViewWithMessage(@"Please enter valid username.");
        return false;
    }
    if (userdetail.name.length < 2) {
        showAletViewWithMessage(@"Please enter username atleat 2 char long.");
        return false;
    }
    if (_isStringEmpty(userdetail.first_name)) {
        showAletViewWithMessage(@"Sorry, what was your First name again?");
        return false;
    }else if (userdetail.first_name.length < 2) {
        showAletViewWithMessage(@"Your First name must be at least 2 letters.");
        return false;
    }else if (_isStringEmpty(userdetail.last_name)) {
        showAletViewWithMessage(@"Half of you is missing, please enter last name");
        return false;
    }else if (userdetail.last_name.length < 2) {
        showAletViewWithMessage(@"We appreciate traveling light, but your last name must be at least 2 letters.");
        return false;
    }
    if ([self checkStringValue:userdetail.mobile])
    {
        showAletViewWithMessage(@"Don’t dash without dropping the digits. Enter mobile phone number");
        return false;
    }
    
    NSString *phoneRegex = @"^((07))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:userdetail.mobile]){
        showAletViewWithMessage(@"Please enter valid mobile number start with 07");
        return false;
    }
    if (!_isStringEmpty(userdetail.landline_numbe)) {
        if (userdetail.landline_numbe.length == 12) {
            NSString * newString = [userdetail.landline_numbe substringWithRange:NSMakeRange(0, 2)];
            if([newString isEqualToString:@"01"] || [newString isEqualToString:@"02"] || [newString isEqualToString:@"03"])
            { }else{
                showAletViewWithMessage(@"Please enter valid landline number start with 01 | 02 | 03");
                return false;
                
            }
        }else{
            showAletViewWithMessage(@"Please enter valid landline number 12 char long.");
            return false;
            
        }
    }
    if ([self checkStringValue:userdetail.address])
    {
        showAletViewWithMessage(@"Please enter valid address.");
        return false;
    }
    if ([self checkStringValue:userdetail.address_2])
    {
        showAletViewWithMessage(@"Please enter valid address2.");
        return false;
    }
    if ([self checkStringValue:userdetail.city])
    {
        showAletViewWithMessage(@"Please enter valid city.");
        return false;
    }
    if ([self checkStringValue:userdetail.postal_code])
    {
        showAletViewWithMessage(@"Please enter valid postal code.");
        return false;
    }

    return true;
}
-(BOOL) checkValidationLast
{
   
    
    if (!_isStringEmpty(userINFO.company_name)  && userdetail.company_name.length < 5)
    {
        showAletViewWithMessage(@"No ABC’s…Company name must be at least 5 char long");
        return false;
    }
    if (!_isStringEmpty(userINFO.company_number)  && userdetail.company_number.length < 8)
    {
        showAletViewWithMessage(@"Please enter company number atleat 8 char long.");
        return false;
    }
    if (!_isStringEmpty(userINFO.field_vat_registration_number)  && userdetail.field_vat_registration_number.length < 9)
    {
        showAletViewWithMessage(@"Please enter company vat reg. number atleat 9 char long.");
        return false;
    }
    
    
   /* if ([self checkStringValue:userdetail.company_name])
    {
        showAletViewWithMessage(@"Please enter valid company name.");
        return false;
    }
    if ([self checkStringValue:userdetail.company_number])
    {
        showAletViewWithMessage(@"Please enter valid company number.");
        return false;
    }
    if ([self checkStringValue:userdetail.field_vat_registration_number])
    {
        showAletViewWithMessage(@"Please enter valid vat registration number.");
        return false;
    }*/
    return true;
    
}
@end
