//
//  ActivityHud.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ActivityHud.h"

@implementation ActivityHud


+(ActivityHud*) instanceFromNib:(UIColor*) color Controller:(UIViewController*) view {

    ActivityHud *instace = [[[UINib nibWithNibName:@"ActivityHud" bundle:nil] instantiateWithOwner:nil options:nil] objectAtIndex:0];
    instace.frame = CGRectMake(0, 0, _screenSize.width, _screenSize.height);
    instace.viewBG.backgroundColor = color;
    instace.viewBG.layer.cornerRadius = 10;
    instace.viewBG.layer.masksToBounds = true;
    instace.viewBG.transform = CGAffineTransformIdentity;
    [instace configure];
    [instace layoutIfNeeded];

    if (is_iPad()) {
        instace._widthConstraint.constant = _screenSize.width*0.08;
    }else{
        instace._widthConstraint.constant = _screenSize.width*0.25;
    }

    return instace;
}

-(void) configure {
    self.imgV.animationImages=[NSArray arrayWithObjects:
                               [UIImage imageNamed:@"ic_h1"],
                               [UIImage imageNamed:@"ic_h2"],
                               [UIImage imageNamed:@"ic_h3"],
                               [UIImage imageNamed:@"ic_h4"],
                               [UIImage imageNamed:@"ic_h5"],
                               [UIImage imageNamed:@"ic_h6"],
                               [UIImage imageNamed:@"ic_h7"],

                                                            nil];
    
    self.imgV.animationDuration = 7.0;
    self.imgV.animationRepeatCount = 0;
    [self.imgV startAnimating];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.duration = 1.3;
    [self.imgV.layer addAnimation:animation forKey:@"rotation"];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / 500.0;
    self.imgV.layer.transform = transform;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
