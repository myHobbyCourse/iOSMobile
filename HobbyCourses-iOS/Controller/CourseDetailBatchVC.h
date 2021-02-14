//
//  CourseDetailBatchVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 02/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void (^RefreshBlock)(NSString *anyValue);

@interface CourseDetailBatchVC : ParentViewController
@property (nonatomic, strong) RefreshBlock refreshBlock;
@property(strong,nonatomic) NSMutableArray<ProductEntity*> *arrBatches;
@property(strong,nonatomic) CourseDetail *courseEntity;

@property(assign) int selectedBatch;

-(void) getRefreshBlock:(RefreshBlock)refreshBlock;
@end
