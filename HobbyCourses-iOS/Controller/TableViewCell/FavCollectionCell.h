//
//  FavCollectionCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 23/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavCollectionCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UILabel *lblTittle;
@property(nonatomic,strong) IBOutlet UILabel *lblCity;
@property(nonatomic,strong) IBOutlet UILabel *lblPrice;
@property(nonatomic,strong) IBOutlet UILabel *lblReview;
@property(nonatomic,strong) IBOutlet UILabel *lblUpdate;

@property(nonatomic,strong) IBOutlet RateView *rateView;
@property(nonatomic,strong) IBOutlet UIView *viewAction;
@property(nonatomic,strong) IBOutlet UIImageView *imgV;

@property(nonatomic,strong) IBOutlet UIButton *btnView;
@property(nonatomic,strong) IBOutlet UIButton *btnDelete;

@end
