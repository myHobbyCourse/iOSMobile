//
//  ValidationToast.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 14/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidationToast : UIView
@property(nonatomic,weak)  IBOutlet UILabel * messageLabel;
@property(nonatomic,weak)  IBOutlet NSLayoutConstraint *animatingViewBottomConstraint;
@property(nonatomic,weak) IBOutlet UIView *animatingView;

+(ValidationToast*) showBarMessage:(NSString*)message inView:(UIView*) view withColor:(UIColor*)color autoClose:(BOOL) flag;
@end
