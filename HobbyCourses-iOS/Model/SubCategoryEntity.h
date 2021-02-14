//
//  SubCategoryEntity.h
//
//  Created by   on 12/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SubCategoryEntity : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *subCategory;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *course_count;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
