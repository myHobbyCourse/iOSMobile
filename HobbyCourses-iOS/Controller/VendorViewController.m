//
//  VendorViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "VendorViewController.h"

@interface VendorViewController () {
    IBOutlet UICollectionView *cvCourses;
    NSMutableArray *arrData;
    int pageIndex;
}
@end

@implementation VendorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex = 1;
    arrData = [[NSMutableArray alloc]init];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    lblVendorName.text = [NSString stringWithFormat:@"%@ SELLER OTHER COURSES",self.verndorName.uppercaseString];
    [self performSelector:@selector(getEducatorCourses) withObject:self afterDelay:0.5];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Vendor Other Courses Screen"];
}
-(void) getEducatorCourses
{
    [self startActivity];
    [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@/post_date/desc/%@",apiEducatorCourseUrl,self.verndorID,[NSString stringWithFormat:@"%d",pageIndex]] paramter:nil isToken:true withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                if (pageIndex == 0)
                {
                    [arrData removeAllObjects];
                }
                for (NSDictionary *dict in jsonData)
                {
                    if ([dict isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        CourseDetail *courseEnt = [[CourseDetail alloc]initWith:d];
                        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.nid == %@",courseEnt.nid];
                        if([arrData filteredArrayUsingPredicate:predicate].count == 0){
                            [arrData addObject:courseEnt];
                        }
                        
                    }
                }
                lblCourseCount.text = [NSString stringWithFormat:@"%d courses availble",arrData.count];
            }
            NSArray *arr = jsonData;
            if (arr.count < 10)
            {
                pageIndex = -1;
            }else{
                pageIndex = pageIndex + 1;
            }
            [tblParent reloadData];
            [cvCourses reloadData];
        } else {
            showAletViewWithMessage(kFailAPI);
        }
    }];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 3.0 && pageIndex != -1 )
    {
        [self getEducatorCourses];
        
    }
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblTile = [cell viewWithTag:11];
    UIImageView *imgV = [cell viewWithTag:12];
    UILabel *lblCity = [cell viewWithTag:13];
    UILabel *lblPrice = [cell viewWithTag:14];
    UILabel *lblReviewCount = [cell viewWithTag:15];
    RateView *rate = [cell viewWithTag:16];
    rate.starSize = 20;
    rate.starNormalColor = [UIColor grayColor];
    rate.starFillColor = UIColorFromRGB(0xffba00);
    rate.starBorderColor = [UIColor darkGrayColor];
    rate.starNormalColor = [UIColor clearColor];
    
    CourseDetail *course = arrData[indexPath.row];
    lblTile.text = course.title;
    
    if (course.course_rating) {
        rate.rating = [course.course_rating floatValue];
    }else{
        rate.rating = 0.0;
    }
    
    if (course.field_deal_image.count > 0) {
        [imgV sd_setImageWithURL:[NSURL URLWithString:course.field_deal_image[0]] placeholderImage:_placeHolderImg];
    }
    lblCity.text = course.city;
    lblReviewCount.text = [NSString stringWithFormat:@"%@ reviews",course.comment_count];
    if(course.productArr.count > 0){
        lblPrice.text = course.productArr[0].initial_price;
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"segueDetails" sender:indexPath];
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
    return CGSizeMake((320 * _screenSize.width)/1024, (190 * _screenSize.height)/768);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)colectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavCollectionCell * cell = [colectionView dequeueReusableCellWithReuseIdentifier:@"CellCourse" forIndexPath:indexPath];
    
    CourseDetail *entity = [arrData objectAtIndex:indexPath.row];
    cell.rateView.rating = [entity.course_rating floatValue];
    if (entity.field_deal_image.count > 0) {
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:entity.field_deal_image[0]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    cell.lblTittle.text = entity.title;
    cell.lblCity.text = entity.city;
    cell.lblReview.text = @"Review";
    cell.rateView.starSize = 15;
    cell.lblUpdate.text = entity.last_updated;
    if (entity.productArr.count > 0) {
        cell.lblPrice.text = entity.productArr[0].price;
    }else{
        cell.lblPrice.text = @"-";
    }
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueDetails" sender:indexPath];
}
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation segueDetails
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"segueDetails"])
     {
         CourseDetailsVC *view = segue.destinationViewController;
         NSIndexPath *index = sender;
         CourseDetail *entity  = [arrData objectAtIndex:index.row];
         view.NID = entity.nid;
     }
 }


@end
