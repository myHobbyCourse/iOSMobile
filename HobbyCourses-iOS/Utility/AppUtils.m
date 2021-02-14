//
//  AppUtils.m
//  HobbyCourses-iOS
//
//  Created by Kirit on 13/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils

+ (NSString *) convertImageToBase64:(UIImage*)image{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    return [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
+(void) actionWithMessage:(NSString*) tittle withMessage:(NSString*) message alertType:(UIAlertControllerStyle) type button:(NSArray*) buttons controller:(UIViewController*) view block:(void (^) (NSString* tapped)) handler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:type];
    
    for (NSString* btn in buttons) {
        [alert addAction:[UIAlertAction actionWithTitle:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler(btn);
        }]];
    }
    if (type == UIAlertControllerStyleActionSheet){
        [alert addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDestructive handler:nil]];
    }else{
        [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:nil]];
    }
    [view presentViewController:alert animated:true completion:nil];
}

+ (BOOL)textValidation:(UITextField *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(int)length withSpecialChars:(BOOL)specialChars
{
    NSCharacterSet *cs;
    NSUInteger newLength = [textView.text length] + [string length] - range.length;
    if(specialChars)
        cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_ALPHANUMERICS] invertedSet];
    else
        cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_ALPHANUMERICS_2] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return ( ([string isEqualToString:filtered]) && (newLength <= length) );
}
+ (BOOL)stringOnlyValidation:(UITextField *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(int)length withSpace:(BOOL) space
{
    NSUInteger newLength = [textView.text length] + [string length] - range.length;
    NSCharacterSet *cs;
    if(space)
        cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_STRING_SPACE] invertedSet];
    else
        cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_STRING_NOSPACE] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return ( ([string isEqualToString:filtered]) && (newLength <= length) );
}

+ (BOOL)txtLengthValidation:(UITextField *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(int)length {
    NSUInteger newLength = [textView.text length] + [string length] - range.length;
    return newLength <= length;
}


+ (BOOL)numericValidation:(UITextField *)textField range:(NSRange)range string:(NSString *)string length:(int)length withFloat:(BOOL)flag
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(flag && (newLength <= length))
    {
        NSError *error;
        NSRegularExpression * regExp = [[NSRegularExpression alloc] initWithPattern:@"^\\d{0,25}(([.]\\d{1,2})|([.]))?$" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString * completeText = [textField.text stringByAppendingFormat:@"%@",string];
        if ([regExp numberOfMatchesInString:completeText options:0 range:NSMakeRange(0, [completeText length])])
        {
            if ([completeText isEqualToString:@"."])
                [textField insertText:@"0"];
            return YES;
        }
        else
            return NO;
    }
    else
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return ( ([string isEqualToString:filtered]) && (newLength <= length) );
    }
}

+ (BOOL)checkStringValue:(NSString *)string
{
    @try
    {
        if ([string isEqualToString:@""] || string.length == 0 || string == nil || string == Nil || string == NULL ||
            [string isEqual:[NSNull null]] || [string isEqualToString:@"null"] ||
            [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            return TRUE;
        }
        else
            return FALSE;
    }
    @catch(NSException *exception)
    {
        return TRUE;
        HCLog(@"Unhandled Null Found");
    }
}

+(NSMutableAttributedString*) getAttributeString:(NSString*)value withFont:(UIFont*) font withColor:(UIColor*) color{
    NSMutableAttributedString *mutatingAttributedString = [[NSMutableAttributedString alloc] initWithString:value];
    [mutatingAttributedString addAttribute:NSForegroundColorAttributeName value:font range:NSMakeRange(0,value.length)];
    [mutatingAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,value.length)];
    return mutatingAttributedString;
}
@end
