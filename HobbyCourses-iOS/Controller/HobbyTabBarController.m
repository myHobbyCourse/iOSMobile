//
//  HobbyTabBarController.m
//  HobbyCourses
//
//  Created by iOS Dev on 14/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "HobbyTabBarController.h"

@interface HobbyTabBarController () {
    IBOutletCollection(UIButton) NSArray *btnTabs;
    IBOutletCollection(UIButton) NSArray *btnTabsVendor;
    IBOutlet UIView *hobbyTab;

}

@end

@implementation HobbyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomTab];
    [self selectTab:0];
    // Do any additional setup after loading the view.
}



-(void) addCustomTab {
    
    hobbyTab =  [[NSBundle mainBundle] loadNibNamed:@"HobbyTabbar" owner:self options:nil] [(APPDELEGATE.userCurrent.isVendor) ? 1: 0];
    hobbyTab.frame = CGRectMake(0, 0, _screenSize.width, self.tabBar.frame.size.height);
    [self.tabBar addSubview:hobbyTab];
    [self.tabBar layoutIfNeeded];
}
-(void) selectTab:(NSInteger) idx {
    for (UIButton *btn in (APPDELEGATE.userCurrent.isVendor) ? btnTabsVendor : btnTabs) {
        if (idx == btn.tag) {
            btn.selected = true;
        }else{
            btn.selected = false;
        }
    }
    self.selectedIndex = idx;

    if (idx == 0 && is_iPad()) {
        UINavigationController *nav = self.viewControllers[0];
        CourseListingVC_iPad *vc = nav.viewControllers[0];
        [vc hideCategoryView];

    }

   
}
-(IBAction)didTapOnTab:(UIButton*)sender{
    [self selectTab:sender.tag];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 1 &&APPDELEGATE.userCurrent.isStudent) {
        UINavigationController *nav = self.viewControllers[1];
        ProfileSearchResultsViewController *vc = (ProfileSearchResultsViewController*)[getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"ProfileSearchResultsViewController"];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.tabBarController.viewControllers];
        UIViewController *VC = [nav initWithRootViewController:vc];
        [viewControllers replaceObjectAtIndex:1 withObject:VC];
    }

}

@end
