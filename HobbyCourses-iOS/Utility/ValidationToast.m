//
//  ValidationToast.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 14/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ValidationToast.h"

@implementation ValidationToast

typedef void(^myCompletion)();

// MARK: - Initialisers



+(ValidationToast*) showBarMessage:(NSString*)message inView:(UIView*) view withColor:(UIColor*)color autoClose:(BOOL) flag  {
    ValidationToast *toast = [[[UINib nibWithNibName:@"ValidationToastBar" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    toast.animatingViewBottomConstraint.constant = 44;
    [toast layoutIfNeeded];
    [toast setToastMessage:message];
    toast.animatingView.backgroundColor = color;
    [view.window addSubview:toast];
    CGRect f = view.frame;
    f.size.height = 64;
    f.origin = CGPointZero;
    f.origin.y = 44;
    toast.frame = f;
    if (flag) {
        [toast animateIn:0.2 delay:0.2 completion:^{
            [toast animateOut:0.2 delay:2.5 completion:^{
                [toast removeFromSuperview];
            }];
        }];
    }else{
        [toast animateIn:0.2 delay:0.2 completion:^{
        }];
    }
    return toast;
}


// MARK: - Toast Functions
-(void) setToastMessage:(NSString*)message {
    self.messageLabel.text = message;
    if (is_iPad()) {
        self.messageLabel.font = [UIFont systemFontOfSize:17.0f];
    }
}

-(void) animateIn:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(myCompletion) compblock{
    self.animatingViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        compblock();
    }];
}

-(void) animateOut:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(myCompletion) compblock{
    self.animatingViewBottomConstraint.constant = 44;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        compblock();
    }];
}
-(IBAction)btnCloseToast:(UIButton*)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
