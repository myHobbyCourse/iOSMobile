//
//  ActivityHud.h
//  HobbyCourses
//
//  Created by iOS Dev on 06/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ActivityHud : ConstrainedView
@property (nonatomic, strong) IBOutlet UIImageView *imgV;
@property (nonatomic, strong) IBOutlet UIView *viewBG;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *_widthConstraint;

+(ActivityHud*) instanceFromNib:(UIColor*) color Controller:(UIViewController*) view;
-(void) configure;
@end
