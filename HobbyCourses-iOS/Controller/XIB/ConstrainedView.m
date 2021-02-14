//
//  ConstrainedView.m
//  HobbyCourses
//
//  Created by iOS Dev on 13/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ConstrainedView.h"

@implementation ConstrainedView
@synthesize horizontalConstraints,verticalConstraints;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self constraintUpdate];
    // Initialization code
}
-(void) constraintUpdate{
    if (horizontalConstraints) {
        for (NSLayoutConstraint * v1 in horizontalConstraints) {
            CGFloat v2 = v1.constant * _widthRatio;
            v1.constant = v2;
        }
    }
    if (verticalConstraints) {
        for (NSLayoutConstraint * v1 in verticalConstraints) {
            CGFloat v2 = v1.constant * _heighRatio;
            v1.constant = v2;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
