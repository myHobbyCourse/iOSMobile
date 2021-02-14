//
//  CategoryEntity.m
//
//  Created by   on 12/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "CategoryEntity.h"
#import "SubCategoryEntity.h"


NSString *const kCategoryEntityTid = @"tid";
NSString *const kCategoryEntityCategory = @"category";
NSString *const kCategoryEntitySubCategories = @"sub_categories";
NSString *const kCategoryEntityimage = @"image";

@interface CategoryEntity ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CategoryEntity

@synthesize tid = _tid;
@synthesize category = _category;
@synthesize subCategories = _subCategories;
@synthesize image = _image;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.tid = [self objectOrNilForKey:kCategoryEntityTid fromDictionary:dict];
        self.category = [self objectOrNilForKey:kCategoryEntityCategory fromDictionary:dict];
        self.image = [self objectOrNilForKey:kCategoryEntityimage fromDictionary:dict];
        NSObject *receivedSubCategories = [dict objectForKey:kCategoryEntitySubCategories];
        NSMutableArray *parsedSubCategories = [NSMutableArray array];
        if ([receivedSubCategories isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedSubCategories) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedSubCategories addObject:[SubCategoryEntity modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedSubCategories isKindOfClass:[NSDictionary class]]) {
            [parsedSubCategories addObject:[SubCategoryEntity modelObjectWithDictionary:(NSDictionary *)receivedSubCategories]];
        }
        
        self.subCategories = [NSArray arrayWithArray:parsedSubCategories];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.tid forKey:kCategoryEntityTid];
    [mutableDict setValue:self.category forKey:kCategoryEntityCategory];
    [mutableDict setValue:self.image forKey:kCategoryEntityimage];
    NSMutableArray *tempArrayForSubCategories = [NSMutableArray array];
    for (NSObject *subArrayObject in self.subCategories) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSubCategories addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSubCategories addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSubCategories] forKey:kCategoryEntitySubCategories];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.tid = [aDecoder decodeObjectForKey:kCategoryEntityTid];
    self.category = [aDecoder decodeObjectForKey:kCategoryEntityCategory];
    self.image = [aDecoder decodeObjectForKey:kCategoryEntityimage];
    self.subCategories = [aDecoder decodeObjectForKey:kCategoryEntitySubCategories];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_tid forKey:kCategoryEntityTid];
    [aCoder encodeObject:_category forKey:kCategoryEntityCategory];
    [aCoder encodeObject:_image forKey:kCategoryEntityimage];
    [aCoder encodeObject:_subCategories forKey:kCategoryEntitySubCategories];
}

- (id)copyWithZone:(NSZone *)zone
{
    CategoryEntity *copy = [[CategoryEntity alloc] init];
    
    if (copy) {
        
        copy.tid = [self.tid copyWithZone:zone];
        copy.category = [self.category copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
        copy.subCategories = [self.subCategories copyWithZone:zone];
    }
    
    return copy;
}


@end
