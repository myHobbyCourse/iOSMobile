//
//  PayPalManager.m
//  FresHeads
//
//  Created by SiplMacMini4 on 08/12/15.
//  Copyright © 2015 Systematix Inc. All rights reserved.
//

#import "PayPalManager.h"

#define kPayPalEnvironment PayPalEnvironmentSandbox
//#define kPayPalEnvironment PayPalEnvironmentProduction

@implementation PayPalManager

+ (PayPalManager *)getInstance {
    static dispatch_once_t once;
    static PayPalManager *sharedManager;
    dispatch_once(&once, ^ { sharedManager = [[self alloc] init]; });
    return sharedManager;
}

- (BOOL)acceptCreditCards {
    return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

-(void)setupPaypal{
        // Set up payPalConfig
        _payPalConfig = [[PayPalConfiguration alloc] init];
    
    
#if HAS_CARDIO
        _payPalConfig.acceptCreditCards = YES;
#else
        _payPalConfig.acceptCreditCards = YES;
#endif
        _payPalConfig.merchantName = @"My HobbyCourses.";
        _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
        
        // Setting the languageOrLocale property is optional.
        //
        // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
        // its user interface according to the device's current language setting.
        //
        // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
        // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
        // to use that language/locale.
        //
        // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
        _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
        _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
        // Do any additional setup after loading the view, typically from a nib.
        // use default environment, should be Production in real life
        self.environment = kPayPalEnvironment;
        NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
        [self setPayPalEnvironment:self.environment];
}

- (void)setPayPalEnvironment:(NSString *)environment {
//    self.environment = environment;
      [PayPalMobile preconnectWithEnvironment:environment];
}

-(void)loginInPaypal:(id)selfVC{
    selfController=selfVC;
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:self.courseAmount];
    payment.currencyCode = @"GBP";
    payment.shortDescription = self.desc;
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    // Create a PayPalPaymentViewController.
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfig
                                                                        delegate:self];
    
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
     [selfController presentViewController:paymentViewController animated:YES completion:nil];
 }

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [selfController dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
     [_delegate paymentCanceled];
    [selfController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    [_delegate paymentSuccess:completedPayment];
}

#pragma mark - Helpers

- (void)showSuccess {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    [UIView commitAnimations];
}

#pragma mark - Flipside View Controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushSettings"]) {
        [[segue destinationViewController] setDelegate:(id)self];
    }
}

@end
