//
//  CourseDetailsCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 10/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseDetailsCell.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@implementation CourseDetailsCell
@synthesize cvVideo;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == cvVideo) {
        if (self.controllerPreview) {
            return dataClass.crsYoutubeURL.count;
        }else{
            return self.controllerDetails.courseEntity.youtube_video.count;
        }
    }
    if (self.controllerDetails) {
        return self.controllerDetails.courseEntity.amenities.count;
    }else{
        return self.controllerPreview.arrAmenities.count;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == cvVideo) {
        if (is_iPad()) {
            return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height);
        }
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    }else{
        if (is_iPad()) {
            return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.height/3);
        }else{
            return CGSizeMake(collectionView.frame.size.width/6, collectionView.frame.size.width/6);
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == cvVideo) {
        
        YoutubeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YoutubeCell" forIndexPath:indexPath];
        NSString *vID = (self.controllerPreview == nil) ?self.controllerDetails.courseEntity.youtube_video[indexPath.row] : dataClass.crsYoutubeURL[indexPath.row];
        if (is_iPad()) {
            
            cell.imgPlayIcon.hidden = true;
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[vID getVideoThumURL]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    if (cell.playerView.playerState != kYTPlayerStatePlaying) {
                        cell.imgPlayIcon.hidden = false;
                    }
                }else{
                    cell.imgV.image = _placeHolderImg;
                }
            }];
        }else{
            NSDictionary *playerVars = @{@"showinfo" : @0};
            [cell.playerView loadWithVideoId:vID playerVars:playerVars];
            cell.playerView.delegate = self;
            cell.playerView.hidden = true;
        }
        
        cell.playerView.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        UICollectionViewCell * cell;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        UIButton *btn = [cell viewWithTag:111];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (self.controllerDetails) {
            if (indexPath.row == 5) {
                [btn setTitle:[NSString stringWithFormat:@"%lu",self.controllerDetails.courseEntity.amenities.count - 4] forState:UIControlStateNormal];
                [btn setImage:nil forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"" forState:UIControlStateNormal];
                
                [[SDWebImageManager sharedManager] loadImageWithURL:self.controllerDetails.courseEntity.amenities[indexPath.row].getUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (image) {
                        // do something with image
                        [btn setImage:image forState:UIControlStateNormal];
                    }
                }];
                
                /*
                [[SDWebImageManager sharedManager] downloadImageWithURL:self.controllerDetails.courseEntity.amenities[indexPath.row].getUrl options:0
                progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        // do something with image
                        [btn setImage:image forState:UIControlStateNormal];
                    }
                }];*/
            }
            
        }else if (self.controllerPreview) {
            if (indexPath.row == 5) {
                [btn setTitle:[NSString stringWithFormat:@"%lu",dataClass.crsAmenities.count - 4] forState:UIControlStateNormal];
                [btn setImage:nil forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"" forState:UIControlStateNormal];
                
                
                [[SDWebImageManager sharedManager]loadImageWithURL:self.controllerPreview.arrAmenities[indexPath.row].getUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (image) {
                        // do something with image
                        [btn setImage:image forState:UIControlStateNormal];
                    }
                }];
                /*
                [[SDWebImageManager sharedManager] loadImageWithURL:self.controllerPreview.arrAmenities[indexPath.row].getUrl options:0
                   progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                      if (image) {
                          // do something with image
                          [btn setImage:image forState:UIControlStateNormal];
                      }
                  }];*/
                
            }
        }
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == cvVideo) {
        YoutubeCollectionViewCell * cell = (YoutubeCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        NSDictionary *playerVars = @{@"showinfo" : @0};
        [cell.playerView loadWithVideoId:self.controllerDetails.courseEntity.youtube_video[indexPath.row] playerVars:playerVars];
        cell.playerView.delegate = self;
        cell.playerView.hidden = true;
        cell.imgPlayIcon.hidden = true;
        cell.imgV.hidden = true;
        
    }
}

#pragma mark - Youtube player delegate
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    playerView.hidden = NO;
    if (is_iPad()) {
        [playerView playVideo];    
    }
    
    
}
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            [cvVideo reloadData];
            break;
        default:
            break;
    }
}
- (void)playerView:(nonnull YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    NSLog(@"%ld",(long)error);
}

@end
