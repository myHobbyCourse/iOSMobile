//
//  PaymentAddressVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 04/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentAddressVC : ParentViewController

@property(strong,nonatomic) User *userAddress;
@property(nonatomic,strong) NSMutableDictionary * dict;
@property(strong,nonatomic) NSMutableArray* arrData;

@property (nonatomic, strong) CommonBlock refreshBlock;
-(void) getCommonBlock:(CommonBlock)refreshBlock;


@end
