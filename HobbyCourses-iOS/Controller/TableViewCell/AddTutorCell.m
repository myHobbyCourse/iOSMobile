//
//  AddTutorCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 29/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AddTutorCell.h"

@implementation AddTutorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)textViewDidChange:(UITextView *)textView{
    self.controller.selectedTutor.tutor_details = textView.text;
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    self.controller.selectedTutor.tutor_details = textView.text;
}
-(IBAction)txtDidChange:(UITextField*)sender {
    if ([sender isEqual:self.tfAdd1]) {
        self.controller.selectedTutor.address = sender.text;
    }else if ([sender isEqual:self.tfAdd2]) {
        self.controller.selectedTutor.city = sender.text;
    }else if ([sender isEqual:self.tfPostalCode]) {
        self.controller.selectedTutor.pincode = sender.text;
    }else{
        self.controller.selectedTutor.tutor_name = sender.text;
    }
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.controller.selectedTutor.arrImgaes.count == 0)? 1: self.controller.selectedTutor.arrImgaes.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell;
    if(self.self.controller.selectedTutor.arrImgaes.count == indexPath.row){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    }
    UIImageView *imgV = [cell viewWithTag:11];
    if (indexPath.row < self.controller.selectedTutor.arrImgaes.count) {
        if ([self.controller.selectedTutor.arrImgaes[indexPath.row] isKindOfClass:[UIImage class]]) {
            imgV.image = self.controller.selectedTutor.arrImgaes[indexPath.row];
        }else{
            [imgV sd_setImageWithURL:[NSURL URLWithString:self.controller.selectedTutor.arrImgaes[indexPath.row]] placeholderImage:_placeHolderImg];
        }
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
@end
