//
//  ShoppingCartViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingCartTableViewCell.h"

#import "Constants.h"

@interface ShoppingCartViewController ()<UIActionSheetDelegate,BTDropInViewControllerDelegate,PKPaymentAuthorizationViewControllerDelegate,BTViewControllerPresentingDelegate>
{
    NSString *UUIDString;
    IBOutlet UIView *viewShadow;
    IBOutlet UIView *viewPaymentMethod;
    NSInteger selectedBatch;
    NSMutableDictionary *addressDict;
}
@property (nonatomic, strong) BTAPIClient *braintreeClient;

@end

@implementation ShoppingCartViewController
@synthesize braintreeClient;

- (void)viewDidLoad {
    [super viewDidLoad];
    //    braintreeClient = [[BTAPIClient alloc] initWithAuthorization:@"sandbox_mhq9wz9m_qbfypbk88g9hkhxz"];
    [PayPalManager getInstance].delegate=self;
    tblCart.rowHeight = UITableViewAutomaticDimension;
    tblCart.estimatedRowHeight = 70;
    [self getClientTokenBraintree];
    if (is_iPad()) {
        selectedBatch = 0;
        [self addShaowForiPad:viewShadow];
        PaymentOptionVC *vc = self.childViewControllers[1];
        [vc getRefreshBlock:^(NSString *anyValue) {
            [self handleOptionMethod:anyValue];
        }];
    }
    viewPaymentMethod.hidden = true;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Cart Screen"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initData];
    [tblCart reloadData];
    if (self.arrData.count > 0) {
        viewEmptyCart.hidden = true;
    }else{
        viewEmptyCart.hidden = false;
    }
}

- (void) initData
{
    self.arrData = [[UserDefault objectForKey:@"cartItem"] mutableCopy];
    lblTotalPrice.text = [NSString stringWithFormat:@"£ %.2f",[self getShoppingAmount]];
    selectedBatch = 0;
    [tblParent reloadData];
    if (self.arrData.count > 0 && is_iPad()) {
        [self batchDetails:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
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
-(IBAction)btnDetails:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblCart];
    NSIndexPath *indexPath = [tblCart indexPathForRowAtPoint:buttonPosition];
    UITableViewCell *cell = [tblCart cellForRowAtIndexPath:indexPath];
    NSDictionary * dict = [_arrData objectAtIndex:indexPath.row];
    if (dict) {
        NSString *nid = dict[@"id"];
        NSString *selectedProduct = dict[@"product_id"];
        NSData *data = [UserDefault objectForKey:nid];
        if (data)
        {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *d = [jsonData mutableCopy];
                [d handleNullValue];
                CourseDetail *courseEntity = [[CourseDetail alloc]initWith:d];
                NSLog(@"%@",courseEntity);
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"product_id == %@",selectedProduct];
                NSArray *arrBatch =  [courseEntity.productArr filteredArrayUsingPredicate:pre];
                if (arrBatch.count > 0) {
                    ProductEntity *product = arrBatch[0];
                    CourseBatchDisplayVC  *vc =(CourseBatchDisplayVC*) [self.storyboard instantiateViewControllerWithIdentifier: @"CourseBatchDisplayVC"];
                    vc.arrTimes = product.timings;
                    vc.courseStart = product.course_start_date;
                    vc.courseEnd = product.course_end_date;
                    vc.courseEntity = courseEntity;
                    vc.product = product;
                    vc.isDetail = true;
                    if (is_iPad())
                    {
                        CourseBatchDisplayVC *vc = self.childViewControllers[0];
                        [vc initData];
                    }else{
                        [self presentViewController:vc animated:false completion:nil];
                    }
                }
            }
            
        }
    }
}
-(void)batchDetails:(NSIndexPath*)indexPath {
    NSDictionary * dict = [_arrData objectAtIndex:indexPath.row];
    if (dict) {
        NSString *nid = dict[@"id"];
        NSString *selectedProduct = dict[@"product_id"];
        NSData *data = [UserDefault objectForKey:nid];
        if (data)
        {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *d = [jsonData mutableCopy];
                [d handleNullValue];
                CourseDetail *courseEntity = [[CourseDetail alloc]initWith:d];
                NSLog(@"%@",courseEntity);
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"product_id == %@",selectedProduct];
                NSArray *arrBatch =  [courseEntity.productArr filteredArrayUsingPredicate:pre];
                if (arrBatch.count > 0) {
                    ProductEntity *product = arrBatch[0];
                    CourseBatchDisplayVC  *vc = self.childViewControllers[0];
                    vc.arrTimes = product.timings;
                    vc.courseStart = product.course_start_date;
                    vc.courseEnd = product.course_end_date;
                    vc.courseEntity = courseEntity;
                    vc.product = product;
                    vc.isDetail = true;
                    [vc initData];
                    
                }
            }
            
        }
    }
}
-(void) setOrder:(NSString*) paykey
{
    NSMutableArray *arrCourse = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.arrData)
    {
        NSMutableDictionary * dictCourse = [[NSMutableDictionary alloc]init];
        [dictCourse setValue:dict[@"product_id"] forKey:@"id"];
        [dictCourse setValue:@"1" forKey:@"quantity"];
        [arrCourse addObject:dictCourse];
    }
    
    //    NSDictionary * dict = @{@"payment_type":@"paypal",@"payment_id":paykey,@"courses":arrCourse};

    //    "billing_info":{"country":"UK", "administrative_area":"Some area",  "locality":"London", "postal_code":"UYU44", "thoroughfare":"address 1", "premise":"address2", "name_line":"full name", "first_name":"first name",
//        "last_name":"Last name"}
    
//    NSDictionary * dict = @{@"payment_type":@"braintree",@"paymentMethodNonce":paykey,@"courses":arrCourse};
    [addressDict setObject:@"braintree" forKey:@"payment_type"];
    [addressDict setObject:paykey forKey:@"paymentMethodNonce"];
    [addressDict setObject:arrCourse forKey:@"courses"];
    
    [self saveToDB:addressDict];
    HCLog(@"payment json: %@",convertObjectToJson(addressDict));
    if (![self isNetAvailable]) {
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiPostOrder paramter:addressDict withCallback:^(id jsonData, WebServiceResult result)
     {
         
         HCLog(@"%@",jsonData);
         [self stopActivity];
         if (result == WebServiceResultSuccess)
         {
             showAletViewWithMessage(@"We’re in business! Thanks for your order, you’ve successfully purchased a course.");
             [self.arrData removeAllObjects];
             [UserDefault removeObjectForKey:@"cartItem"];
             [tblCart reloadData];
             [self deleteEntityFromDatabase];
             [self.navigationController popViewControllerAnimated:true];
             [[JPUtility shared] performOperation:0.5 block:^{
                 OrderCoursesViewController *vc = [getStoryBoardDeviceBased(StoryboardMain) instantiateViewControllerWithIdentifier:@"OrderCoursesViewController"];
                 UINavigationController *nav = (UINavigationController*) APPDELEGATE.window.rootViewController;
                 [nav pushViewController:vc animated:YES];
                 
             }];
             
         }else{
             [self.arrData removeAllObjects];
             [UserDefault removeObjectForKey:@"cartItem"];
             [tblCart reloadData];
             if ([jsonData isKindOfClass:[NSArray class]]) {
                 showAletViewWithMessage(jsonData[0]);
             }else{
                 showAletViewWithMessage(@"There seems to be server issue, please check status of order in “my orders” section of app or website.");
             }
         }
         viewEmptyCart.hidden = false;
         lblTotalPrice.text = [NSString stringWithFormat:@"£ 0.0"];
     }];
}
-(void) getClientTokenBraintree
{
    if (![self isNetAvailable]) {
        return;
    }
    
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:@"1" forKey:@"clientToken"];
    [dict setValue:@"braintree" forKey:@"payment_type"];
    NSLog(@"%@", convertObjectToJson(dict));
    [[NetworkManager sharedInstance] postRequestFullUrl:kBraintreeToken paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSDictionary class]]) {
                braintreeClient = [[BTAPIClient alloc] initWithAuthorization:jsonData[@"clientToken"]];
            }else{
                showAletViewWithMessage(kFailAPI);
            }
        } else{
            showAletViewWithMessage(kFailAPI);
            
        }
    }];
}

-(void) saveToDB:(NSDictionary*) dic
{
    NSData *dataToSave = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"CourseOrderSync" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    [object setValue:dataToSave forKey:@"courseJson"];
    UUIDString = [[NSUUID UUID] UUIDString];
    [object setValue:UUIDString forKey:@"uid"];
    NSLog(@"UUID:%@",UUIDString);
    
    [APPDELEGATE saveContext];
    
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
-(void)deleteEntityFromDatabase
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
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartTableViewCell"];
    NSDictionary * dict = [self.arrData objectAtIndex:indexPath.row];
    [cell setCartData:dict];
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"delete" backgroundColor:UIColorFromRGB(0xfe347e) callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"delete button click event!");
        [_arrData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [UserDefault setObject:_arrData forKey:@"cartItem"];
        lblTotalPrice.text = [NSString stringWithFormat:@"£ %.2f",[self getShoppingAmount]];
        
        return YES;
    }]];
    if (is_iPad()) {
        if (selectedBatch == indexPath.row) {
            cell.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:230.0/255.0 blue:241.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (is_iPad()) {
        viewPaymentMethod.hidden = true;
        selectedBatch = indexPath.row;
        [self batchDetails:indexPath];
        [tableView reloadData];
    }
}
#pragma mark - Other Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"segueBank" sender:self];
        
    }else if (buttonIndex == 1)
    {
        [self performSelector:@selector(confirmPopForShopping) withObject:self afterDelay:0.1];
    }
}
-(void) confirmPopForShopping {
    NSString *msg;
    if (_arrData.count == 1) {
        NSDictionary * d = [_arrData firstObject];
        msg = [NSString stringWithFormat:@"Thank you for your order at myHoobyCourses.com for “%@” - £ %.2f. Are you ready to place this order ? Please confirm YES",d[@"course_tittle"],[self getShoppingAmount]];
    }else{
        msg = [NSString stringWithFormat:@"Thank you for your order at myHoobyCourses.com. Are you ready to place this order amount for £ %.2f ? Please confirm YES",[self getShoppingAmount]];
    }
    [AppUtils actionWithMessage:kAppName withMessage:msg alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            [self performSelector:@selector(braintreePaymentGateway) withObject:self afterDelay:0.1];
        }
    }];
}
#pragma mark - Apple Pay
- (IBAction)tappedApplePay {
    PKPaymentRequest *paymentRequest = [self paymentRequest];
    PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
    vc.delegate = self;
    if (vc) {
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}
- (PKPaymentRequest *)paymentRequest {
    NSString *price = [NSString stringWithFormat:@"%.2f",[self getShoppingAmount]];
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.merchantIdentifier = kMerchantID;
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    paymentRequest.countryCode = @"GB"; // e.g. US
    paymentRequest.currencyCode = @"GBP"; // e.g. USD
    paymentRequest.paymentSummaryItems =
    @[
      [PKPaymentSummaryItem summaryItemWithLabel:[NSString stringWithFormat:@"%@ etc..",[_arrData firstObject][@"course_tittle"]] amount:[NSDecimalNumber decimalNumberWithString:price]],
      // Add add'l payment summary items...
      [PKPaymentSummaryItem summaryItemWithLabel:@"myhobbycourses" amount:[NSDecimalNumber decimalNumberWithString:price]]
      ];
    return paymentRequest;
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    
    // Example: Tokenize the Apple Pay payment
    BTApplePayClient *applePayClient = [[BTApplePayClient alloc]
                                        initWithAPIClient:self.braintreeClient];
    [applePayClient tokenizeApplePayPayment:payment
                                 completion:^(BTApplePayCardNonce *tokenizedApplePayPayment,
                                              NSError *error) {
                                     if (tokenizedApplePayPayment) {
                                         // On success, send nonce to your server for processing.
                                         // If applicable, address information is accessible in `payment`.
                                         NSLog(@"nonce = %@", tokenizedApplePayPayment.nonce);
                                         [self setOrder:tokenizedApplePayPayment.nonce];
                                         
                                         // Then indicate success or failure via the completion callback, e.g.
                                         completion(PKPaymentAuthorizationStatusSuccess);
                                     } else {
                                         // Tokenization failed. Check `error` for the cause of the failure.
                                         
                                         // Indicate failure via the completion callback:
                                         completion(PKPaymentAuthorizationStatusFailure);
                                     }
                                 }];
}

// Be sure to implement -paymentAuthorizationViewControllerDidFinish:
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -Braintree
-(void) braintreePaymentGateway{
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    
    BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
    paymentRequest.summaryTitle = [NSString stringWithFormat:@"%@ etc..",[_arrData firstObject][@"course_tittle"]];
    paymentRequest.displayAmount = [NSString stringWithFormat:@"£%.2f",[self getShoppingAmount]];
    paymentRequest.summaryDescription = @"Thank you for your order at myHoobyCourses.com";
    paymentRequest.amount = [NSString stringWithFormat:@"%.2f",[self getShoppingAmount]];
    paymentRequest.currencyCode = @"GBP";
    dropInViewController.paymentRequest = paymentRequest;
    
    // This is where you might want to customize your view controller (see below)
    
    // The way you present your BTDropInViewController instance is up to you.
    // In this example, we wrap it in a new, modally-presented navigation controller:
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void) openPaypalView{
    if (self.arrData.count>0)
    {
        [PayPalManager getInstance].courseAmount = [NSString stringWithFormat:@"%.2f",[self getShoppingAmount]];
        [PayPalManager getInstance].desc = @"Course";
        [[PayPalManager getInstance] loginInPaypal:self];
    }else{
        [self showAlertWithTitle:kAppName forMessage:@"Please add course to cart."];
    }
}
-(IBAction)btnCheckout:(id)sender
{
    if (self.arrData.count == 0) {
        [self showAlertWithTitle:kAppName forMessage:@"Please add course to cart."];
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        PaymentAddressVC *vc = [getStoryBoardDeviceBased(StoryboardMain) instantiateViewControllerWithIdentifier:@"PaymentAddressVC"];
        [vc getCommonBlock:^(NSMutableDictionary *dict) {
            addressDict = dict;
            BookingSettingVC *vcb = [getStoryBoardDeviceBased(StoryboardSettings) instantiateViewControllerWithIdentifier:@"BookingSettingVC"];
            
            [vcb getRefreshBlock:^(NSString *anyValue) {
                viewPaymentMethod.hidden = false;
                if (!is_iPad()) {
                    PaymentOptionVC *vc = [getStoryBoardDeviceBased(StoryboardMain) instantiateViewControllerWithIdentifier:@"PaymentOptionVC"];
                    [vc getRefreshBlock:^(NSString *anyValue) {
                        [self handleOptionMethod:anyValue];
                    }];
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }];
            [self.navigationController pushViewController:vcb animated:YES];
        }];
        
        [self presentViewController:vc animated:YES completion:nil];
    });
    
    
}
-(void) handleOptionMethod:(NSString*) anyValue{
    if ([anyValue isEqualToString:@"0"]) {
        [self performSelector:@selector(confirmPopForShopping) withObject:self afterDelay:0.2];
    }else if([anyValue isEqualToString:@"2"]) {
        [self performSelector:@selector(tappedApplePay) withObject:self afterDelay:0.2];
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            PaymentAddressVC *vc = [getStoryBoardDeviceBased(StoryboardMain) instantiateViewControllerWithIdentifier:@"PaymentAddressVC"];
            
            NSMutableArray *arrCourse = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in self.arrData)
            {
                NSMutableDictionary * dictCourse = [[NSMutableDictionary alloc]init];
                [dictCourse setValue:dict[@"product_id"] forKey:@"id"];
                [dictCourse setValue:@"1" forKey:@"quantity"];
                [arrCourse addObject:dictCourse];
            }
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setValue:arrCourse forKey:@"courses"];
            [dict setValue:@"bank_transfer" forKey:@"payment_type"];
            vc.dict = dict;
            [vc getCommonBlock:^(NSString *anyValue) {
                [[JPUtility shared] performOperation:0.3 block:^{
                    OrderCoursesViewController *vc = [getStoryBoardDeviceBased(StoryboardMain) instantiateViewControllerWithIdentifier:@"OrderCoursesViewController"];
                    UINavigationController *nav = (UINavigationController*) APPDELEGATE.window.rootViewController;
                    [nav pushViewController:vc animated:YES];
                    
                }];
            }];
            
            [self presentViewController:vc animated:YES completion:nil];
        });
    }
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueBank"]) {
        BankTransferVC *vc = segue.destinationViewController;
        vc.transfer_ref = sender;
    }
}
- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Delegate
- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    HCLog(@"Nonce == %@",paymentMethodNonce.nonce);
    //    [self postNonceToServer:paymentMethodNonce.nonce];
    //    [self setOrder:paymentMethodNonce.nonce];
    BTThreeDSecureDriver *threeDSecure = [[BTThreeDSecureDriver alloc] initWithAPIClient:self.braintreeClient delegate:self];
    
    // Dismiss drop-in ui
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self startActivity];
    // Kick off 3D Secure flow. This example uses a value of $1999.99.
    [threeDSecure verifyCardWithNonce:paymentMethodNonce.nonce
                               amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[self getShoppingAmount]]]
                           completion:^(BTThreeDSecureCardNonce *card, NSError *error) {
                               [self stopActivity];
                               if (error) {
                                   // Handle errors
                                   NSLog(@"error: %@",error);
                                   return;
                                   
                               }
                               
                               // Use resulting `card`...
                               NSLog(@"3D Secure Card nonce: %@",card.nonce);
                               if(card.nonce)
                                   [self setOrder:card.nonce];
                           }];
}


- (void)paymentDriver:(id)driver requestsPresentationOfViewController:(UIViewController *)viewController {
    [self stopActivity];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)paymentDriver:(id)driver requestsDismissalOfViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Paypal Delegate
-(void)paymentSuccess:(PayPalPayment *)completedPayment{
    NSLog(@"paymentSuccess:%@",completedPayment);
    NSDictionary *dicpayments = [[NSDictionary alloc] initWithDictionary:completedPayment.confirmation[@"response"]];
    NSString *paymentKey = [dicpayments objectForKey:@"id"];
    NSLog(@"paymentKey :%@",paymentKey);
    [self setOrder:paymentKey];
}

-(void)paymentCanceled{
    NSLog(@"paymentCanceled:");
}

-(void)paymentFailed:(NSString *)failedID{
    NSLog(@"paymentFailed:%@",failedID);
}
#pragma mark - UIButton Method
-(IBAction)btnGotoCourses:(id)sender {
    if (is_iPad()) {
        HobbyTabBarController *tab = self.tabBarController;
        [tab selectTab:0];
    }else{
        self.tabBarController.selectedIndex = 0;
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

@end
