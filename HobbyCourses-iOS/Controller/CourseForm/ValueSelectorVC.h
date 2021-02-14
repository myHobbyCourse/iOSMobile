//
//  ValueSelectorVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 22/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    SelectionTypeCategory,
    SelectionTypeSubCateogy,
    SelectionTypeVenue,
    SelectionTypeNone,
    SelectionTypeCancellation,

} SelectionType;

@interface ValueSelectorVC : ParentViewController {
    IBOutlet UILabel *lblScreenTitle;
}

@property(nonatomic,strong) NSString *screenTitle;
@property (nonatomic, strong) RefreshBlock refreshBlock;
@property (nonatomic, strong) NSMutableArray *arrTittle;
@property (assign) SelectionType type;

-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
