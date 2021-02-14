//
//  ImageUtility.m
//  Busybee
//
//  Created by User on 4/7/15.
//  Copyright (c) 2015 Luoyan. All rights reserved.
//

#import "ImageUtility.h"

@implementation ImageUtility

+ (UIImage*) imageWithImage:(UIImage*) image scaledToSize:(CGSize) newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
