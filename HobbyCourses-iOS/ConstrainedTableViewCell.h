//
//  ConstrainedTableViewCell.h
//  AirbnbClone
//
//  Created by iOS Dev on 24/08/16.
//  Copyright © 2016 iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConstrainedTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *horizontalConstraints;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *verticalConstraints;
@end

@interface GenericTableViewCell : ConstrainedTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblSubTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imgV;
@property (nonatomic, strong) IBOutlet UIButton *btnGenral;

@end
