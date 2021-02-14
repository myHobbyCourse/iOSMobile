//
//  User.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong)   NSString*       photo;
@property (nonatomic)           BOOL            isOnline;

@property (nonatomic, strong)   NSString* sessid;
@property (nonatomic, strong)   NSString* session_name;
@property (nonatomic, strong)   NSString* token;
@property (nonatomic, strong)   NSString *uid;

@property (nonatomic, strong)   NSString* name;
@property (nonatomic, strong)   NSString* mail;
@property (nonatomic, strong)   NSString* theme;
@property (nonatomic, strong)   NSString* signature;
@property (nonatomic, strong)   NSString* signature_format;
@property (nonatomic, strong)   NSString* created;
@property (nonatomic, strong)   NSString* access;
@property (nonatomic, strong)  NSString* login;
@property (nonatomic, strong)   NSString* status;
@property (nonatomic, strong)   NSString* timezone;
@property (nonatomic, strong) NSString* language;
@property (nonatomic, strong) NSString*  picture;
@property (nonatomic, strong) NSString*  uuid;

@property (nonatomic, strong) NSString* authenticated;
@property (nonatomic, strong) NSString* rolesUser;
@property (nonatomic, strong) NSString* rolesVendor;
@property (nonatomic, strong) NSString*  field_company_name;
@property (nonatomic, strong) NSString*  field_description;
@property (nonatomic, strong) NSString*  field_phone;
@property (nonatomic, strong) NSString*  field_site;
@property (nonatomic, strong) NSString*  field_vendor_image;
@property (nonatomic, strong) NSString*  field_vendor_rating;
@property (nonatomic, strong) NSString*  field_first_name;
@property (nonatomic, strong) NSString*  field_last_name;
@property (nonatomic, strong) NSString*  field_address;
@property (nonatomic, strong) NSString*  field_city;
@property (nonatomic, strong) NSString*  field_country;
@property (nonatomic, strong) NSString*  field_postal_code;
@property (nonatomic, strong) NSString*  field_customer_or_educator;
@property (nonatomic, strong) NSString*  field_landline_number;
@property (nonatomic, strong) NSString*  field_company_number;
@property (nonatomic, strong) NSString*  field_vat_registration_number;
@property (nonatomic, strong) NSString*  field_address_2;
@property (nonatomic, strong) NSString*  cache;
@property (nonatomic, strong) NSString*  privatemsg_disabled;
@property (assign) BOOL isVendor;
@property (assign) BOOL isHourlyTutor;
@property (assign) BOOL isStudent;
- (id) initWith:(NSDictionary *)dict;
@end
