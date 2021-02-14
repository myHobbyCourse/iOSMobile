//
//  BankTransferVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 09/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankTransferVC : ParentViewController{
    IBOutlet UIButton *btnComplate;
    IBOutlet UIButton *btnBack;
    IBOutlet UIView *viewHeader;
    
}

@property(nonatomic,strong) NSString *transfer_ref;
@property(assign) BOOL isViewMode;

@end
