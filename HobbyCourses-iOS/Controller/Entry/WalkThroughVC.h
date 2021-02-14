//
//  WalkThroughVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 26/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalkThroughVC : ParentViewController {
    IBOutlet UICollectionView *collectionView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIButton *btnNext;

}

@end
