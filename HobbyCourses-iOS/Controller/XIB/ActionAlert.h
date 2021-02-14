//
//  ActionAlert.h
//  HobbyCourses
//
//  Created by iOS Dev on 13/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TappedOkay,
    TappedDismiss,
    TappedClose,

}Tapped;

@class ActionAlert;
typedef void (^ActionBlock)(Tapped tapped,id alert);
@interface ActionAlert : ConstrainedView

@property (nonatomic, strong) IBOutlet UIButton *btnOkay;
@property (nonatomic, strong) IBOutlet UIButton *btnDismiss;
@property (nonatomic, strong) IBOutlet UIButton *btnSingle;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblMessage;
@property (nonatomic, strong) IBOutlet UIView *viewPop;
@property (nonatomic, strong) ActionBlock actionBlock;

+(ActionAlert*) instanceFromNib:(NSString*)title withMessage:(NSString*) message bgColor:(UIColor*) color button:(NSArray*) btnTitles controller:(UIViewController*) view block:(void(^)(Tapped tapped,id alert)) handler;
@end
