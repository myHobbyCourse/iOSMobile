//
//  UserDetail.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 06/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetail : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString * address,*address_2;
@property(strong,nonatomic) NSString *company_name;
@property(strong,nonatomic) NSString * created;
@property(strong,nonatomic) NSDate * createdDate;
@property(strong,nonatomic) NSString * uid;
@property(strong,nonatomic) NSString * user_picture;
@property(strong,nonatomic) NSString * company_number;
@property(strong,nonatomic) NSString * mail;
@property(strong,nonatomic) NSString * first_name;
@property(strong,nonatomic) NSString * landline_numbe;
@property(strong,nonatomic) NSString * last_name;
@property(strong,nonatomic) NSString * website;
@property(strong,nonatomic) NSString * mobile;
@property(strong,nonatomic) NSString * postal_code;
@property(strong,nonatomic) NSString * gender;
@property(strong,nonatomic) NSString * birthDate;
@property(strong,nonatomic) NSString * city;
@property(strong,nonatomic) NSString *field_vat_registration_number;
@property(strong,nonatomic) NSString *educator_introduction;
@property(strong,nonatomic) NSString *offerCode;
@property(strong,nonatomic) NSString *reference;

@property(strong,nonatomic) NSString *landline_verified_flagged;
@property(strong,nonatomic) NSString *social_media_verified_flagged;
@property(strong,nonatomic) NSString *credit_card_verified_flagged;
@property(strong,nonatomic) NSString *address_verified_flagged;
@property(strong,nonatomic) NSString *mobile_verified_flagged;
@property(strong,nonatomic) NSString *email_verified_flagged;
@property(strong,nonatomic) NSString *qr_code;

@property(strong,nonatomic) NSMutableArray *hobbies;
@property(strong,nonatomic) NSMutableArray *hobbiesIds;

@property(strong,nonatomic) UIImage *userProfile;


@property(assign) bool isBasic;
@property(assign) bool isProfilePic;
@property(assign) bool isContact;
@property(assign) bool isAddress;
@property(assign) bool isHooby;
@property(assign) bool isCompany;


@property(assign) bool isChangePic;

- (id) initWith:(NSDictionary*)dict ;
-(void) updateSectionStatus;
-(void) getProfileSatus;
@end
