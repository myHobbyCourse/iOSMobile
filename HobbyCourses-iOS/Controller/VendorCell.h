//
//  VendorCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 17/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VendorProfileVC;
@interface VendorCell : UITableViewCell

@property(nonatomic,weak) VendorProfileVC *controller;
@property(nonatomic,weak) IBOutlet UIImageView *imgVendor;
@property(nonatomic,weak) IBOutlet UIImageView *imgMap;
@property(nonatomic,weak) IBOutlet UILabel *lblName;
@property(nonatomic,weak) IBOutlet UILabel *lblLocation;
@property(nonatomic,weak) IBOutlet UILabel *lblSince;
@property(nonatomic,weak) IBOutlet UIButton *btnReport;

@property(nonatomic,weak) IBOutlet UILabel *lblDesc;

@property(nonatomic,weak) IBOutlet UILabel *lblCertificate;

@property(nonatomic,weak) IBOutlet UILabel *lblComment;
@property(nonatomic,weak) IBOutlet UILabel *lblCommentCount;
@property(nonatomic,weak) IBOutlet UILabel *lblCommetUser;
@property(nonatomic,weak) IBOutlet UILabel *lblCommentDate;
@property(nonatomic,weak) IBOutlet UIImageView *imgVCommentUser;

@property(nonatomic,weak) IBOutlet UILabel *lblTutorName;
@property(nonatomic,weak) IBOutlet UILabel *lblLocationName;


@property(nonatomic,weak) IBOutlet UICollectionView *cvTutor;
@property(nonatomic,weak) IBOutlet UICollectionView *cvLocation;


@property(nonatomic,strong) IBOutlet UIButton *btnLeftTutor;
@property(nonatomic,strong) IBOutlet UIButton *btnRightTutor;

@property(nonatomic,weak) IBOutlet UIButton *btnLeftVenue;
@property(nonatomic,weak) IBOutlet UIButton *btnRightVenue;

@property(assign) NSIndexPath *index;
@property(assign) NSIndexPath *indexLocation;

@end
