#import "NSMutableArray+Extension.h"

@implementation NSMutableArray (Extension)

-(void)handleNullValue {
    for (NSInteger j = 0; j < [self count]; j++) {
        NSMutableDictionary *dictionary = [self objectAtIndex:j];
        NSArray *keys = [dictionary allKeys];
        for (NSInteger i = 0; i < [keys count]; i++) {
            NSString *value = [dictionary objectForKey:[keys objectAtIndex:i]];
            if (!value || [value isKindOfClass:[NSNull class]]) {
                value = @"";
                [dictionary setObject:value forKey:[keys objectAtIndex:i]];
            }
        }
        [self replaceObjectAtIndex:j withObject:dictionary];
    }
}
-(void)handleNullValueString {
    for (NSInteger j = 0; j < [self count]; j++) {
        NSString *dictionary = [self objectAtIndex:j];
        if (_isStringEmpty(dictionary)) {
            [self replaceObjectAtIndex:j withObject:@""];
        }else{
            [self replaceObjectAtIndex:j withObject:dictionary];
        }
    }
}

- (NSMutableArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}
@end



