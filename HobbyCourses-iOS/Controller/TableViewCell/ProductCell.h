//
//  ProductCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 01/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UILabel *lblStartDate;
@property(strong,nonatomic) IBOutlet UILabel *lblEndDate;
@property(strong,nonatomic) IBOutlet UILabel *lblSessions;
@property(strong,nonatomic) IBOutlet UILabel *lblBatchSize;
@property(strong,nonatomic) IBOutlet UILabel *lblPice;
@property(strong,nonatomic)  IBOutlet UIButton *btnBuy;
@property(strong,nonatomic)  IBOutlet UIButton *btnDetails;

-(void)setData:(ProductEntity *)product;

@end
