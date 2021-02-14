//
//  WalkThroughVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 26/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "WalkThroughVC.h"

@interface WalkThroughVC ()

@end

@implementation WalkThroughVC

- (void)viewDidLoad {
    [super viewDidLoad];
    btnNext.layer.borderColor = [UIColor blackColor].CGColor;
    btnNext.layer.borderWidth = 1;
    btnNext.layer.cornerRadius = (35 * _widthRatio) / 2;
    btnNext.layer.masksToBounds = true;
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)btnNextClicked:(UIButton*)sender {
    [self performSegueWithIdentifier:@"splash_login" sender:nil];
}
#pragma mark - UICollection View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_screenSize.width,_screenSize.height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)cView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idf = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    GenericCollectionViewCell * cell = [cView dequeueReusableCellWithReuseIdentifier:idf forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _screenSize.width;
    float currentPage = collectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
        pageControl.currentPage = currentPage + 1;
    } else {
        pageControl.currentPage = currentPage;
    }
    if (pageControl.currentPage == 2) {
        [btnNext setTitle:@"Finish" forState:UIControlStateNormal];
    }else{
        [btnNext setTitle:@"Skip" forState:UIControlStateNormal];
    }
    NSLog(@"finishPage: %ld", (long)pageControl.currentPage);
}


@end
