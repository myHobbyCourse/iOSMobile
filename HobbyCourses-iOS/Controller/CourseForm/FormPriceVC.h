//
//  FormPriceVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormPriceVC : ParentViewController

@property (nonatomic, strong) NSString *price,*discount;

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
