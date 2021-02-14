//
//  NSString+StringExtension.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 19/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "NSString+StringExtension.h"

@implementation NSString (StringExtension)

-(NSString*) tringString
{
    return [self stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceCharacterSet]];
}
-(NSString*) getVideoThumURL{
    return [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",self];
}


-(NSString*) removeNull
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (self == nil) {
        return @"";
    }
    return self;
}
-(NSString *) removeHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}
-(CGRect) getStringHeight:(CGFloat) width font:(UIFont*) font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize constraintRect = CGSizeMake(width, CGFLOAT_MAX);
    return  [self boundingRectWithSize:constraintRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}
-(NSString*) removeSymbols{
    return  [self stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
}

@end
