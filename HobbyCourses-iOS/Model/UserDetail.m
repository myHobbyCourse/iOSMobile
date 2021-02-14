//
//  UserDetail.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 06/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "UserDetail.h"

@implementation UserDetail

- (id) initWith:(NSDictionary*)dict {
    self = [super init];
    if (self)
    {
        @try {
            
            self.name = dict[@"name"];
            self.address = dict[@"address"];
            self.company_name = dict[@"company_name"];
            self.created = dict[@"created_date"];
            if (self.created != nil || ![self.created isKindOfClass:[NSNull class]]) {
                self.created =  [globalDateOnlyFormatter() stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.created.integerValue]];
            }
        
            self.uid = dict[@"uid"];
            self.user_picture = dict[@"user_picture"];
            self.company_number =dict[@"company_number"];
            self.mail=dict[@"mail"];
            self.first_name = dict[@"first_name"];
            self.landline_numbe=dict[@"landline_number"];
            self.last_name=dict[@"last_name"];
            self.website=dict[@"website"];
            self.mobile=dict[@"mobile"];
            self.postal_code=dict[@"postal_code"];
            self.city=dict[@"city"];
            self.address_2 = dict[@"address2"];
            self.educator_introduction = dict[@"educator_introduction"];
            self.field_vat_registration_number = dict[@"field_vat_registration_number"];
            self.gender = dict[@"gender"];
            

            self.hobbiesIds = [NSMutableArray new];
            self.hobbies = [NSMutableArray new];

            if ([dict[@"hobbies"] isKindOfClass:[NSArray class]]) {
                NSMutableArray *d = [dict[@"hobbies"] mutableCopy];
                [d handleNullValue];
                for(NSDictionary *obj in d) {
                    [self.hobbiesIds addObject:obj[@"tid"]];
                    [self.hobbies addObject:obj[@"name"]];
                }
            }
            
            self.birthDate  = dict[@"date_of_birth"];
            
            self.landline_verified_flagged = dict[@"landline_verified_flagged"];
            self.social_media_verified_flagged = dict[@"social_media_verified_flagged"];
            self.credit_card_verified_flagged = dict[@"credit_card_verified_flagged"];
            self.address_verified_flagged = dict[@"address_verified_flagged"];
            self.mobile_verified_flagged = dict[@"mobile_verified_flagged"];
            self.email_verified_flagged = dict[@"email_verified_flagged"];
            self.qr_code = dict[@"qr_code"];
        }
        @catch (NSException *exception) { }
    }
    return self;
}

-(void) updateSectionStatus{
    if (_isStringEmpty(self.first_name) || _isStringEmpty(self.last_name) || _isStringEmpty(self.gender) || _isStringEmpty(self.birthDate)){
        self.isBasic = YES;
    }
    
    if (_isStringEmpty(self.user_picture)){
        self.isProfilePic = YES;
    }
    
    if (_isStringEmpty(self.mobile)){
        self.isContact = YES;
    }
    
    if (_isStringEmpty(self.city) || _isStringEmpty(self.postal_code)){
        self.isAddress = YES;
    }
    
    if (_isStringEmpty(self.company_name) || _isStringEmpty(self.company_number) || _isStringEmpty(self.field_vat_registration_number) || _isStringEmpty(self.website)){
        self.isCompany = YES;
    }
    
    
    if (self.hobbies.count == 0){
        self.isHooby = YES;
    }
}
-(void) getProfileSatus{
    APPDELEGATE.isOpenProfile = NO;
    if (APPDELEGATE.userCurrent.isVendor) {
        if (_isStringEmpty(self.name) || _isStringEmpty(self.created) || _isStringEmpty(self.user_picture) || _isStringEmpty(self.mail) || _isStringEmpty(self.first_name) || _isStringEmpty(self.last_name)  || _isStringEmpty(self.mobile)   || _isStringEmpty(self.postal_code)  || _isStringEmpty(self.city) || _isStringEmpty(self.gender) || _isStringEmpty(self.birthDate) || self.hobbies.count == 0) {
            APPDELEGATE.isOpenProfile = YES;
        }
        
    }else{
        if (_isStringEmpty(self.name) || _isStringEmpty(self.created) || _isStringEmpty(self.user_picture) || _isStringEmpty(self.mail) || _isStringEmpty(self.first_name) || _isStringEmpty(self.last_name) || _isStringEmpty(self.mobile)   || _isStringEmpty(self.postal_code)  || _isStringEmpty(self.city)  ||  _isStringEmpty(self.educator_introduction)|| _isStringEmpty(self.gender) || _isStringEmpty(self.birthDate) || self.hobbies.count == 0) {
            APPDELEGATE.isOpenProfile = YES;
        }
    }
}
@end
