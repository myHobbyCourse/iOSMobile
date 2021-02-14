//
//  SearchVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 09/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC_iPad: ParentViewController {
    IBOutlet UIView *viewKeyBorad;
    IBOutlet UIView *viewBottomPanel;
    IBOutlet UITextField *tfSerach;
    IBOutlet UIView *viewTop;
    IBOutlet UIView *viewBottomContainer;
    
}
@property(nonatomic,strong) Search *searchObj;
@end
