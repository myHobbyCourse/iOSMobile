//
//  CourseShareVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 03/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseShareVC.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface CourseShareVC ()<MFMailComposeViewControllerDelegate>
{
    NSMutableArray<NSString*> *arrImg;
    NSMutableArray<NSString*> *arrTitle;
}
@end

@implementation CourseShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrImg = [[NSMutableArray alloc] initWithObjects:@"ic_c_mail",@"ic_c_fb",@"ic_c_google-plus",@"ic_c_Twitter-Logo",@"ic_c_pin", nil];
    arrTitle = [[NSMutableArray alloc] initWithObjects:@"Email",@"Facebook",@"Google Plus",@"Twitter",@"Pinterest", nil];
    tblParent.estimatedRowHeight = 60;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course Share Screen"];
}
#pragma mark - Share API
- (IBAction) postToPinterest {
    NSString *str;
    if([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
    {
        str = self.courseEntity.field_deal_image;
    }else if ([self.courseEntity.field_deal_image isKindOfClass:[NSArray class]] && self.courseEntity.field_deal_image.count> 0)
    {
        str = self.courseEntity.field_deal_image[0];
    }
    [PDKPin pinWithImageURL:[NSURL URLWithString:str]
                       link:[NSURL URLWithString:@"https://www.pinterest.com"]
         suggestedBoardName:self.courseEntity.title
                       note:self.courseEntity.Description
                withSuccess:^{
                    
                }andFailure:^(NSError *error)
     {
     }];
}
- (void) shareToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *str;
        if([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            str = self.courseEntity.field_deal_image;
        }else if ([self.courseEntity.field_deal_image isKindOfClass:[NSArray class]] && self.courseEntity.field_deal_image.count> 0)
        {
            str = self.courseEntity.field_deal_image[0];
        }
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            
            NSData *theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [controller setInitialText:self.courseEntity.title];
                [controller addImage:[UIImage imageWithData:theData]];
                [self presentViewController:controller animated:YES completion:Nil];
            });
        });
        
    }
    else {
        [self showAlertWithTitle:@"Info" forMessage:@"You don't have configured any Facebook settings, please go to Settings->Facebook and setup you account"];
    }
}

- (void) shareToTwitter {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *str;
        if([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            str = self.courseEntity.field_deal_image;
        }else if ([self.courseEntity.field_deal_image isKindOfClass:[NSArray class]] && self.courseEntity.field_deal_image.count> 0)
        {
            str = self.courseEntity.field_deal_image[0];
        }
        [self startActivity];
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            
            NSData *theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopActivity];
                [tweetSheet setInitialText:self.courseEntity.title];
                [tweetSheet addImage:[UIImage imageWithData:theData]];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            });
        });
    }else {
        [self showAlertWithTitle:@"Info" forMessage:@"You don't have configured any Facebook settings, please go to Settings->Twitter and setup you account"];
    }
}
- (void)shareToGooglePlus
{
    id<GPPShareBuilder> shareBuilder = [self shareBuilder];
    [shareBuilder open];
}

- (id<GPPShareBuilder>)shareBuilder
{
    // End editing to make sure all changes are saved to _shareConfiguration.
    [self.view endEditing:YES];
    
    // Create the share builder instance.
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
    [shareBuilder setPrefillText:self.courseEntity.title];
    
    return shareBuilder;
}
-(void) sendEmail{
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        [mailCont setSubject:self.courseEntity.title];
        [mailCont setMessageBody:self.courseEntity.Description isHTML:YES];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    // Then implement the delegate method
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrImg.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:11];
    UILabel *lbl = [cell viewWithTag:12];
    imgV.hidden = NO;
    cell.backgroundColor = [UIColor clearColor];
    imgV.image = [UIImage imageNamed:arrImg[indexPath.row]];
    lbl.text = arrTitle[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
            [self sendEmail];
            break;
        case 1:
            [self shareToFacebook];
            break;
        case 2:
            [self shareToGooglePlus];
            break;
        case 3:
            [self shareToTwitter];
            break;
        case 4:
            [self postToPinterest];
            break;
            
        default:
            break;
    }
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
