//
//  PaymentAddressVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 04/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PaymentAddressVC.h"

@interface PaymentAddressVC (){
    NSMutableArray *arrField;
}

@end

@implementation PaymentAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 80;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    arrField = [[NSMutableArray alloc]initWithObjects:@"First Name",@"Last Name",@"Address1",@"Address2",@"City",@"Postal Code", nil];
    self.userAddress = [User new];
    self.userAddress.field_postal_code = APPDELEGATE.userCurrent.field_postal_code;
    self.userAddress.field_first_name = APPDELEGATE.userCurrent.field_first_name;
    self.userAddress.field_last_name = APPDELEGATE.userCurrent.field_last_name;
    self.userAddress.field_address = APPDELEGATE.userCurrent.field_address;
    self.userAddress.field_address_2 = APPDELEGATE.userCurrent.field_address_2;
    self.userAddress.field_city = APPDELEGATE.userCurrent.field_city;
    self.userAddress.name = APPDELEGATE.userCurrent.name;
    
    self.arrData = [[UserDefault objectForKey:@"cartItem"] mutableCopy];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Payment Address Screen"];
}

-(void) getCommonBlock:(CommonBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
#pragma mark - TableView Delegate
-(IBAction)btnSaveAddressAction:(UIButton*)sender {

    if ([self validateForm]) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:@{@"administrative_area":@"",@"locality":self.userAddress.field_city.tringString,@"thoroughfare":self.userAddress.field_address.tringString,@"premise":self.userAddress.field_address_2.tringString,@"name_line":self.userAddress.name.tringString,@"first_name":self.userAddress.field_first_name.tringString,@"last_name":self.userAddress.field_last_name.tringString} forKey:@"billing_info"];

        _refreshBlock(dict);
        [self dismissViewControllerAnimated:false completion:nil];
/*            NSString *msg;
            if (self.arrData.count == 1) {
                NSDictionary * d = [self.arrData firstObject];
                msg = [NSString stringWithFormat:@"Thank you for your order at myHoobyCourses.com for “%@” - £ %.2f. Are you ready to place this order ? Please confirm YES",d[@"course_tittle"],[self getShoppingAmount]];
            } else {
                msg = [NSString stringWithFormat:@"Thank you for your order at myHoobyCourses.com. Are you ready to place this order amount for £ %.2f ? Please confirm YES",[self getShoppingAmount]];
            }
            [AppUtils actionWithMessage:kAppName withMessage:msg alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
                if ([tapped isEqualToString:@"YES"]) {
                    [self setOrder];
                }
            }];*/
    }
}
#pragma mark - Validation
-(BOOL) validateForm {
    if (_isStringEmpty(self.userAddress.field_first_name)) {
        showAletViewWithMessage(@"Sorry, what was your First name again?");
        return false;
    }
    else if (_isStringEmpty(self.userAddress.field_last_name)) {
        showAletViewWithMessage(@"Half of you is missing, please enter last name");
        return false;
    }else if (_isStringEmpty(self.userAddress.field_address)) {
        showAletViewWithMessage(@"Please enter address 1");
        return false;
    }else if (_isStringEmpty(self.userAddress.field_address)) {
        showAletViewWithMessage(@"Please enter valid city");
        return false;
    }
    return true;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrField.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lblTittle = [cell viewWithTag:111];
    UITextField *tf = [cell viewWithTag:112];
    lblTittle.text = arrField[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            tf.text = self.userAddress.field_first_name;
            tf.placeholder = @"Enter First Name";
            break;
        case 1:
            tf.text = self.userAddress.field_last_name;
            tf.placeholder = @"Half of you is missing, please enter last name";
            break;
        case 2:
            tf.text = self.userAddress.field_address;
            tf.placeholder = @"Enter Address1";
            break;
        case 3:
            tf.text = self.userAddress.field_address_2;
            tf.placeholder = @"Enter Address2";
            break;
        case 4:
            tf.text = self.userAddress.field_city;
            tf.placeholder = @"Enter City";
            break;
        case 5:
            tf.text = self.userAddress.field_postal_code;
            tf.placeholder = @"Enter Postal Code";
            break;
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSIndexPath *index = [[NSIndexPath new] indexPathForCellContainingView:textField inTableView:tblParent];
    if (index) {
        switch (index.row) {
            case 0:
                self.userAddress.field_first_name = textField.text;
                break;
            case 1:
                self.userAddress.field_last_name = textField.text;
                break;
            case 2:
                self.userAddress.field_address= textField.text;
                break;
            case 3:
                self.userAddress.field_address_2 = textField.text;
                break;
            case 4:
                self.userAddress.field_city = textField.text;
                break;
            case 5:
                self.userAddress.field_postal_code = textField.text;
                break;
            default:
                break;
        }

    }
}
#pragma mark - Other method
-(void) setOrder
{
    [self.dict setValue:@{@"administrative_area":@"",@"locality":self.userAddress.field_city.tringString,@"thoroughfare":self.userAddress.field_address.tringString,@"premise":self.userAddress.field_address_2.tringString,@"name_line":self.userAddress.name.tringString,@"first_name":self.userAddress.field_first_name.tringString,@"last_name":self.userAddress.field_last_name.tringString} forKey:@"billing_info"];
    NSString *UUIDString = [self saveToDB:self.dict];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"xxxxx: %@",jsonString);
    }
    if (![self isNetAvailable]) {
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiPostOrder paramter:self.dict withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         if (result == WebServiceResultSuccess)
         {
             if ([jsonData isKindOfClass:[NSDictionary class]]) {
                 NSDictionary * dict = jsonData;
                NSString *transfer_ref = dict[@"transfer_ref"];
                 _refreshBlock(transfer_ref);
                 showAletViewWithMessage(@"We’re in business! Thanks for your order, you’ve successfully purchased a course.");
                 [UserDefault removeObjectForKey:@"cartItem"];
                 [self deleteEntityFromDatabase:UUIDString];
             }else{
                 showAletViewWithMessage(@"There seems to be server issue, please check status of order in “my orders” section of app or website.");
                 [UserDefault removeObjectForKey:@"cartItem"];
                 [self deleteEntityFromDatabase:UUIDString];
                 
             }
         }else{
             if ([jsonData isKindOfClass:[NSArray class]])
             {
                 NSArray *arr = (NSArray*) jsonData;
                 if (arr.count > 0)
                 {
                     showAletViewWithMessage(arr[0]);
                     [self deleteEntityFromDatabase:UUIDString];
                 }
             }else{
                 [UserDefault removeObjectForKey:@"cartItem"];
                 showAletViewWithMessage(@"There seems to be server issue, please check status of order in “my orders” section of app or website.");
             }
         }
         [self dismissViewControllerAnimated:YES completion:nil];

     }];
}
-(CGFloat) getShoppingAmount {
    float totlSum = 0.0;
    for (NSDictionary *d in _arrData) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        float value = [numberFormatter numberFromString:d[@"price"]].floatValue;
        totlSum = totlSum + value;
    }
    return totlSum;
}
-(NSString*) saveToDB:(NSDictionary*) dic
{
    NSData *dataToSave = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"CourseOrderSync" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    [object setValue:dataToSave forKey:@"courseJson"];
    NSString  *UUIDString = [[NSUUID UUID] UUIDString];
    [object setValue:UUIDString forKey:@"uid"];
    NSLog(@"UUID:%@",UUIDString);
    
    [APPDELEGATE saveContext];
    return UUIDString;
    
}
-(void)deleteEntityFromDatabase:(NSString*)UUIDString
{
    NSArray* course = [self getUnsubmittedCourseFromDatabase];
    for (NSManagedObject* courseObject in course)
    {
        if ([[courseObject valueForKey:@"uid"] isEqual:UUIDString])
        {
            [APPDELEGATE.managedObjectContext deleteObject:courseObject];
            [APPDELEGATE saveContext];
            break;
        }
    }
    
}
-(NSArray*)getUnsubmittedCourseFromDatabase{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CourseOrderSync" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    [request setEntity:entity];
    NSArray *results = [APPDELEGATE.managedObjectContext executeFetchRequest:request error:nil];
    if (results != nil && [results count] > 0)
    {
        return results;
    }
    return [[NSArray alloc] init];
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
