//
//  AddVenueCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 02/12/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddVenueVC_iPad.h"


@interface AddVenueCell : UITableViewCell<UITextFieldDelegate>

@property(strong,nonatomic) IBOutlet UICollectionView *collectionV;
@property(strong,nonatomic) IBOutlet UITextField *tfPostalCode;
@property(strong,nonatomic) IBOutlet UITextField *tfAdd1;
@property(strong,nonatomic) IBOutlet UITextField *tfAdd2;
@property(strong,nonatomic) IBOutlet UITextField *tfCountry;
@property(strong,nonatomic) AddVenueVC_iPad *controller;

@end
