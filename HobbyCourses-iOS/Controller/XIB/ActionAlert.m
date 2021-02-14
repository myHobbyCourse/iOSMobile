//
//  ActionAlert.m
//  HobbyCourses
//
//  Created by iOS Dev on 13/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ActionAlert.h"
typedef void(^myCompletion)();
@implementation ActionAlert
@synthesize viewPop;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(ActionAlert*) instanceFromNib:(NSString*)title withMessage:(NSString*) message bgColor:(UIColor*) color button:(NSArray*) btnTitles controller:(UIViewController*) view block:(void(^)(Tapped tapped,id alert)) handler{
    
    ActionAlert *instace = [[[UINib nibWithNibName:@"Alert" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:(is_iPad()) ? 1 : 0];
    instace.frame = CGRectMake(0, 0, _screenSize.width, _screenSize.height);
    [instace layoutIfNeeded];
    if (btnTitles.count == 1) {
        instace.btnSingle.hidden = false;
        [instace.btnSingle setTitle:btnTitles[0] forState:UIControlStateNormal];
    }else{
        [instace.btnOkay setTitle:btnTitles[0] forState:UIControlStateNormal];
        [instace.btnDismiss setTitle:btnTitles[1] forState:UIControlStateNormal];
    }

    instace.btnOkay.layer.cornerRadius = 5;
    instace.btnOkay.layer.masksToBounds = true;
    instace.btnDismiss.layer.cornerRadius = 5;
    instace.btnDismiss.layer.masksToBounds = true;
    instace.lblTitle.text = title;
    instace.lblMessage.text = message;
    instace.actionBlock = handler;
    instace.viewPop.backgroundColor = color;
    instace.viewPop.layer.cornerRadius = 10;
    instace.viewPop.layer.masksToBounds = true;
    instace.viewPop.transform = CGAffineTransformIdentity;
    [instace animateIn:0.2 delay:0.0 completion:^{
    }];
    return instace;
}
-(IBAction)didTapOkay:(UIButton*)sender{
    self.actionBlock(TappedOkay,self);
}
-(IBAction)didTapDismiss:(UIButton*)sender{
    self.actionBlock(TappedDismiss,self);
}
-(IBAction)didTapClose:(UIButton*)sender{
    self.actionBlock(TappedClose,self);
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
