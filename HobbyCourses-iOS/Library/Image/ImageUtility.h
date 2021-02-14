//
//  ImageUtility.h
//  Busybee
//
//  Created by User on 4/7/15.
//  Copyright (c) 2015 Luoyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUtility : NSObject

+ (UIImage*) imageWithImage:(UIImage*) image scaledToSize:(CGSize) newSize;

@end
