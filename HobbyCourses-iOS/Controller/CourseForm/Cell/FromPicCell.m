//
//  FromPicCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromPicCell.h"

@implementation FromPicCell

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
    return [DataClass getInstance].crsImages.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.controllerPreview == nil) {
        return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height - 10);
    }else{
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height - 10);
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    int sise = (self.controllerPreview == nil) ? _screenSize.width :_screenSize.width/3.0;
    int vv = (velocity.x > 0) ? 1: 0;
    int cc = (scrollView.contentOffset.x)/sise;
    int ff = vv + cc;
    targetContentOffset->x = ff * sise;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:11];
    NSString *imgUrl = [[DocumentAccess obj] mediaForNameString:dataClass.crsImages[indexPath.row]];
    if (imgUrl) {
        imgV.image = [UIImage imageWithContentsOfFile:imgUrl];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imgUrl = [[DocumentAccess obj] mediaForNameString:dataClass.crsImages[indexPath.row]];
    if (imgUrl) {
        _imgPreview.image = [UIImage imageWithContentsOfFile:imgUrl];
    }
    dataClass.selectedPreviewImg = indexPath.row;
}
@end
