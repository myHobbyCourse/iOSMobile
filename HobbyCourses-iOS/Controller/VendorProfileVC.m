//
//  VendorProfileVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 17/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "VendorProfileVC.h"

@interface VendorProfileVC (){
    NSMutableArray<Review*> *arrReviews;
    NSString *strTitle ;
}
@end

@implementation VendorProfileVC
@synthesize arrTuttors,arrVenues;

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 300;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    arrTuttors = [NSMutableArray new];
    arrVenues = [NSMutableArray new];
    arrReviews = [NSMutableArray new];
    strTitle = @"";
    if (self.courseEntity) {
        self.uid = self.courseEntity.author_uid;
        strTitle = self.courseEntity.title;
    }
    [self getVendorProfile];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Tutor Profile Screen"];
}

#pragma mark - UIButton Action
-(IBAction)btnReadMore:(UIButton*)sender {
    if (sender.selected) {
        sender.selected = false;
    }else{
        sender.selected = true;
    }
    
    [tblParent reloadData];
}
#pragma mark - UITableDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.courseEntity == nil) {
        return 0;
    }
    switch (indexPath.row) {
        case 1:
            if ([self checkStringValue:self.courseEntity.educator_introduction]) {
                return 0;
            }
            break;
            
        case 3:
            if ([self checkStringValue:self.courseEntity.certifications]) {
                return 0;
            }
            break;
        case 5:{
            if (arrTuttors.count == 0) {
                return 0;
            }
            break;
        }
        case 6:{
            if (arrVenues.count == 0) {
                return 0;
            }
            break;
        case 7:
            if (arrReviews.count == 0) {
                return 0;
            }
            break;
        }
            
        default:
            break;
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VendorCell * cell;
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row+1];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.controller =self;
    switch (indexPath.row) {
        case 0: {
            [cell.imgVendor sd_setImageWithURL:[NSURL URLWithString:self.courseEntity.author_image] placeholderImage:_placeHolderImg];
            cell.lblName.text = self.courseEntity.author;
            cell.lblSince.text = [NSString stringWithFormat:@"Member since %@",self.courseEntity.member_since];
            
        }   break;
        case 1:
        {
            cell.lblDesc.text = self.courseEntity.educator_introduction;
            CGRect rect = [self.courseEntity.educator_introduction getStringHeight:_screenSize.width - 40 font:[UIFont systemFontOfSize:17]];
            UIButton *btnMore = [cell viewWithTag:42];
            btnMore.hidden = true;
            if (rect.size.height > 40) {
                btnMore.hidden = false;
            }
            if (btnMore.selected) {
                cell.lblDesc.numberOfLines = 0;
            }else{
                cell.lblDesc.numberOfLines = 2;
            }
            
        }   break;
        case 2: {
            
            UIImageView *imgV1 = [cell viewWithTag:135];
            UIImageView *imgV2 = [cell viewWithTag:136];
            UIImageView *imgV3 = [cell viewWithTag:137];
            UIImageView *imgV4 = [cell viewWithTag:138];
            UIImageView *imgV5 = [cell viewWithTag:139];
            UIImageView *imgV6 = [cell viewWithTag:140];
            
            if ([self.courseEntity.email_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV1.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV1.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([self.courseEntity.landline_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV3.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV3.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([self.courseEntity.address_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV5.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else {
                imgV5.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([self.courseEntity.mobile_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV2.image = [UIImage imageNamed:@"ic_c_red_tip"];
                
            }else{
                imgV2.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([self.courseEntity.social_media_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV4.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV4.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([self.courseEntity.credit_card_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV6.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV6.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            
        }   break;
        case 3: {
            cell.lblCertificate.text = self.courseEntity.certifications;
            CGRect rect = [self.courseEntity.certifications getStringHeight:_screenSize.width - 40 font:[UIFont systemFontOfSize:16]];
            UIButton *btnMore = [cell viewWithTag:92];
            btnMore.hidden = true;
            if (rect.size.height > 40) {
                btnMore.hidden = false;
            }
            if (btnMore.selected) {
                cell.lblCertificate.numberOfLines = 0;
            }else{
                cell.lblCertificate.numberOfLines = 2;
            }
        }   break;
        case 5:{
            [cell.cvTutor reloadData];
        }   break;
        case 6:{
            [cell.cvLocation reloadData];
        }   break;
        case 7:{
            
            if (arrReviews.count > 0) {
                [cell.imgVCommentUser sd_setImageWithURL:[NSURL URLWithString:arrReviews[0].avatar] placeholderImage:_placeHolderImg];
                cell.imgVCommentUser.layer.cornerRadius = cell.imgVCommentUser.frame.size.width/2;
                cell.imgVCommentUser.layer.masksToBounds = YES;
                cell.lblComment.text = arrReviews[0].comment;
                cell.lblCommetUser.text = arrReviews[0].author;
                cell.lblCommentDate.text = arrReviews[0].post_date;
                
                cell.lblCommentCount.text = [NSString stringWithFormat:@"%lu %@",(unsigned long)arrReviews.count,(arrReviews.count > 1) ? @"Reviews" : @"Review"];
            }            
        }   break;
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        [self performSegueWithIdentifier:@"segueReview" sender:self];
    }
}
#pragma mark- Other
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > (180 * _widthRatio)) {
        viewTop.alpha = 1.0;
        [btnBack setTintColor:[UIColor blackColor]];
    }else{
        viewTop.alpha = 0.0;
        [btnBack setTintColor:[UIColor whiteColor]];
    }
}
#pragma mark API Calls
-(void) getVendorProfile
{
    if (![self isNetAvailable]) {
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:@"http://myhobbycourses.com/myhobbycourses_endpoint/user_details_service/get_info" paramter:@{@"uid":self.uid} withCallback:^(id jsonData, WebServiceResult result)
     {
         [self stopActivity];
         NSLog(@"%@",jsonData);
         if (result == WebServiceResultSuccess) {
             if ([jsonData isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = jsonData;
                 NSMutableDictionary *d = [dict mutableCopy];
                 [d handleNullValue];
                 UserDetail *obj = [[UserDetail alloc]initWith:d];
                 self.courseEntity = [CourseDetail new];
                 self.courseEntity.author_uid = obj.uid;
                 self.courseEntity.educator_introduction = obj.educator_introduction;
                 self.courseEntity.member_since =  obj.created;
                 self.courseEntity.author_image = obj.user_picture;
                 self.courseEntity.author = obj.name;
                 self.courseEntity.email_verified_flagged = obj.email_verified_flagged;
                 self.courseEntity.landline_verified_flagged = obj.landline_verified_flagged;
                 self.courseEntity.address_verified_flagged = obj.address_verified_flagged;
                 self.courseEntity.mobile_verified_flagged = obj.mobile_verified_flagged;
                 self.courseEntity.social_media_verified_flagged = obj.social_media_verified_flagged;
                 self.courseEntity.credit_card_verified_flagged = obj.credit_card_verified_flagged;
                 self.courseEntity.qrcode_vendor = obj.qr_code;
                 self.courseEntity.address_1 = obj.address;
                 self.courseEntity.address_2 = obj.address_2;
                 self.courseEntity.city = obj.city;
                 self.courseEntity.postal_code = obj.postal_code;
                 self.courseEntity.title = strTitle;
                [self getTutorList];
             }
         }else{
             [self showAlertWithTitle:kAppName forMessage:kFailAPI];
         }
     }];
}
-(void) getTutorList {
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiTutorList paramter:@{@"uid":self.courseEntity.author_uid,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                TutorsEntity * objTutor = [[TutorsEntity alloc]initWith:d];
                [arrTuttors addObject:objTutor];
            }
            [tblParent reloadData];
        }
        [self getVenueList];
    }];
    
}
-(void) getVenueList {
    [self startActivity];
    //self.courseEntity.author_uid //@"396"
    [[NetworkManager sharedInstance] postRequestUrl:apiVenueList paramter:@{@"uid":self.courseEntity.author_uid,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                VenuesEntity * objTutor = [[VenuesEntity alloc]initWith:d];
                [arrVenues addObject:objTutor];
            }
            [tblParent reloadData];
        }
        [self getAllComment];
        
    }];
}
-(void) getAllComment
{
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestFullUrl:[NSString stringWithFormat:@"%@%@",apiSellerReviewUrl,self.courseEntity.author_uid] paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
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
                        [tblParent reloadData];
                    }
                }
            }
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toMsg"]){
        if (is_iPad()){
            MessagesViewController *view = segue.destinationViewController;
            view.isNewthread = true;
            view.couseEntity = self.courseEntity;
            view.isBackArrow = true;
        }else{
            ConversationViewController *view = segue.destinationViewController;
            view.isNewthread = true;
            view.couseEntity = self.courseEntity;
        }
    }else if([segue.identifier isEqualToString:@"GoToVendor"]) {
        VendorViewController *vc = segue.destinationViewController;
        vc.verndorID = self.courseEntity.author_uid;
        vc.verndorName = self.courseEntity.author;
    }else if ([segue.identifier isEqualToString:@"GoToWriteReview"]){
        WriteReviewViewController *postReviewController = segue.destinationViewController;
        postReviewController.isEditMode = NO;
        postReviewController.NID = self.courseEntity.nid;
        postReviewController.courseTittle = self.courseEntity.title;
        [postReviewController getRefreshBlock:^(NSString *anyValue) {
            [self getAllComment];
        }];
    }else if ([segue.identifier isEqualToString:@"segueReview"]){
        CommentListVC *vc = segue.destinationViewController;
        vc.nidComment = self.courseEntity.author_uid;
        vc.courseTittle = self.courseEntity.title;
        vc.isAllReview = true;
    }else if ([segue.identifier isEqualToString:@"venueDetail"]){
        VenueDetailsVC *vc = segue.destinationViewController;
        vc.isFromDetails = true;
        vc.venue = sender;
    }else if ([segue.identifier isEqualToString:@"tutorDetail"]){
        TutorDetailsVC *vc = segue.destinationViewController;
        vc.isFromDetails = true;
        vc.tutor = sender;
    }else if([segue.destinationViewController isKindOfClass:[QRScanPopVC class]]) {
        QRScanPopVC *vc = segue.destinationViewController;
        vc.courseObj = self.courseEntity;
    }
}

@end
