//
//  Amenities.h
//  HobbyCourses
//
//  Created by iOS Dev on 19/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Amenities : NSObject

@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * imgUrl;
- (id) initWith:(NSDictionary*)dict;
-(NSURL *) getUrl;
@end
