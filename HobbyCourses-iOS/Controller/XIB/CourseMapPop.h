//
//  CourseMapPop.h
//  HobbyCourses
//
//  Created by iOS Dev on 08/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ActionAlert;


@interface CourseMapPop : ConstrainedView

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblTitleFull;
@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) IBOutlet UIView *viewPop;
@property (nonatomic, strong) IBOutlet UIView *viewContainer;
@property (nonatomic, strong) IBOutlet UIButton *btnDirection;
@property (nonatomic, strong) ActionBlock actionBlock;

+(CourseMapPop*) instanceFromNib:(NSString*)title withMessage:(NSString*) message controller:(UIViewController*) view block:(void(^)(Tapped tapped,id alert)) handler;

@end