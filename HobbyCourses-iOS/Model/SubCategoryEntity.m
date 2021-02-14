//
//  SubCategoryEntity.m
//
//  Created by   on 12/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SubCategoryEntity.h"


NSString *const kSubCategoriesTid = @"tid";
NSString *const kSubCategoriesSubCategory = @"sub_category";
NSString *const kSubCategoriesImage = @"image";
NSString *const kSubCategoriesCount = @"course_count";

@interface SubCategoryEntity ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SubCategoryEntity

@synthesize tid = _tid;
@synthesize subCategory = _subCategory;
@synthesize image = _image;
@synthesize course_count = _course_count;

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
            self.tid = [self objectOrNilForKey:kSubCategoriesTid fromDictionary:dict];
            self.subCategory = [self objectOrNilForKey:kSubCategoriesSubCategory fromDictionary:dict];
            self.image = [self objectOrNilForKey:kSubCategoriesImage fromDictionary:dict];
         self.course_count = [self objectOrNilForKey:kSubCategoriesCount fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.tid forKey:kSubCategoriesTid];
    [mutableDict setValue:self.subCategory forKey:kSubCategoriesSubCategory];
    [mutableDict setValue:self.image forKey:kSubCategoriesImage];
    [mutableDict setValue:self.course_count forKey:kSubCategoriesCount];

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

    self.tid = [aDecoder decodeObjectForKey:kSubCategoriesTid];
    self.subCategory = [aDecoder decodeObjectForKey:kSubCategoriesSubCategory];
    self.image = [aDecoder decodeObjectForKey:kSubCategoriesImage];
    self.course_count = [aDecoder decodeObjectForKey:kSubCategoriesCount];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_tid forKey:kSubCategoriesTid];
    [aCoder encodeObject:_subCategory forKey:kSubCategoriesSubCategory];
    [aCoder encodeObject:_image forKey:kSubCategoriesImage];
    [aCoder encodeObject:_course_count forKey:kSubCategoriesCount];

}

- (id)copyWithZone:(NSZone *)zone
{
    SubCategoryEntity *copy = [[SubCategoryEntity alloc] init];
    
    if (copy) {

        copy.tid = [self.tid copyWithZone:zone];
        copy.subCategory = [self.subCategory copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
        copy.course_count = [self.course_count copyWithZone:zone];

    }
    
    return copy;
}


@end
