//
//  SelectCityViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GetCityBlock)(NSString *anyValue);
@interface SelectCityViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tblCityList;
    IBOutlet UITextField *tfCity;
    IBOutlet UIButton *btnClose;
    IBOutlet UIButton *btnApply;
    IBOutlet UIView *viewContainer;
    NSMutableArray *arrCity;
}

//@property(assign) BOOL isChange;
@property(assign) BOOL isShowbtn;
@property(strong,nonatomic)   IBOutlet NSLayoutConstraint *widthView;
@property (nonatomic, strong) GetCityBlock refreshBlock;


-(IBAction)btnAppyCity:(id)sender;
-(IBAction)btnSearchLocation:(id)sender;
-(void) getCityBlock:(GetCityBlock)refreshBlock;

@end
