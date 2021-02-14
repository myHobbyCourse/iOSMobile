//
//  CourseMapPop.m
//  HobbyCourses
//
//  Created by iOS Dev on 08/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseMapPop.h"
typedef void(^myCompletion)();
@class ActionAlert;

@implementation CourseMapPop
@synthesize viewPop,viewContainer;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(CourseMapPop*) instanceFromNib:(NSString*)title withMessage:(NSString*) message controller:(UIViewController*) view block:(void(^)(Tapped tapped,id alert)) handler{
    CourseMapPop *instace = [[[UINib nibWithNibName:@"CourseMapPop" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:(is_iPad()) ? 1 : 0];
    instace.frame = CGRectMake(0, 0, _screenSize.width, _screenSize.height);
    [instace layoutIfNeeded];
    instace.lblTitle.text = title;
    instace.lblTitleFull.text = title;
    instace.lblMessage.text = message;
    instace.actionBlock = handler;
    instace.viewPop.layer.cornerRadius = 10;
    instace.viewPop.layer.masksToBounds = true;
    instace.viewPop.layer.shadowOffset = CGSizeMake(0, 3);
    instace.viewPop.layer.borderColor = __THEME_GRAY.CGColor;
    instace.btnDirection.layer.borderWidth = 1;
    instace.btnDirection.layer.borderColor = [UIColor whiteColor].CGColor;
    instace.viewContainer.layer.cornerRadius = 10;
    instace.viewContainer.layer.masksToBounds = true;

    instace.viewPop.transform = CGAffineTransformIdentity;
    [instace animateIn:0.2 delay:0.0 completion:^{
    }];
    return instace;
}
-(IBAction)didTapDismiss:(UIButton*)sender{
    self.actionBlock(TappedDismiss,self);
}
-(IBAction)didTapDirector:(UIButton*)sender{
    self.actionBlock(TappedOkay,self);
}
-(IBAction)closePop:(UIButton*)sender{
    [self removeFromSuperview];
}
// MARK: - Toast Functions
-(void) animateIn:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(myCompletion) compblock{
    viewPop.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        viewPop.transform = CGAffineTransformIdentity;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        compblock();
    }];
}

-(void) animateOut:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(myCompletion) compblock{
    viewPop.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        viewPop.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        compblock();
    }];
}
@end
