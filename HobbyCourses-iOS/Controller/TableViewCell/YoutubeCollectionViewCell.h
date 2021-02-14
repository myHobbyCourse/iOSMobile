//
//  YoutubeCollectionViewCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 14/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeCollectionViewCell : UICollectionViewCell

@property(weak,nonatomic) IBOutlet UIImageView *imgV;
@property(weak,nonatomic) IBOutlet UIImageView *imgPlayIcon;


@property(weak,nonatomic) IBOutlet YTPlayerView *playerView;
@end
