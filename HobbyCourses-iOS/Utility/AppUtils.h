//
//  AppUtils.h
//  HobbyCourses-iOS
//
//  Created by Kirit on 13/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#define _isStringEmpty(v)       [AppUtils checkStringValue:v]
#define ACCEPTABLE_NUMBERS          @"0123456789"
#define ACCEPTABLE_STRING           @"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz"
#define ACCEPTABLE_ALPHANUMERICS    @"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz0123456789,./-"
#define ACCEPTABLE_ALPHANUMERICS_2  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_STRING_SPACE  @" ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_STRING_NOSPACE  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


@interface AppUtils : NSObject

+ (NSString *) convertImageToBase64:(UIImage*)image;
+ (NSString*)daysBetweenCurrent:(NSDate*)toDateTime;
+(void) actionWithMessage:(NSString*) tittle withMessage:(NSString*) message alertType:(UIAlertControllerStyle) type button:(NSArray*) buttons controller:(UIViewController*) view block:(void (^) (NSString* tapped)) handler;
+(NSMutableAttributedString*) getAttributeString:(NSString*)value withFont:(UIFont*) font withColor:(UIColor*) color;
+ (BOOL)checkStringValue:(NSString *)string;
+ (BOOL)txtLengthValidation:(UITextField *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(int)length;
+ (BOOL)textValidation:(UITextField *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(int)length withSpecialChars:(BOOL)specialChars;
+ (BOOL)stringOnlyValidation:(UITextField *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(int)length withSpace:(BOOL) space;
+ (BOOL)numericValidation:(UITextField *)textField range:(NSRange)range string:(NSString *)string length:(int)length withFloat:(BOOL)flag;

@end
