//
//  FavCourseViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 04/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FavCourseViewController.h"

@interface FavCourseViewController () {
    NSMutableArray *arrData;
    NSInteger selectedRow;
}
@end

@implementation FavCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc]init];
    tblFav.rowHeight = UITableViewAutomaticDimension;
    tblFav.estimatedRowHeight = 70;
    tblFav.tableFooterView = [[UIView alloc]init];
    [self performSelector:@selector(getFavCourses) withObject:self afterDelay:0.2];
    selectedRow = -1;
    //    [self getFavCourses];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [collectionView reloadData];
    [self updateToGoogleAnalytics:@"Favourite Course Screen"];
    
}
-(IBAction)btnDeleteCourse:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:collectionView];
    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:buttonPosition];
    FavCourse *course = [arrData objectAtIndex:indexPath.row];
    [self removeFav:course];

}
-(IBAction)btnViewCourse:(UIButton*)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:collectionView];
    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:buttonPosition];
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];

}

-(void) getFavCourses
{
    if (![self isNetAvailable]) {
        [self getOfflineFavCourse];
        return;
    }
    
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiWishList paramter:@{@"page":@"1"} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                NSArray *arr = jsonData;
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kFavKey];
                [UserDefault synchronize];
                [arrData removeAllObjects];
                for (NSDictionary *dict in arr) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        FavCourse *courseEnt = [[FavCourse alloc]initWith:dict];
                        [arrData addObject:courseEnt];
                    }
                }
                
                if (is_iPad()) {
                    [collectionView reloadData];
                }else{
                    [tblFav reloadData];
                }
            }
            lblCount.text = [NSString stringWithFormat:@"%lu Course Saved",(unsigned long)arrData.count];
            
        } else {
            showAletViewWithMessage(kFailAPI);
        }
        if (arrData.count == 0) {
            viewEmpty.hidden = false;
        }else{
            viewEmpty.hidden = YES;
        }
    }];
}
-(void)getOfflineFavCourse {
    NSData *data = [UserDefault objectForKey:kFavKey];
    if (data) {
        id jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([jsonData isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *dict in jsonData) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    FavCourse *courseEnt = [[FavCourse alloc]initWith:dict];
                    [arrData addObject:courseEnt];
                }
            }
            
            if (is_iPad()) {
                [collectionView reloadData];
            }else{
                [tblFav reloadData];
            }
            lblCount.text = [NSString stringWithFormat:@"%lu Course Saved",(unsigned long)arrData.count];
        } else {
            showAletViewWithMessage(kFailAPI);
        }
    }
    if (arrData.count == 0) {
        viewEmpty.hidden = false;
    }else{
        viewEmpty.hidden = YES;
    }
    
}

-(IBAction)btnFindCourses:(UIButton*)sender {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:false];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"course_detail"])
    {
        CourseDetailsVC *vc =(CourseDetailsVC *) segue.destinationViewController;
        NSIndexPath *path = (NSIndexPath*) sender;
        FavCourse *course = [arrData objectAtIndex:path.row];
        vc.NID = course.nid;
    }
}
- (void) orientationChanged:(NSNotification *)note
{
    [collectionView reloadData];
}

#pragma mark - UICollectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1.0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return is_iPad()?arrData.count:0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //415 * _screen/1024
    return CGSizeMake((415 * _screenSize.width)/1024, (265 * _screenSize.height)/768);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)colectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavCollectionCell * cell = [colectionView dequeueReusableCellWithReuseIdentifier:@"CellCourse" forIndexPath:indexPath];
    if (indexPath.row == selectedRow) {
        cell.viewAction.hidden = false;
    }else{
        cell.viewAction.hidden = true;
    }
    
    FavCourse *entity = [arrData objectAtIndex:indexPath.row];
    cell.rateView.rating = [entity.vote_result floatValue];
    if (entity.image) {
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:entity.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    cell.lblTittle.text = entity.title;
    cell.lblCity.text = entity.city;
    cell.lblPrice.text = entity.price;
    cell.lblReview.text = [NSString stringWithFormat:@"%@ Review",entity.review_count];
    cell.lblUpdate.text = entity.lastUpdate;
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow == indexPath.row) {
        selectedRow = -1;
    }else{
        selectedRow = indexPath.row;
    }
    [collectionView reloadData];
}
-(IBAction)btnUnFav:(UIButton *)sender
{
    FavCourse *course = [arrData objectAtIndex:sender.tag];
    [self removeFav:course];
    
}

#pragma mark UITableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return is_iPad()?0:arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = (MGSwipeTableCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lblCourse = [cell viewWithTag:11];
    UILabel *lblCity = [cell viewWithTag:13];
    UILabel *lblPrice = [cell viewWithTag:14];
    UILabel *lblReview = [cell viewWithTag:15];
    
    UIImageView *img = [cell viewWithTag:12];
    RateView *rate = [cell viewWithTag:16];
    rate.starSize = 15;
    rate.starNormalColor = [UIColor grayColor];
    rate.starFillColor = UIColorFromRGB(0xffba00);
    rate.starBorderColor = [UIColor darkGrayColor];
    rate.starNormalColor = [UIColor clearColor];
    
    FavCourse *entity = [arrData objectAtIndex:indexPath.row];
    if ([self checkStringValue:entity.vote_result]) {
        rate.rating = [entity.vote_result floatValue];
    }
    
    
    if (entity.image)
    {
        [img sd_setImageWithURL:[NSURL URLWithString:entity.image]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    lblCourse.text = entity.title;
    lblCity.text = entity.city;
    lblPrice.text = entity.price;
    lblReview.text =  [NSString stringWithFormat:@"%@ Reviews",entity.review_count];
    
    MGSwipeButton *btnDelete = [MGSwipeButton buttonWithTitle:@"delete" backgroundColor:UIColorFromRGB(0xfe347e) callback:^BOOL(MGSwipeTableCell *sender) {
        FavCourse *course = [arrData objectAtIndex:indexPath.row];
        [self removeFav:course];
        return YES;
    }];
    
    cell.rightButtons = @[btnDelete];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
    
}


-(void) removeFav:(FavCourse*)course
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAppName message:@"Do you want to un-favourite this course?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* Yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              NSDictionary *dict =@{@"action":@"unflag", @"flag_name":@"favorite_flag_on_courses", @"entity_id":course.nid };
                              
                              [self startActivity];
                              [[NetworkManager sharedInstance] postRequestUrl:apifavFlagUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
                                  [self stopActivity];
                                  if (result == WebServiceResultSuccess)
                                  {
                                      [self getFavCourses];
                                      
                                  }else{
                                      showAletViewWithMessage(@"Error occurs,Please try again.");
                                  }
                                  
                              }];
                              
                          }];
    UIAlertAction* No = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             
                             
                         }];
    [alertController addAction:Yes];
    [alertController addAction:No];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
