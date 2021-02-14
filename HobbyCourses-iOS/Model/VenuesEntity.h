//
//  VenuesEntity.h
//  HobbyCourses
//
//  Created by iOS Dev on 17/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenuesEntity : NSObject

@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *imagePath;
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *longitude;
@property(strong,nonatomic) NSString *venue_details;
@property(strong,nonatomic) NSString *location;
@property(strong,nonatomic) NSString *venue_name;
@property(strong,nonatomic) NSString *venue_id;
@property(strong,nonatomic) NSMutableArray *arrImgaes;
@property(strong,nonatomic) UIImage *imgV;


@property(nonatomic,strong) NSString *address;
@property(nonatomic,retain) NSString *address1;
@property(nonatomic,strong) NSString *pincode;
@property(nonatomic,strong) NSString *country;



- (id) initWith:(NSMutableDictionary*)dict;

@end
