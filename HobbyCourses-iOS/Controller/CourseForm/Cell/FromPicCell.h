//
//  FromPicCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UploadPicVC,PreviewCourseVC;

@interface FromPicCell : UITableViewCell

@property(nonatomic,weak) PreviewCourseVC *controllerPreview;
@property(nonatomic,weak) UploadPicVC *controllerDetails;
@property(nonatomic,weak) IBOutlet UICollectionView *cvImages;
@property(nonatomic,weak) IBOutlet UIImageView *imgPreview;

@end
