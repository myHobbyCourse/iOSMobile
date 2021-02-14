//
//  StudeInfo.m
//  HobbyCourses
//
//  Created by iOS Dev on 12/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "StudeInfo.h"

@implementation StudeInfo
@synthesize viewPop;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(StudeInfo*) instanceFromNib:(NSArray*)arrInfo controller:(UIViewController*) view {
    
    StudeInfo *instace = [[[UINib nibWithNibName:@"StudentInfo" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:(is_iPad()) ? 1 : 0];
    instace.frame = CGRectMake(0, 0, _screenSize.width, _screenSize.height);
    [instace layoutIfNeeded];
    instace.lblUsename.text = arrInfo[0];
    instace.lblName.text =  arrInfo[1];
    instace.lblEmail.text = arrInfo[2];
    instace.lblComment.text = arrInfo[3];

    [instace.imgV sd_setImageWithURL:[NSURL URLWithString:arrInfo[4]] placeholderImage:_placeHolderImg];
    instace.imgV.layer.cornerRadius = instace.imgV.frame.size.width/2;
    instace.imgV.layer.masksToBounds = true;
    instace.viewPop.layer.cornerRadius = 10;
    instace.viewPop.layer.masksToBounds = true;
    instace.viewPop.layer.borderWidth = 1;
    instace.viewPop.layer.borderColor = __THEME_GRAY.CGColor;
    
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
