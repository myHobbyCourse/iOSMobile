//
//  PayPalManager.h
//  FresHeads
//
//  Created by SiplMacMini4 on 08/12/15.
//  Copyright © 2015 Systematix Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalMobile.h"

@protocol PaypalPaymentBlockDelegate <NSObject>

@required
-(void)paymentSuccess:(PayPalPayment *)confirmationID;
-(void)paymentCanceled;
-(void)paymentFailed:(NSString *)failedID;

@end

@interface PayPalManager : NSObject<PayPalPaymentDelegate>{
    id  selfController;
}

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(strong, nonatomic) id <PaypalPaymentBlockDelegate> delegate;


@property(nonatomic, strong, readwrite) NSString *courseAmount;
@property(nonatomic, strong, readwrite) NSString *desc;


+ (PayPalManager*)getInstance;

-(void)setupPaypal;

-(void)loginInPaypal:(id)selfVC;

@end
