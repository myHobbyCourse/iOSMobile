//
//  SearchViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/17/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"

@interface SearchViewController : ParentViewController {
    IBOutlet UIView *viewKeyBorad;
    IBOutlet UIView *viewBottomPanel;
    IBOutlet UITextField *tfSerach;
    IBOutlet UIView *viewTop;
    IBOutlet UIView *viewBottomContainer;

}
@property(nonatomic,strong) Search *searchObj;

@end
