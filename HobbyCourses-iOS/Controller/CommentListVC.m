//
//  CommentListVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CommentListVC.h"

@interface CommentListVC ()<ReviewTableViewCellProtocol>
{
    IBOutlet UIView *viewNoReview;

    NSMutableArray<Review*> *arrReviews;
    BOOL isload;
    NSMutableDictionary *dictReviews;
    NSArray *arrdistinctReviewsKeys;
    NSIndexPath *selectedIndex;
    int commentPageIndex;

}
@end

@implementation CommentListVC
@synthesize nidComment,isCourseAllReview,nid;
- (void)viewDidLoad {
    [super viewDidLoad];
    lblCourseTittle.text = @"All Reviews";
    arrReviews = [[NSMutableArray alloc]init];
    tblComments.rowHeight = UITableViewAutomaticDimension;
    tblComments.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 100;
    

    tblParent.tableFooterView = [[UIView alloc]init];
    tblComments.tableFooterView = [[UIView alloc]init];
    
    dictReviews = [NSMutableDictionary new];

    tblComments.hidden = true;
    isload = true;
    [self addShaowForiPad:viewShadow];
    
    if (is_iPad()) {
        avgRateView.starSize = 20;
        avgRateView.starNormalColor = [UIColor grayColor];
        avgRateView.starFillColor = UIColorFromRGB(0xffba00);
        avgRateView.rating = 5.0;
    }
    commentPageIndex = 0;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Comment List Screen"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    if (isload)
    {
        isload = false;
        if (self.isAllReview) {
            [self getAllComment];
        }else if(isCourseAllReview){
            [self getCourseAllComments];
            lblCourseTittle.text = self.courseTittle;
        }else{
            [arrReviews addObject:self.review];
            [tblComments reloadData];
            tblComments.hidden = false;
        }
        [tblComments reloadData];
    }
}

-(void) getCommentDetail
{
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:[NSString stringWithFormat:@"http://myhobbycourses.com/one_comment.json/%@",nidComment] paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
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
                        for (NSDictionary *dict in arrData)
                        {
                            if ([dict valueForKey:@"node"])
                            {
                                Review *review = [[Review alloc]initWith:[dict valueForKey:@"node"]];
                                NSLog(@"review : :%@",review);
                                [arrReviews addObject:review];
                                
                            }
                        }
                        
                        tblComments.hidden = false;
                        [tblComments reloadData];
                        
                    }else{
                        showAletViewWithMessage(@"Weird wallabies…No reviews found");
                    }
                }
            }
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
-(void) getAllComment
{
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:[NSString stringWithFormat:@"%@%@",apiSellerReviewUrl,nidComment] paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSDictionary class]]) {
                if ([jsonData valueForKey:@"nodes"]) {
                    NSArray *arrData = [jsonData valueForKey:@"nodes"];
                    if (arrData && arrData.count>0) {
                        [arrReviews removeAllObjects];
                        for (NSDictionary *dict in arrData) {
                            if ([dict valueForKey:@"node"]) {
                                Review *review = [[Review alloc]initWith:[dict valueForKey:@"node"]];
                                NSLog(@"review : :%@",review);
                                [arrReviews addObject:review];
                            }
                        }
                        
                        arrdistinctReviewsKeys = [arrReviews valueForKeyPath:@"@distinctUnionOfObjects.commented_nid"];
                        for (NSString *name in arrdistinctReviewsKeys) {
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commented_nid = %@", name];
                            NSArray *persons = [arrReviews filteredArrayUsingPredicate:predicate];
                            [dictReviews setObject:persons forKey:name];
                        }
                        if (arrReviews.count > 0) {
                            selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                            
                        }
                        lblReviewCount.text = [NSString stringWithFormat:@"%lu Reviews",(unsigned long)arrReviews.count];
                        tblComments.hidden = false;
                        [tblComments reloadData];
                        [tblParent reloadData];
                        viewNoReview.hidden = true;
                    }else{
                        viewNoReview.hidden = false;
                        showAletViewWithMessage(@"Weird wallabies…No reviews found");
                    }
                }
            }
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
-(void) getCourseAllComments {
    if (![self isNetAvailable]) {
        NSData *data = [UserDefault objectForKey:[self uniqueCommentId]];
        if (data) {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseComment:jsonData];
        }else{
            viewNoReview.hidden = false;
        }
    }else{
        if (commentPageIndex == -1) {
            commentPageIndex = 0;
        }
        
        [self startActivity];
        [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@?page=%@",apiCommentURL,nid,[NSString stringWithFormat:@"%d",commentPageIndex]] paramter:nil isToken:true withCallback:^(id jsonData, WebServiceResult result)
         {
             [self stopActivity];
             if (result == WebServiceResultSuccess) {
                 [self parseComment:jsonData];
             }else{
                 viewNoReview.hidden = false;
             }
         }];
        
    }
}
-(NSString*) uniqueCommentId
{
    return [NSString stringWithFormat:@"cc%@",nid];
}
-(void) parseComment:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        if ([jsonData valueForKey:@"nodes"]) {
            NSArray *arrData = [jsonData valueForKey:@"nodes"];
            if (arrData) {
                if (commentPageIndex == 0) {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:[self uniqueCommentId]];
                    [UserDefault synchronize];
                    [arrReviews removeAllObjects];
                }
                for(NSDictionary *dict in arrData) {
                    if ([dict valueForKey:@"node"]) {
                        Review *review = [[Review alloc]initWith:[dict valueForKey:@"node"]];
                        review.commented_node_title = self.courseTittle;
                        [arrReviews addObject:review];
                    }
                }
                arrdistinctReviewsKeys = [arrReviews valueForKeyPath:@"@distinctUnionOfObjects.commented_nid"];
                for (NSString *name in arrdistinctReviewsKeys) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commented_nid = %@", name];
                    NSArray *persons = [arrReviews filteredArrayUsingPredicate:predicate];
                    [dictReviews setObject:persons forKey:name];
                }
                if (arrReviews.count > 0) {
                    selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
                    
                }
                lblReviewCount.text = [NSString stringWithFormat:@"%lu Reviews",(unsigned long)arrReviews.count];
                tblComments.hidden = false;
                [tblComments reloadData];
                [tblParent reloadData];
                viewNoReview.hidden = true;
            }
            
            if (arrData.count < 10) {
                commentPageIndex = -1;
            }else{
                commentPageIndex = commentPageIndex + 1;
            }
            [tblComments reloadData];
        }
        if (arrReviews.count == 0) {
            viewNoReview.hidden = false;
        }
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == tblComments) {
        return arrdistinctReviewsKeys.count;
    }else{
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblComments) {
        NSArray *arr = dictReviews[arrdistinctReviewsKeys[section]];
        return arr.count;
    }else{
        return (arrReviews.count > 0) ? 1 : 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == tblComments) {
        NSArray<Review*> *arr = dictReviews[arrdistinctReviewsKeys[section]];
        if (arr.count>0) {
            CGRect rectH = [arr[0].commented_node_title getStringHeight:(_screenSize.width - 30) font:[UIFont systemFontOfSize:17]];
            return rectH.size.height + 20;
        }
    }
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == tblComments) {
        UITableViewCell * header = [tableView dequeueReusableCellWithIdentifier:@"CellHeader"];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *lbl1 = [header viewWithTag:11];
        NSArray<Review*> *arr = dictReviews[arrdistinctReviewsKeys[section]];
        if (arr.count>0) {
            lbl1.text = arr[0].commented_node_title;
        }
        header.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        return header;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblComments) {
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCell"];
        NSArray<Review*> *arr = dictReviews[arrdistinctReviewsKeys[indexPath.section]];
        Review* review = [arr objectAtIndex:indexPath.row];
        UILabel *lbl = [cell viewWithTag:99];
        lbl.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        
        [cell setData:review];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCell"];
        NSArray<Review*> *arr = dictReviews[arrdistinctReviewsKeys[selectedIndex.section]];
    
        Review* review = [arr objectAtIndex:selectedIndex.row];
        UILabel *lbl = [cell viewWithTag:99];
        lbl.text = @"";//[NSString stringWithFormat:@"%ld",indexPath.row+1];
        
        [cell setData:review];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath;
    [tblComments reloadData];
    [tblParent reloadData];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 1.0 && commentPageIndex != -1 && isCourseAllReview) {
        [self getCourseAllComments];
    }
}
-(IBAction)btnBack:(id)sender
{
    if (is_iPad())
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void) imageTapped:(NSString *)index
{
    ImageZoomViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ImageZoomViewController"];
    vc.arrData = @[index];
    [self presentViewController:vc animated:YES completion:nil];
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
