//
//  UserPhoneBook.m
//  TableShare
//
//  Created by Yudiz Solutions Pvt. Ltd. on 02/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

#import "UserPhoneBook.h"
#import "NBPhoneNumberUtil.h"
#import "NBPhoneNumber.h"

@import AddressBook;
@import UIKit;

@implementation UserPhoneBook

+ (instancetype)sharedInstance {
    static UserPhoneBook *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserPhoneBook alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)checkAuthorizationStatus:(void(^)(BOOL,NSError*))block {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                block(granted,(__bridge NSError*)error);
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                block(granted,(__bridge NSError*)error);
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        block(YES,nil);
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        block(NO,nil);
    }
    
    if (addressBookRef) {
        CFRelease(addressBookRef);
    }
}

#pragma mark - UserNameNumberEmail
- (void)fetchUserNameNumberEmail:(void (^)(NSArray <NSDictionary*> *))block {
    [self checkAuthorizationStatus:^(BOOL authorize, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorize) {
                block([self getNameNumberAndEmail]);
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Need Permission" message:@"In Order to find your friend we would need access to your contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                block(nil);
            }
        });
    }];
}

- (NSArray <NSDictionary*> *)getNameNumberAndEmail {
    
    NBPhoneNumberUtil *util =  [[NBPhoneNumberUtil alloc]init];
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    NSMutableArray *contacts = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));

        if ([firstName length] == 0) {
            firstName = @"No";
        }
        if ([lastName length] == 0) {
            lastName = @"Name";
        }
        
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSString* email = nil;
        NSString *phoneNumber = nil;
        
        if (ABMultiValueGetCount(emails) > 0)
            email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, 0);
        if (ABMultiValueGetCount(phoneNumbers) > 0){
            phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
            NBPhoneNumber *num = [util parseWithPhoneCarrierRegion:phoneNumber error:nil];
            phoneNumber = [NSString stringWithFormat:@"+%@%@",num.countryCode.stringValue,num.nationalNumber.stringValue];
        }
        
        if (email != nil && phoneNumber != nil) {
            if (firstName != nil && lastName != nil) {
                [contacts addObject:@{  @"email"  : email,@"number" : phoneNumber, @"firstName": firstName, @"lastName": lastName}];
            }else if (firstName != nil) {
                [contacts addObject:@{  @"email"  : email,@"number" : phoneNumber, @"firstName": firstName}];
            }else if (lastName != nil) {
                [contacts addObject:@{  @"email"  : email,@"number" : phoneNumber, @"lastName": lastName}];
            }else{
                [contacts addObject:@{  @"email"  : email,@"number" : phoneNumber}];
            }
        }else if (email != nil){
            if (firstName != nil && lastName != nil) {
                [contacts addObject:@{  @"email"  : email, @"firstName": firstName, @"lastName": lastName}];
            }else if (firstName != nil) {
                [contacts addObject:@{  @"email"  : email, @"firstName": firstName}];
            }else if (lastName != nil) {
                [contacts addObject:@{  @"email"  : email, @"lastName": lastName}];
            }else{
                [contacts addObject:@{@"email" : email}];
            }
        }else if (phoneNumber != nil) {
            if (firstName != nil && lastName != nil) {
                [contacts addObject:@{@"number" : phoneNumber, @"firstName": firstName, @"lastName": lastName}];
            }else if (firstName != nil) {
                [contacts addObject:@{@"number" : phoneNumber, @"firstName": firstName}];
            }else if (lastName != nil) {
                [contacts addObject:@{@"number" : phoneNumber, @"lastName": lastName}];
            }else{
                [contacts addObject:@{@"number" : phoneNumber}];
            }
        }
        
        CFRelease(emails);
        CFRelease(phoneNumbers);
    }
    
    // Added by jigar later
    CFRelease(allPeople);
    CFRelease(addressBook);
    return contacts.copy;
}

#pragma mark - AllNumber(s)Email(s)
- (void)fetchAllEmailsAndNumbers:(void (^)(NSDictionary* __nullable))block {
    [self checkAuthorizationStatus:^(BOOL authorize, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorize) {
                block([self getAllEmailsAndNumbers]);
            } else {
                block(nil);
            }
        });
    }];
}

- (NSDictionary*)getAllEmailsAndNumbers {
    CFErrorRef *error = NULL;
    NBPhoneNumberUtil *util =  [[NBPhoneNumberUtil alloc]init];
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    //Phone numbers loop
    NSMutableArray *arrPhoneNumbers = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            NSError *nbError;
            NBPhoneNumber *num = [util parseWithPhoneCarrierRegion:phoneNumber error:&nbError];
            if (error == nil ) {
                NSString *strPhoneNumber = [NSString stringWithFormat:@"+%@%@",num.countryCode.stringValue,num.nationalNumber.stringValue];
                if (num.countryCode.stringValue != nil && num.nationalNumber.stringValue != nil) {
                    [arrPhoneNumbers addObject: strPhoneNumber];
                }
            }
        }
        CFRelease(phoneNumbers);
    }
    
    //Email address loop
    NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
            [allEmails addObject:email];
        }
        CFRelease(emails);
    }
    
    CFRelease(addressBook);
    CFRelease(people);
    
    NSMutableDictionary *contactDict = [[NSMutableDictionary alloc]init];
    [contactDict setObject:allEmails forKey:@"emails"];
    [contactDict setObject:arrPhoneNumbers forKey:@"numbers"];
    return contactDict.copy;
}
@end