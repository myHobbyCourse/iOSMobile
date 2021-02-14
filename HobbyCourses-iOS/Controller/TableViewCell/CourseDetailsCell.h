//
//  CourseDetailsCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 10/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewCourseVC.h"

@class controllerPreview;

@interface CourseDetailsCell : ConstrainedTableViewCell<YTPlayerViewDelegate>
@property(nonatomic,weak) IBOutlet UICollectionView *cvAmenities;
@property(nonatomic,weak) IBOutlet UICollectionView *cvVideo;
@property(nonatomic,weak) CourseDetailsVC *controllerDetails;
@property(nonatomic,weak) PreviewCourseVC *controllerPreview;

//@property(nonatomic,weak) IBOutlet NSLayoutConstraint *_videoHeight;

@end
