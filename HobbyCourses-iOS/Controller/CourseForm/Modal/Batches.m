//
//  Batches.m
//  HobbyCourses
//
//  Created by iOS Dev on 01/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "Batches.h"

@implementation Batches
@synthesize batchesTimes;
- (id)init
{
    self = [super init];
    if ( self )
    {
        batchesTimes = [NSMutableArray new];
//        self.sold = @"";
    }
    return self;
}
-(BOOL)isEqual:(id)object{
    Batches *obj = object;
    if ([self.startDate isEqualToString:obj.startDate]) {
        return true;
    }
    return false;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
    [encoder encodeObject:self.price forKey:@"price"];
//    [encoder encodeObject:self.sold forKey:@"sold"];
    [encoder encodeObject:self.sessions forKey:@"sessions"];
    [encoder encodeObject:self.discount forKey:@"discount"];
    [encoder encodeObject:self.batchesTimes forKey:@"batchesTimes"];
    [encoder encodeObject:self.batchID forKey:@"batchID"];
    [encoder encodeObject:self.batchID forKey:@"classSize"];

    

}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.startDate  = [decoder decodeObjectForKey:@"startDate"];
        self.endDate  = [decoder decodeObjectForKey:@"endDate"];
        self.price  = [decoder decodeObjectForKey:@"price"];
//        self.sold  = [decoder decodeObjectForKey:@"sold"];
        self.sessions  = [decoder decodeObjectForKey:@"sessions"];
        self.discount  = [decoder decodeObjectForKey:@"discount"];
        self.batchesTimes  = [decoder decodeObjectForKey:@"batchesTimes"];
        self.batchID  = [decoder decodeObjectForKey:@"batchID"];
        self.classSize  = [decoder decodeObjectForKey:@"classSize"];

    }
    return self;
}
@end
