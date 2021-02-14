//
//  AddTutorCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 29/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTutorCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>

@property(strong,nonatomic) IBOutlet UICollectionView *collectionV;
@property(strong,nonatomic) AddTutorVC_iPad *controller;
@property(strong,nonatomic) IBOutlet UITextField *tfPostalCode;
@property(strong,nonatomic) IBOutlet UITextField *tfAdd1;
@property(strong,nonatomic) IBOutlet UITextField *tfAdd2;
@property(strong,nonatomic) IBOutlet UITextField *tfCountry;

@end
