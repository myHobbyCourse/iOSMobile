//
//  SalesDashBoardVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SalesDashBoardVC.h"

@interface SalesDashBoardVC () {
    NSString *strAuthorID;
    NSMutableArray *arrData;
}
@end

@implementation SalesDashBoardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = [[NSMutableArray alloc]init];
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    [self getDashboardInfo];
    if (!self.isHideBackBtn)
        btnBack.hidden = true;
        
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Sales dashboard Screen"];
}

-(BOOL)hidesBottomBarWhenPushed {
    return false;
}
#pragma mark API Calls
-(void) getDashboardInfo {
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiSalesDash paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if([jsonData isKindOfClass:[NSDictionary class]]) {
                [arrData addObject:[NSString stringWithFormat:@"%@",jsonData[@"total_batches_number"]]];
                
                [arrData addObject:[NSString stringWithFormat:@"%@",jsonData[@"total_sold_number"]]];
                
                lblMyTotalRevenue.text = [NSString stringWithFormat:@"£ %@",jsonData[@"total_sum"]];
                [tblParent reloadData];
                [self getAllComment:[NSString stringWithFormat:@"%@",jsonData[@"vendor_uid"]]];
            }
        }
    }];
}

-(void) getAllComment:(NSString *) authorId
{
    if ([authorId isKindOfClass:[NSString class]]) {
        strAuthorID = authorId;
        [self startActivity];
        [[NetworkManager sharedInstance] postRequestFullUrl:[NSString stringWithFormat:@"%@%@",apiSellerReviewUrl,authorId] paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
            [self stopActivity];
            if (result == WebServiceResultSuccess)
            {
                if ([jsonData isKindOfClass:[NSDictionary class]])
                {
                    if ([jsonData valueForKey:@"nodes"])
                    {
                        NSArray *arrData1 = [jsonData valueForKey:@"nodes"];
                        lblMyReview.text = [NSString stringWithFormat:@"%d",arrData1.count];
                        [arrData addObject:[NSString stringWithFormat:@"%d",arrData1.count]];
                        
                    }
                }
            }else{
                showAletViewWithMessage(kFailAPI);
            }
            [tblParent reloadData];
        }];
        
    }
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblTitle = [cell viewWithTag:11];
    UILabel *lblValue = [cell viewWithTag:12];
    UIImageView *imgV = [cell viewWithTag:13];
    switch (indexPath.row) {
        case 0:
            lblTitle.text = @"My Courses";
            lblValue.text = arrData[indexPath.row];
            imgV.image = [UIImage imageNamed:@"ic_ss_mycourse"];
            break;
        case 1:
            lblTitle.text = @"Booking";
            lblValue.text = arrData[indexPath.row];
            imgV.image = [UIImage imageNamed:@"ic_ss_cart"];
            break;
        case 2:
            lblTitle.text = @"Reviews";
            imgV.image = [UIImage imageNamed:@"ic_ss_review"];
            lblValue.text = arrData[indexPath.row];
            break;
            
        default:
            break;
    }
    if (is_iPad()) {
        UILabel *lineBase = [cell viewWithTag:20];
        UILabel *lineRed = [cell viewWithTag:21];
        UILabel *lineYellow = [cell viewWithTag:22];
        UILabel *lineblue = [cell viewWithTag:23];
        UILabel *lineGreen = [cell viewWithTag:24];
        
        UILabel *l1 = [cell viewWithTag:31];
        UILabel *l2 = [cell viewWithTag:32];
        UILabel *l3 = [cell viewWithTag:33];
        UILabel *l4 = [cell viewWithTag:34];
        UILabel *l5 = [cell viewWithTag:35];
        
        UIImageView *imgVPin = [cell viewWithTag:991];
        UILabel *lblProgress = [cell viewWithTag:992];

        lineRed.hidden = false;
        lineYellow.hidden = false;
        lineblue.hidden = false;
        lineGreen.hidden = false;
        
        l1.hidden = false;
        l2.hidden = false;
        l3.hidden = false;
        l4.hidden = false;
        l5.hidden = false;
        
        lblProgress.hidden = false;
        imgVPin.hidden = false;
        
        [cell layoutIfNeeded];
        int questionSize = lineBase.frame.size.width / [[arrData firstObject] intValue];
        int progress =  [arrData[indexPath.row] intValue] * questionSize;
        imgVPin.frame = CGRectMake((lineBase.frame.origin.x + progress) - 25, lineBase.frame.origin.y - 35, 50, 40);
        int mm = (lineBase.frame.origin.x + progress);
        if (mm < lineYellow.frame.origin.x) {
            imgVPin.tintColor = [UIColor redColor];
        }else if(mm < lineblue.frame.origin.x){
            imgVPin.tintColor = [UIColor yellowColor];
        }else if(progress < lineGreen.frame.origin.x){
            imgVPin.tintColor = [UIColor blueColor];
        }else{
            imgVPin.tintColor = [UIColor greenColor];
        }
        
        lblProgress.frame = CGRectMake(imgVPin.frame.origin.x + (imgVPin.frame.size.width - 10), imgVPin.frame.origin.y, imgVPin.frame.size.width, imgVPin.frame.size.height);
      
        switch (indexPath.row) {
            case 0:{
                lineRed.hidden = true;
                lineYellow.hidden = true;
                lineblue.hidden = true;
                lineGreen.hidden = true;
                
                lblProgress.hidden = true;
                imgVPin.hidden = true;
                
                l1.hidden = true;
                l2.hidden = true;
                l3.hidden = true;
                l4.hidden = true;
                l5.hidden = true;
            }   break;
            case 1:{
                float x = [[arrData firstObject] floatValue];
                float y = [arrData[indexPath.row] floatValue];
                float per = (y/x) * 100;
                HCLog(@"%f For Booking",per);
                lblProgress.text = [NSString stringWithFormat:@"%.1f%%",per];
            }
                break;
            case 2:{
                float x = [[arrData firstObject] floatValue];
                float z = [arrData[indexPath.row] floatValue];
                float per = (z/x) * 100;
                HCLog(@"%f For Review",per);
                lblProgress.text = [NSString stringWithFormat:@"%.1f%%",per];
            }
                break;
            case 3:
                break;
                
            default:
                break;
        }
    }
    /*
     int questionSize = 280 / num_possible_question;
     
     int greenProgressSize = green * questionSize;
     
     CGRect greenProgress = CGRectMake( 20, 95, greenProgressSize, 8 );
     cell.greenLabel.frame = greenProgress;
     
     int redProgressSize = (red+green) * questionSize;
     
     CGRect redProgress = CGRectMake( 20, 95, redProgressSize, 8 );
     cell.redLabel.frame = redProgress;
     
     CGRect grayProgress = CGRectMake( 20, 95, 280, 8 );
     cell.grayLabel.frame = grayProgress;
     */
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"segueMyCourse" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"segueSales" sender:self];
            
            break;
        case 2:
            [self performSegueWithIdentifier:@"segueReview" sender:self];
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueSales"]) {
        SalesStatViewController * vc = segue.destinationViewController;
        vc.isBackActive = true;
    }else if ([segue.identifier isEqualToString:@"segueMyCourse"]) {
        MyCoursesViewController * vc = segue.destinationViewController;
        vc.isBackArrow = true;
    }else{
        CommentListVC *vc =(CommentListVC *) segue.destinationViewController;
        vc.nidComment = strAuthorID;
        vc.courseTittle = @"All reviews";
        vc.isAllReview = true;
    }
}


@end
