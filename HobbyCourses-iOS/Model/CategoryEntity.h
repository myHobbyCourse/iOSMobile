//
//  CategoryEntity.h
//
//  Created by   on 12/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CategoryEntity : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSArray *subCategories;
@property (nonatomic, strong) NSString *image;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
