#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (Extension)

-(void)handleNullValue {
    NSArray *keys = [self allKeys];
    for (NSInteger i = 0; i < [keys count]; i++) {
        NSString *value = [self objectForKey:[keys objectAtIndex:i]];
        if (!value || [value isKindOfClass:[NSNull class]]) {
            value = @"";
            [self setObject:value forKey:[keys objectAtIndex:i]];
        }
    }
}

@end
