//
//  BatchTimeAlert.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "BatchTimeAlert.h"

@implementation BatchTimeAlert
@synthesize viewPop;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(BatchTimeAlert*) instanceFromNib:(NSString*)title withDate:(NSString*) date bgColor:(UIColor*) color time:(NSArray*) Times controller:(UIViewController*) view{
    
    BatchTimeAlert *instace = [[[UINib nibWithNibName:@"BatchTime" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    instace.frame = CGRectMake(0, 0, _screenSize.width, _screenSize.height);
    [instace layoutIfNeeded];
    instace.lblStart.text = Times[0];
    instace.lblEnd.text =  Times[1];
    instace.lblStart.layer.cornerRadius = 5;
    instace.lblStart.layer.masksToBounds = true;
    instace.lblEnd.layer.cornerRadius = 5;
    instace.lblEnd.layer.masksToBounds = true;
    instace.lblTitle.text = title;
    instace.lblDate.text = date;
    instace.viewPop.backgroundColor = color;
    instace.viewPop.layer.cornerRadius = 10;
    instace.viewPop.layer.masksToBounds = true;
    instace.viewPop.transform = CGAffineTransformIdentity;
    [instace animateIn:0.2 delay:0.0 completion:^{
    }];
    return instace;
}
-(IBAction)didTapDismiss:(UIButton*)sender{
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
