//
//  CourseListingCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 27/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseListingVC;
@class CourseDetailsVC;
@interface CourseListingCell : GenericTableViewCell<UIWebViewDelegate>

@property(nonatomic,weak) CourseListingVC *controller;
@property(nonatomic,weak) CourseDetailsVC *controllerDetails;

@property(nonatomic,weak) IBOutlet UICollectionView *cvWeek;
@property(nonatomic,weak) IBOutlet UICollectionView *cvEvening;
@property(nonatomic,weak) IBOutlet UICollectionView *cvRecent;
@property(nonatomic,weak) IBOutlet UICollectionView *cvPopuler;
@property(nonatomic,weak) IBOutlet UICollectionView *cvDetails;
@property(nonatomic,weak) IBOutlet UICollectionView *cvFavourites;
@property(nonatomic,weak) IBOutlet UICollectionView *cvSimilerListing;

@property(nonatomic,weak) IBOutlet  UILabel *lblPrice;
@property(nonatomic,weak) IBOutlet  UILabel *lblTitle;
@property(nonatomic,weak) IBOutlet  UILabel *lblReviewCount;
@property(nonatomic,weak) IBOutlet  UILabel *lblCity;
@property(nonatomic,weak) IBOutlet  UIButton *btnFav;
@property(nonatomic,weak) IBOutlet  UILabel *lblSpamCount;
@property(nonatomic,weak) IBOutlet  UILabel *lblQTTY;
@property(nonatomic,weak) IBOutlet  UILabel *lblSold;

@property(nonatomic,weak) IBOutlet  UILabel *lblPeopleSaved;
@property(nonatomic,weak) IBOutlet  UILabel *lblSutableFor;


@end
