//
//  EditProfileCell_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 22/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileVC_iPad.h"


@interface EditProfileCell_iPad : UITableViewCell<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(weak,nonatomic) EditProfileVC_iPad *controller;

@property(weak,nonatomic) IBOutlet UIView *viewRoundPrivate;

@property(weak,nonatomic) IBOutlet UIView *viewCompany;
@property(weak,nonatomic) IBOutlet UILabel *companyTitle;

@property(weak,nonatomic) IBOutlet UITextField *tfFirstName;
@property(weak,nonatomic) IBOutlet UITextField *tfLastName;
@property(weak,nonatomic) IBOutlet UITextField *tfBirthDate;

@property(weak,nonatomic) IBOutlet UITextField *tfPassword;
@property(weak,nonatomic) IBOutlet UITextField *tfRPass;

@property(weak,nonatomic) IBOutlet UITextField *tfEmail;

@property(weak,nonatomic) IBOutlet UITextField *tfMobile;
@property(weak,nonatomic) IBOutlet UITextField *tfLandline;

@property(weak,nonatomic) IBOutlet UITextField *tfAdd1;
@property(weak,nonatomic) IBOutlet UITextField *tfAdd2;
@property(weak,nonatomic) IBOutlet UITextField *tfCity;
@property(weak,nonatomic) IBOutlet UITextField *tfPostalCode;

@property(weak,nonatomic) IBOutlet UITextField *tfCname;
@property(weak,nonatomic) IBOutlet UITextField *tfCno;
@property(weak,nonatomic) IBOutlet UITextField *tfCVat;
@property(weak,nonatomic) IBOutlet UITextField *tfCwebsite;


@property(weak,nonatomic) IBOutlet UILabel *lblHobby1;
@property(weak,nonatomic) IBOutlet UILabel *lblHobby2;
@property(weak,nonatomic) IBOutlet UILabel *lblHobby3;

@property(weak,nonatomic) IBOutlet UIImageView *imgHobby1;
@property(weak,nonatomic) IBOutlet UIImageView *imgHobby2;
@property(weak,nonatomic) IBOutlet UIImageView *imgHobby3;


@property(weak,nonatomic) IBOutlet UIButton *btnMale;
@property(weak,nonatomic) IBOutlet UIButton *btnFemale;
@property(weak,nonatomic) IBOutlet UIButton *btnOther;

-(void) setData;


@end
