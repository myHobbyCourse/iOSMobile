//
//  ReviewTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/18/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "Constants.h"

@implementation ReviewTableViewCell
@synthesize lblCourseName;
- (void)awakeFromNib {
    [super awakeFromNib];
    if (is_iPad()) {
        rateView.starSize = 20;
    }else{
        rateView.starSize = 10;
    }
    rateView.starNormalColor = [UIColor grayColor];
    rateView.starFillColor = UIColorFromRGB(0xffba00);

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(Review*) review
{
    if (![review.avatar isKindOfClass:[NSNull class]])
    {
        [imvUser sd_setImageWithURL:[NSURL URLWithString:review.avatar]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }else{
        imvUser.image = [UIImage imageNamed:@"placeholder"];
    }
    imvUser.layer.cornerRadius = 20;
    imvUser.layer.masksToBounds = YES;

    lblTitle.text = review.subject;
    lblMessage.text = review.comment.trimmedString;
    rateView.rating = review.course_rating;
    [lblTitle sizeToFit];
    lblPostDate.text = review.post_date;
    lblAuther.text = review.author;
//    lblCourseName.text = review.commented_node_title;
    arrPics = review.imagesArr;
    if (arrPics.count == 0) {
        self.cvheight.constant = 0;
    }else{
        self.cvheight.constant = 90;
    }
    [cvImages reloadData];
//    rateView.center = CGPointMake(lblTitle.center.x + lblTitle.frame.size.width / 2 + 30, rateView.center.y + 5);
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrPics.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellImg" forIndexPath:indexPath];
    UIImageView *img = [cell viewWithTag:5];
 
    id obj = arrPics[indexPath.row];
    if ([obj isKindOfClass:[UIImage class]])
    {
        img.image = arrPics[indexPath.row];
    }else
    {
        [img sd_setImageWithURL:[NSURL URLWithString:obj]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(imageTapped:)]) {
        NSString *str = [arrPics objectAtIndex:indexPath.row];
        [self.delegate performSelector:@selector(imageTapped:) withObject:str];
    }
}
@end
