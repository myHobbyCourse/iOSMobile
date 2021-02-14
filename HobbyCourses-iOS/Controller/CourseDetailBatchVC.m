//
//  CourseDetailBatchVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 02/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseDetailBatchVC.h"

@interface CourseDetailBatchVC ()
{
    NSMutableSet* _collapsedSections;
}
@end

@implementation CourseDetailBatchVC
@synthesize arrBatches;
- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 80;
    _collapsedSections = [NSMutableSet new];
    
    NSArray *sortedArray;
    sortedArray = [arrBatches sortedArrayUsingComparator:^NSComparisonResult(ProductEntity *a, ProductEntity *b) {
        NSDate *first = [globalDateOnlyFormatter() dateFromString:a.course_start_date];
        NSDate *second = [globalDateOnlyFormatter() dateFromString:b.course_start_date];
        return [first compare:second];
    }];
    [arrBatches removeAllObjects];
    [arrBatches addObjectsFromArray:sortedArray];
    [self insertTimesForBatches];
    self.navigationItem.title = @"Course Batches";
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course Batches Screen"];
}
-(void) insertTimesForBatches {
    
    NSDateFormatter *format11 = [[NSDateFormatter alloc]init];
    [format11 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDateFormatter *format33 = [[NSDateFormatter alloc]init];
    [format33 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDateFormatter *format22 = [[NSDateFormatter alloc]init];
    [format22 setDateFormat:@"yyyy-MM-dd"];
    
    for (ProductEntity *produce in arrBatches) {
        for(TimeBatch *obj in produce.timingsDate) {
            if (obj.batch_start_date && obj.batch_end_date) {
                NSString  *startDate = [format33 stringFromDate:obj.batch_start_date];
                NSString *endDate = [format33 stringFromDate:obj.batch_end_date];
                NSString *compare = [format22 stringFromDate:obj.batch_start_date];
                [TempStore insertTimesFrom:startDate to:endDate Compare:compare UUID:produce.product_id];
            }
        }
    }
    
}

-(IBAction)btnSortBatches:(UIButton*)sender {
    [AppUtils actionWithMessage:@"Sort Batch By" withMessage:@"" alertType:UIAlertControllerStyleActionSheet button:@[@"Start Date",@"End Date",@"Price"] controller:self block:^(NSString *tapped) {
        
    }];
}
-(void)sectionButtonTouchUpInside:(UIButton*)sender {
    NSInteger section = sender.tag;
    bool shouldCollapse = ![_collapsedSections containsObject:@(section)];
    if (shouldCollapse) {
        [_collapsedSections addObject:@(section)];
    } else {
        [_collapsedSections removeObject:@(section)];
    }
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:section];
    [tblParent reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void) bookCourse:(UIButton*) sender {
    if (self.courseEntity == nil) {
        return;
    }
    if (APPDELEGATE.userCurrent.isVendor) {
        showAletViewWithMessage(@"Tutor are not allowed to buy any course.Please register as Leaner to buy courses");
        return;
    }
    UIStoryboard *mainStoryboard = getStoryBoardDeviceBased(StoryboardMain);
    HCLog(@"Section: %ld",sender.tag);
    
    ProductEntity *produt =  self.courseEntity.productArr[sender.tag];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"product_id == %@",produt.product_id];
    NSArray *arrBatch =  [self.courseEntity.productArr filteredArrayUsingPredicate:pre];
    if (arrBatch.count > 0) {
        ProductEntity *product = arrBatch[0];
        NSDateFormatter *dateOnly = globalDateOnlyFormatter();
        NSDate *date = [dateOnly dateFromString:product.course_start_date];
        if (date) {
            if ([date compare:[NSDate date]] == NSOrderedSame || [date compare:[NSDate date]] == NSOrderedAscending || [product.sold integerValue] == [product.quantity integerValue])
            {
                showAletViewWithMessage(@"Your selected course sessions have been sold out, but keep looking!");
                return;
            }
            NSMutableArray *arrItem;
            if ([UserDefault objectForKey:@"cartItem"]) {
                arrItem = [[UserDefault objectForKey:@"cartItem"] mutableCopy];
            } else {
                arrItem = [[NSMutableArray alloc]init];
            }
            if (arrItem.count > 4) {
                showAletViewWithMessage(@"Let’s save some for others, there’s a 5 course purchase limit at any given time");
                return;
            }
            
            NSArray * arr = [arrItem filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %@",self.courseEntity.nid]];
            if (arr.count > 0) {
                showAletViewWithMessage(@"No need to double dip, this course already in your shopping cart");
            }else{
                NSString* totalString = [product.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
                if ([totalString intValue] == 0) {
                    showAletViewWithMessage(@"Can't buy course price having 0 value.");
                    return;
                }
                NSDictionary *dict = @{@"category":self.courseEntity.category,@"course_tittle":self.courseEntity.title,@"price":totalString,@"id":self.courseEntity.nid,@"product_id":product.product_id};
                [arrItem addObject:dict];
                [UserDefault setObject:arrItem forKey:@"cartItem"];
            }
            UIViewController  *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ShoppingCartViewController"];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrBatches.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_collapsedSections containsObject:@(section)] ? 1 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (is_iPad()) ? 265 : 270;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!is_iPad()) {
        return 435; //53
    }
    return 601;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"BatchHeader" owner:self options:nil];
    BatchHeaderView *batchHeaderView = [viewArray objectAtIndex:(is_iPad()) ? 3: 0];

    ProductEntity * product = arrBatches[section];
    batchHeaderView.lblStart.text = product.course_start_date;
    batchHeaderView.lblEnd.text = product.course_end_date;
    batchHeaderView.lblSession.text = product.sessions_number;
    batchHeaderView.lblBatch.text = product.batch_size;
    batchHeaderView.lblPrice.text = product.initial_price;
    batchHeaderView.lblSold.text = product.sold;
    batchHeaderView.lblQty.text = product.quantity;
    
    
    [batchHeaderView.btnBook setTitle:@"BOOK COURSE" forState:UIControlStateNormal];
    [batchHeaderView.btnBook setTitleColor:__THEME_lightGreen forState:UIControlStateNormal];
    
    NSDate *date = [globalDateOnlyFormatter() dateFromString:product.course_start_date];
    if (date) {
        if ([date compare:[NSDate date]] == NSOrderedSame || [date compare:[NSDate date]] == NSOrderedAscending || [product.sold integerValue] == [product.quantity integerValue] || [product.quantity integerValue] <= 0)
        {
            [batchHeaderView.btnBook setTitle:@"SOLD OUT" forState:UIControlStateNormal];
            [batchHeaderView.btnBook setTitleColor:ThemEColor forState:UIControlStateNormal];
        }else{
            [batchHeaderView.btnBook addTarget:self action:@selector(bookCourse:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [batchHeaderView.btnExapndSection addTarget:self action:@selector(sectionButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    
    batchHeaderView.btnExapndSection.tag = section;
    batchHeaderView.btnBook.tag = section;
    
    return batchHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductEntity* product = arrBatches[indexPath.section];
    BatchDisplay *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.rowID = product.product_id;
    cell.courseStartDate = product.course_start_date;
    cell.courseEndDate = product.course_end_date;
    cell.weekView.layer.cornerRadius = 20;
    cell.weekView.layer.masksToBounds = true;
    cell.courseName = self.courseEntity.title;
    [cell setData];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _refreshBlock([NSString stringWithFormat:@"%d",indexPath.row]);
    [self dismissViewControllerAnimated:true completion:nil];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;
{
    self.refreshBlock = refreshBlock;
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
