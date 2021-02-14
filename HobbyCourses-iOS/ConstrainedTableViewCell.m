//
//  ConstrainedTableViewCell.m
//  AirbnbClone
//
//  Created by iOS Dev on 24/08/16.
//  Copyright © 2016 iOS Dev. All rights reserved.
//

#import "ConstrainedTableViewCell.h"

@implementation ConstrainedTableViewCell
@synthesize horizontalConstraints,verticalConstraints;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self constraintUpdate];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
@end

@implementation GenericTableViewCell

@end
