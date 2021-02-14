//
//  CourseReviewVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 03/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseReviewVC.h"

@interface CourseReviewVC ()
{
    NSMutableArray<Review*> *arrReviews;
    int commentPageIndex;
}
@end

@implementation CourseReviewVC
@synthesize nid;
- (void)viewDidLoad {
    [super viewDidLoad];
    commentPageIndex = 0;
    arrReviews = [NSMutableArray new];
    tblParent.estimatedRowHeight = 175;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    [self getCommentsData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course Review List Screen"];
}

#pragma mark - API Calls

-(void) getCommentsData {
    if (![self isNetAvailable]) {
        NSData *data = [UserDefault objectForKey:[self uniqueCommentId]];
        if (data) {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseComment:jsonData];
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
            if (arrData && arrData.count>0) {
                if (commentPageIndex == 0) {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:[self uniqueCommentId]];
                    [UserDefault synchronize];
                    [arrReviews removeAllObjects];
                }
                for(NSDictionary *dict in arrData) {
                    if ([dict valueForKey:@"node"]) {
                        Review *review = [[Review alloc]initWith:[dict valueForKey:@"node"]];
                        [arrReviews addObject:review];
                    }
                }
            }
            
            if (arrData.count < 10) {
                commentPageIndex = -1;
            }else{
                commentPageIndex = commentPageIndex + 1;
            }
            [tblParent reloadData];
        }
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrReviews.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Review* review = [arrReviews objectAtIndex:indexPath.row];
    ReviewTableViewCell *cell;
    if (review.imagesArr.count > 0) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCell" forIndexPath:indexPath];
    }
    [cell setData:review];
    return cell;
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
