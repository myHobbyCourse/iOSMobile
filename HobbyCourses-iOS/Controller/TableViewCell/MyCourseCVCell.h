//
//  MyCourseCVCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 24/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCourseCVCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UILabel *lblTittle;
@property(nonatomic,strong) IBOutlet UILabel *lblCity;
@property(nonatomic,strong) IBOutlet UILabel *lblUploded;
@property(nonatomic,strong) IBOutlet UILabel *lblAvailble;
@property(nonatomic,strong) IBOutlet UILabel *lblSize;
@property(nonatomic,strong) IBOutlet UILabel *lblStatus;
@property(nonatomic,strong) IBOutlet UILabel *lblCategory;
@property(nonatomic,strong) IBOutlet UIView *viewAction;
@property(nonatomic,strong) IBOutlet UIImageView *imgV;
@property(nonatomic,strong) IBOutlet UIImageView *imgVCateogry;
@property(nonatomic,strong) IBOutlet UIButton *btnView;
@property(nonatomic,strong) IBOutlet UIButton *btnDelete;

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) refreshBlock:(RefreshBlock)deleteBlock;

@end
