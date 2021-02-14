//
//  CollectionBatchesCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionBatchesCell : UICollectionViewCell
@property(nonatomic,strong) IBOutlet UILabel *lblTittle;
@property(nonatomic,strong) IBOutlet UIView *containerView;
@property(nonatomic,strong) IBOutlet UIImageView *imgPlus;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint *heightView;
@end
