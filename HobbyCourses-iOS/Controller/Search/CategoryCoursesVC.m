//
//  CategoryCoursesVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CategoryCoursesVC.h"

@interface CategoryCoursesVC (){

    IBOutlet UICollectionView *collectionResultView;
    IBOutlet UILabel *lblpath;
    IBOutlet UILabel *lblExplorer;
    NSMutableArray<Course*> *arrCourses;
}

@end

@implementation CategoryCoursesVC
@synthesize pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex = 0;
    arrCourses = [NSMutableArray new];
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    if(!is_iPad()) {
        lblScreenTitle.text = [NSString stringWithFormat:@"%@ -> %@",self.category,self.subCategory];
        [self getCourseApiSimpleSearch];
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Category Screen"];
}

#pragma mark- UIButton 
-(IBAction)btnOpneMapView:(UIButton*)sender {
    NSIndexPath *index = [[NSIndexPath new] indexPathForCellContainingView:sender inTableView:tblParent];
    [self performSegueWithIdentifier:@"segueMap" sender:arrCourses[index.row]];
}
-(IBAction)btnOpneTimingView:(UIButton*)sender {
    NSIndexPath *index = [[NSIndexPath new] indexPathForCellContainingView:sender inTableView:tblParent];
    [self getCourseDetails:arrCourses[index.row].nid];
}
-(IBAction)btnOpneCityView:(UIButton*)sender {
    CourseListingVC_iPad * vc = (CourseListingVC_iPad*)self.parentViewController;
    [vc btnOpenCitySectionPopUp:sender];
}

#pragma mark -API Call
-(void) getCourseDetails:(NSString *) courseNID
{
    [self startActivity];
    [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@",apiCourseDetailUrl,courseNID] paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *d = [jsonData mutableCopy];
                [d handleNullValue];
                CourseDetail *courseEntity = [[CourseDetail alloc]initWith:d];
                [self performSegueWithIdentifier:@"segueBatches" sender:courseEntity];
            }
        }
    }];
}
-(void) getCourseApiSimpleSearch {
    
    if(is_iPad()){
        NSString *str = [NSString stringWithFormat:@"%@ / ",self.category];
        NSAttributedString *attrStr  = [[NSAttributedString alloc] attributedText:@[str,self.subCategory] attributes:@[@{NSFontAttributeName : [UIFont systemFontOfSize:30.0]},@{ NSForegroundColorAttributeName : __THEME_GREEN}]];
        lblpath.attributedText = attrStr;
        lblCity.text = APPDELEGATE.selectedCity;
    }
    
    pageIndex = pageIndex + 1;
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"postal_code"] = APPDELEGATE.selectedCity;
    dict[@"category"] = self.category;
    dict[@"distance"] = @5;
    dict[@"sorting"] = APPDELEGATE.sortCourseBy;
    dict[@"sub_category"] = self.subCategory;

    dict[@"page"] = [NSString stringWithFormat:@"%d",pageIndex];
    
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            
            if ([jsonData isKindOfClass:[NSArray class]]) {
                if (pageIndex == 1) {
                    [arrCourses removeAllObjects];
                }
                
                for (NSDictionary *dict in jsonData) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        NSString *nid = d[@"nid"];
                        NSPredicate *pred =[NSPredicate predicateWithFormat:@"self.nid == %@",nid];
                        if([arrCourses filteredArrayUsingPredicate:pred].count == 0) {
                            Course *courseEnt = [[Course alloc]initWith:d];
                            [arrCourses addObject:courseEnt];
                        }
                    }
                }
                
                if (arrCourses.count < 10) {
                    pageIndex = -1;
                }else{
                    pageIndex = pageIndex + 1;
                }
            }else {
                pageIndex =  1;
                if ([jsonData isKindOfClass:[NSString class]]){
                    showAletViewWithMessage(jsonData);
                }else{
                    showAletViewWithMessage(kFailAPI);
                }
            }
            [collectionResultView reloadData];
            [tblParent reloadData];
            
            
        }else {
            pageIndex = pageIndex - 1;
            showAletViewWithMessage(@"If at first you don’t succeed…please select Course for selected criteria and try again.");
        }
    }];
}

#pragma mark- UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrCourses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblTitle = [cell viewWithTag:11];
    UIImageView *imgV = [cell viewWithTag:12];
    UILabel *lblPrice = [cell viewWithTag:13];
    UILabel *lblLocation = [cell viewWithTag:14];
    UILabel *lblDays = [cell viewWithTag:15];
    Course* course = [arrCourses objectAtIndex:indexPath.row];
    [imgV sd_setImageWithURL:[NSURL URLWithString:(course.images.count > 0) ? [course.images firstObject] : @""]
            placeholderImage:_placeHolderImg];
    lblTitle.text = course.title;
    lblDays.text =  [NSString stringWithFormat:@"%@ %@",getDays(course),getTime(course)];
    if (course.productArr.count > 0) {
        ProductEntity * obj = course.productArr[0];
        lblPrice.text = obj.initial_price;
    }
    lblLocation.text = course.city;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    Course *obj = arrCourses[indexPath.row];
    [self performSegueWithIdentifier:@"segueDetails" sender:obj.nid];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 5.0 && pageIndex != -1) {
        [self getCourseApiSimpleSearch];
    }
}

#pragma mark - UICollectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1.0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrCourses.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.01;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.01;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //415 * _screen/1024
    //return CGSizeMake(400 * _screenSize.width/1024, 420);
    return CGSizeMake((_screenSize.width - 120) / 3, (_screenSize.width - 120)/3);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)colectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [colectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *lblTitle = [cell viewWithTag:11];
    UIImageView *imgV = [cell viewWithTag:12];
    UILabel *lblPrice = [cell viewWithTag:13];
    UILabel *lblLocation = [cell viewWithTag:14];
    UILabel *lblDays = [cell viewWithTag:15];
    Course* course = [arrCourses objectAtIndex:indexPath.row];
    [imgV sd_setImageWithURL:[NSURL URLWithString:(course.images.count > 0) ? [course.images firstObject] : @""]
            placeholderImage:_placeHolderImg];
    lblTitle.text = course.title;
    lblDays.text =  [NSString stringWithFormat:@"%@ %@",getDays(course),getTime(course)];
    if (course.productArr.count > 0) {
        ProductEntity * obj = course.productArr[0];
        lblPrice.text = obj.initial_price;
    }
    lblLocation.text = course.city;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView reloadData];
    Course *obj = arrCourses[indexPath.row];
    [self performSegueWithIdentifier:@"segueDetails" sender:obj.nid];
    
}

#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.destinationViewController isKindOfClass:[CourseDetailsVC class]]) {
         CourseDetailsVC *vc = segue.destinationViewController;
         vc.NID = sender;
//         vc.similerCourses = arrCourses;
     }else if ([segue.destinationViewController isKindOfClass:[CourseDetailsVC_iPad class]]) {
         CourseDetailsVC_iPad *vc = segue.destinationViewController;
         vc.NID = sender;
//         vc.similerCourses = arrRecentCourse;
     } else if ([segue.identifier isEqualToString:@"segueMap"]) {
         CourseLocationViewController *vc = segue.destinationViewController;
         vc.arrayCourseList = @[sender];
         
     } else if ([segue.identifier isEqualToString:@"segueBatches"]){
         CourseDetailBatchVC *vc = segue.destinationViewController;
         CourseDetail *courseEntity = (CourseDetail*)sender;
         vc.arrBatches = courseEntity.productArr;
         vc.courseEntity = courseEntity;
     }
 }


@end
