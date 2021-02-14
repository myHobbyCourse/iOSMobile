//
//  BatchHeaderView.h
//  HobbyCourses
//
//  Created by iOS Dev on 20/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatchHeaderView : UIView

@property(strong,nonatomic) IBOutlet UIButton *btnExapndSection;
@property(strong,nonatomic) IBOutlet UIButton *btnBook;

@property(strong,nonatomic) IBOutlet UILabel *lblStart;
@property(strong,nonatomic) IBOutlet UILabel *lblEnd;
@property(strong,nonatomic) IBOutlet UILabel *lblSession;
@property(strong,nonatomic) IBOutlet UILabel *lblBatch;
@property(strong,nonatomic) IBOutlet UILabel *lblPrice;
@property(strong,nonatomic) IBOutlet UILabel *lblSold;
@property(strong,nonatomic) IBOutlet UILabel *lblQty;

@end
