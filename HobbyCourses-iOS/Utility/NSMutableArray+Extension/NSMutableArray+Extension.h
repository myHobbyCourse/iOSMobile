#import <Foundation/Foundation.h>

@interface NSMutableArray (Extension)

- (NSMutableArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;
- (void)handleNullValue;
-(void)handleNullValueString;
@end
