//
//  SelectCategorySubPopVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 20/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategorySubPopVC_iPad : ParentViewController

@property(strong,nonatomic) IBOutlet UIView *viewBG;
@property(strong,nonatomic) IBOutlet UICollectionView *colletionV;
@property(strong,nonatomic) IBOutlet UIButton *btnSave;
@property(strong,nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) NSMutableArray *arrTittle;
@property (nonatomic, strong) NSString *screenTitle;
@property (assign) SelectionType type;

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
