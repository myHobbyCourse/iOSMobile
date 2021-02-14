//
//  VendorCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 17/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "VendorCell.h"

@implementation VendorCell
@synthesize controller;
- (void)awakeFromNib {
    [super awakeFromNib];
    if (_btnReport) {
        if (is_iPad()) {
            _btnReport.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _btnReport.layer.borderWidth = 1;
        }else{
            _btnReport.layer.borderColor = __THEME_COLOR.CGColor;
            _btnReport.layer.borderWidth = 1;
        }
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(IBAction)btnNextPre:(UIButton*)sender {
    if (_index.row > 0 && self.btnLeftTutor == sender) {
        int i = _index.row;
        [_cvTutor scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:i - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    }else if (_index.row < controller.arrTuttors.count - 1 && self.btnRightTutor == sender) {
        int i = _index.row;
        [_cvTutor scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:i + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    }else if (_indexLocation.row > 0 && self.btnLeftVenue == sender) {
        int i = _indexLocation.row;
        [_cvLocation scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:i - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    }else if (_indexLocation.row < controller.arrVenues.count - 1 && self.btnRightVenue == sender) {
        int i = _indexLocation.row;
        [_cvLocation scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:i + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    }
    
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _cvTutor) {
        return controller.arrTuttors.count;
    }else if (collectionView == _cvLocation){
        return controller.arrVenues.count;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_screenSize.width, collectionView.frame.size.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:11];
    if (collectionView == _cvTutor) {
        [imgV sd_setImageWithURL:[NSURL URLWithString:controller.arrTuttors[indexPath.row].imagePath] placeholderImage:_placeHolderImg];
        _lblTutorName.text = controller.arrTuttors[indexPath.row].tutor_name;
        _index = indexPath;
    }else{
        _indexLocation = indexPath;
        [imgV sd_setImageWithURL:[NSURL URLWithString:controller.arrVenues[indexPath.row].imagePath] placeholderImage:_placeHolderImg];
        _lblLocationName.text = controller.arrVenues[indexPath.row].venue_name;
        
        if (![controller checkStringValue:controller.arrVenues[indexPath.row].latitude]) {
            NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",controller.arrVenues[indexPath.row].latitude,controller.arrVenues[indexPath.row].longitude,@"zoom=15&size=450x300"];
            NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_imgMap sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
        }
        
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _cvTutor) {
        [self.controller performSegueWithIdentifier:@"tutorDetail" sender:controller.arrTuttors[indexPath.row]];
    }else{
        [self.controller performSegueWithIdentifier:@"venueDetail" sender:controller.arrVenues[indexPath.row]];
    }
}
@end
