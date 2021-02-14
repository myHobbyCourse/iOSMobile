//
//  EditProfileCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 16/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileVC.h"

@class EditProfileVC;

@interface EditProfileCell : UITableViewCell<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(weak,nonatomic) EditProfileVC *controller;

@property(weak,nonatomic) IBOutlet UIView *viewRoundPrivate;

@property(weak,nonatomic) IBOutlet UIImageView *imgProfile;

@property(weak,nonatomic) IBOutlet UITextField *tfFirstName;
@property(weak,nonatomic) IBOutlet UITextField *tfLastName;

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

@property(weak,nonatomic) IBOutlet UITextView *txtDesc;
@property(weak,nonatomic) IBOutlet UILabel *lblWelcome;
@property(weak,nonatomic) IBOutlet UILabel *lblSince;

@property(weak,nonatomic) IBOutlet UILabel *lblHobby1;
@property(weak,nonatomic) IBOutlet UILabel *lblHobby2;
@property(weak,nonatomic) IBOutlet UILabel *lblHobby3;


@property(weak,nonatomic) IBOutlet UIButton *btnMale;
@property(weak,nonatomic) IBOutlet UIButton *btnFemale;
@property(weak,nonatomic) IBOutlet UIButton *btnOther;
@property(weak,nonatomic) IBOutlet UIButton *btnBirth;


-(void) setData;
@end
