//
//  TutorsEntity.h
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TutorsEntity : NSObject

@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *imagePath;
@property(strong,nonatomic) NSString *tutor_details;
@property(strong,nonatomic) NSString *tutor_name;
@property(strong,nonatomic) NSString *tutor_id;
@property(strong,nonatomic) NSString *tutor_nid;
@property(strong,nonatomic) NSMutableArray *arrImgaes;
@property(strong,nonatomic) UIImage *imgV;

@property(nonatomic,strong) NSString *address;
@property(nonatomic,retain) NSString *city;
@property(nonatomic,strong) NSString *pincode;
@property(nonatomic,strong) NSString *country;


- (id) initWith:(NSMutableDictionary*)dict;

@end
