//
//  CellBatches.h
//  HobbyCourses
//
//  Created by iOS Dev on 01/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FormBatchesVC;

@interface CellBatches : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UITableView *tblBatches;
@property(nonatomic,strong) FormBatchesVC *controller;

@end
