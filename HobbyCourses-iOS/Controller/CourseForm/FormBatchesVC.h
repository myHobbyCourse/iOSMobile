//
//  FormBatchesVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 29/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormBatchesVC : ParentViewController
@property(nonatomic,strong) IBOutlet UICollectionView *collectionBatches;
@property(assign) NSInteger currentIndex;

@end
