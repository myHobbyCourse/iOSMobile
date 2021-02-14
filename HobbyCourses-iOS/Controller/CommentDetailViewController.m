//
//  CommentDetailViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 17/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CommentDetailViewController.h"

@interface CommentDetailViewController ()

@end

@implementation CommentDetailViewController
@synthesize nidComment;
- (void)viewDidLoad {
    [super viewDidLoad];
    rate.rating = 5.0;
    rate.starSize = 20;
    rate.starNormalColor = [UIColor grayColor];
    rate.starFillColor = UIColorFromRGB(0xffba00);
    
    [self getCommentDetail];
    // Do any additional setup after loading the view.
}
-(void) getCommentDetail
{
 
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:[NSString stringWithFormat:@"http://myhobbycourses.com/%@%@",apiCommentDetail,nidComment] paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                if ([jsonData valueForKey:@"nodes"])
                {
                    NSArray *arrData = [jsonData valueForKey:@"nodes"];
                    if (arrData && arrData.count>0)
                    {
                        NSDictionary *dict = arrData[0];
                        if ([dict valueForKey:@"node"])
                        {
               
                        }
                        
                    }
                }
            }
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 
    return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellImg" forIndexPath:indexPath];
        UIImageView *img = [cell viewWithTag:11];
        if (indexPath.row %2 == 0)
        {
            //@[@"course_news2.png",@"course_news3.png",@"course_news1.png"].
            img.image = [UIImage imageNamed:@"course_news2.png"];
        }else
        {
            img.image = [UIImage imageNamed:@"course_news1.png"];
        }
        
        return cell;
}

-(IBAction)btnBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
