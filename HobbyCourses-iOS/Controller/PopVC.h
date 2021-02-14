//
//  PopVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 16/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopDelegateProtocol <NSObject>
-(void) selectedCustomView:(NSString *)value tag:(NSInteger) selectTag;
@end

@interface PopVC : UIViewController
@property(strong,nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *arrData;
@property (nonatomic, weak) id<PopDelegateProtocol> delegate;
@property(assign) NSInteger selectedTag;
@end
