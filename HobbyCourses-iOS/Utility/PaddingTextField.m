//
//  PaddingTextField.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 19/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PaddingTextField.h"

@implementation PaddingTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{

    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{

    return CGRectInset(bounds, 10, 10);
}
- (void) drawPlaceholderInRect:(CGRect)rect {
    
    UIColor *colour = [UIColor darkGrayColor];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: colour, NSFontAttributeName: self.font};
    CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
    [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2)-boundingRect.size.height/2) withAttributes:attributes];
}

@end
