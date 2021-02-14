//
//  PaymentOptionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 03/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PaymentOptionVC.h"
#import "Braintree3DSecure.h"

@interface PaymentOptionVC (){
    IBOutlet UIView *vPayButton;
}

@end

@implementation PaymentOptionVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]]) {
        UIButton *button = [self applePayButton];
        // TODO: Add button to view and set its constraints/frame...
        button.frame = vPayButton.bounds;
        [vPayButton addSubview:button];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Payment option Screen"];
}

- (UIButton *)applePayButton {
    UIButton * button = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
    [button addTarget:self action:@selector(tappedApplePay) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (IBAction)tappedApplePay {
    
    _refreshBlock(@"2");
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(IBAction)btnSelectionPaymentType:(UIButton*)sender{
    if (sender.tag == 11) {
        //Paypal
        _refreshBlock(@"0");
    }else{
        //Bank
        _refreshBlock(@"1");

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
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
