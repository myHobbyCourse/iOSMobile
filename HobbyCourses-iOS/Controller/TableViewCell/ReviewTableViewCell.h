//
//  ReviewTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/18/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"
#import "RateView.h"

@class ReviewTableViewCell;

@protocol ReviewTableViewCellProtocol <NSObject>
-(void) imageTapped:(NSString*)index;
@end

@interface ReviewTableViewCell : UITableViewCell {
    IBOutlet UILabel*           lblNo;
    IBOutlet UIImageView*       imvUser;
    
    IBOutlet UILabel*           lblTitle;
    IBOutlet UILabel*           lblMessage;
    IBOutlet UILabel*           lblAuther;
    IBOutlet UILabel*           lblPostDate;
    IBOutlet RateView*          rateView;
    IBOutlet UICollectionView *cvImages;
    NSMutableArray *arrPics;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cvheight;
@property (weak, nonatomic) IBOutlet UILabel*lblCourseName;
@property (nonatomic, weak) id<ReviewTableViewCellProtocol> delegate;

- (void) setData:(Review*) review;

@end
