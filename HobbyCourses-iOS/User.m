//
//  User.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize name, photo, isOnline;

- (id) initWith:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        @try
        {
            self.sessid = dict[@"sessid"];
            self.session_name = dict[@"session_name"];
            self.token = dict[@"token"];
            NSDictionary *userDict = dict[@"user"];
            self.field_address = [self valueFromDeep:userDict[@"field_address"]];
            self.field_address_2 = [self valueFromDeep:userDict[@"field_address_2"]];
            self.field_city = [self valueFromDeep:userDict[@"field_city"]];
            self.field_company_name = [self valueFromDeep:userDict[@"field_company_name"]];
            self.field_company_number = [self valueFromDeep:userDict[@"field_company_number"]];
            self.field_country = [self valueFromDeep:userDict[@"field_country"]];
            self.field_customer_or_educator = userDict[@"field_customer_or_educator"];
            self.field_description = userDict[@"field_description"];
            self.field_first_name = [self valueFromDeep:userDict[@"field_first_name"]];
            self.field_landline_number = [self valueFromDeep:userDict[@"field_landline_number"]];
            self.field_last_name = [self valueFromDeep:userDict[@"field_last_name"]];
            self.field_phone = [self valueFromDeep:userDict[@"field_phone"]];
            self.field_postal_code = [self valueFromDeep:userDict[@"field_postal_code"]];
            self.field_vat_registration_number = userDict[@"field_vat_registration_number"];
            self.field_vendor_image = userDict[@"field_vendor_image"];
            self.field_vendor_rating = userDict[@"field_vendor_rating"];
            self.language = userDict[@"language"];
            self.mail = userDict[@"mail"];
            self.name = userDict[@"name"];
            id obj = userDict[@"picture"];
            self.created = userDict[@"created"];
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *picDict = userDict[@"picture"];
                self.picture = picDict[@"url"];
            }
            else
            {
                if ([obj isKindOfClass:[NSNull class]]) {
                    self.picture = @"";
                }else{
                    self.picture = obj;
                }
            }
            self.privatemsg_disabled = userDict[@"privatemsg_disabled"];
            self.signature = userDict[@"signature"];
            self.signature_format = userDict[@"signature_format"];
            self.status = userDict[@"status"];
            self.timezone = userDict[@"timezone"];
            self.uid = userDict[@"uid"];
            self.uuid = userDict[@"uuid"];
            
            NSDictionary *role = userDict[@"roles"];
            self.rolesUser = role[@"2"];
            self.rolesVendor = role[@"4"];
            if (role[@"4"]) {
                self.isVendor =true;
            }else{
                self.isVendor =false;
            }
            if (role[@"5"]) {
                self.isStudent =true;
            }else{
                self.isStudent =false;
            }

            NSDictionary *field_educator_type = userDict[@"field_educator_type"];
            NSArray *arrType = field_educator_type[@"und"];
            NSDictionary *type = arrType[0];
            NSString *str = type[@"value"];
            if ([str  isEqual: @"hours"]){
                self.isHourlyTutor = true;
            }else{
                self.isHourlyTutor = false;
            }




        }
        @catch (NSException *exception)
        {
            showAletViewWithMessage(@"Json data is not proper.");
        }
    }
    return self;
}
-(NSString *) valueFromDeep:(NSDictionary*) dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSArray *arr = dict[@"und"];
        if ([arr isKindOfClass:[NSArray class]]) {
            if (arr.count>0) {
                NSDictionary *d = arr[0];
                NSString *str = d[@"value"];
                if (str) {
                    return str;
                }
            }
        }}
    return @"";
}
@end
