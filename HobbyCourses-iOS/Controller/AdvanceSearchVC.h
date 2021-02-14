//
//  AdvanceSearchVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 28/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvanceSearchVC : ParentViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *collectView;
    IBOutlet UIButton *btnMon;
    IBOutlet UIButton *btnThu;
    IBOutlet UIButton *btnWed;
    IBOutlet UIButton *btnTue;
    IBOutlet UIButton *btnFri;
    IBOutlet UIButton *btnSat;
    IBOutlet UIButton *btnSan;
    IBOutlet UITextField *tfStart;
    IBOutlet UITextField *tfEnd;
    IBOutlet UITextField *tfSortBy;
    IBOutlet NSLayoutConstraint *_filterHeight;
    IBOutlet UIView *openFilterView;
    IBOutlet UIView *FilterView;
    IBOutlet UIView *sortByView;
    IBOutlet UILabel *lblSearch;
}
@property (weak, nonatomic) IBOutlet NMRangeSlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *ageLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageUpperLabel;
@property (weak, nonatomic) IBOutlet NMRangeSlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *priceLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceUpperLabel;
@property (weak, nonatomic) IBOutlet NMRangeSlider *sizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *sizeLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeUpperLabel;
@property (weak, nonatomic) IBOutlet NMRangeSlider *sessionSlider;
@property (weak, nonatomic) IBOutlet UILabel *sessionLowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionUpperLabel;

@property (strong, nonatomic) NSMutableArray *arrCourses;

@property (strong, nonatomic) NSMutableDictionary *basicDict;


@end
