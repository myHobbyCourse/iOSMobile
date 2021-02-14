//
//  FeedbackVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FeedbackVC.h"
#import <MessageUI/MessageUI.h>

@interface FeedbackVC ()<MFMailComposeViewControllerDelegate>{
    IBOutlet UIView *viewShaow;
    IBOutlet UIButton *btnSubmit;
    NSString *produceType,*strDesc;
    UIImage *imgSnap;
}

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 80;
    btnSubmit.layer.borderWidth = 1.5;
    btnSubmit.layer.borderColor = __THEME_COLOR.CGColor;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Feedback Screen"];
}

-(void)viewDidAppear:(BOOL)animated{
    [self addShaowForiPad:viewShaow];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (is_iPad()) ? 3 :5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UIView *viewBorder = [cell viewWithTag:11];
    if (viewBorder) {
        viewBorder.layer.borderWidth = 1;
        viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
    }
    if (is_iPad()) {
        switch (indexPath.row) {
            case 0:{
                UITextView *txt = [cell viewWithTag:12];
                txt.text = produceType;
            }
                break;
            case 1:{
                UITextView *txt = [cell viewWithTag:12];
                txt.text = [UserDefault valueForKey:kUserDeviceTokenKey]; //strDesc;
                UIImageView *viewImg = [cell viewWithTag:14];
                viewImg.layer.borderWidth = 1;
                viewImg.layer.borderColor = __THEME_lightGreen.CGColor;
                if (imgSnap) {
                    viewImg.image = imgSnap;
                }
                UIButton *btnChange =  [cell viewWithTag:13];
                btnChange.layer.borderColor = __THEME_COLOR.CGColor;
                btnChange.layer.borderWidth = 2.0;
            }   break;
            case 2:{
                UILabel *lblDevice = [cell viewWithTag:11];
                lblDevice.text =  [UIDevice currentDevice].name;
                UILabel *lblOS = [cell viewWithTag:12];
                lblOS.text =  [UIDevice currentDevice].systemVersion;
                
                UILabel *lblBuildVersion = [cell viewWithTag:21];
                lblBuildVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                UILabel *lblNumber = [cell viewWithTag:22];
                lblNumber.text =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
                
            }   break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                UITextView *txt = [cell viewWithTag:12];
                txt.text = produceType;
            }
                break;
                
            case 1:{
                UITextView *txt = [cell viewWithTag:12];
                txt.text = [UserDefault valueForKey:kUserDeviceTokenKey];//strDesc;
            }   break;
            case 2:{
                UIImageView *viewImg = [cell viewWithTag:11];
                if (imgSnap) {
                    viewImg.image = imgSnap;
                }
            }   break;
            case 3:{
                UILabel *lblDevice = [cell viewWithTag:11];
                lblDevice.text =  [UIDevice currentDevice].name;
                UILabel *lblOS = [cell viewWithTag:12];
                lblOS.text =  [UIDevice currentDevice].systemVersion;
            }   break;
            case 4:{
                UILabel *lblBuildVersion = [cell viewWithTag:11];
                lblBuildVersion.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                UILabel *lblNumber = [cell viewWithTag:12];
                lblNumber.text =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
            }
                break;
            default:
                break;
        }
    }
    [self.view layoutIfNeeded];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [self btnOpenImagePicker:nil];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSIndexPath *index = [[NSIndexPath new] indexPathForCellContainingView:textView inTableView:tblParent];
    switch (index.row) {
        case 0:
            produceType = textView.text;
            break;
        case 1:
            strDesc = textView.text;
            break;
            
        default:
            break;
    }
}
#pragma mark- 
-(IBAction) sendMail:(UIButton*) sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        
        [mail setSubject:produceType];
        NSString *html = [NSString stringWithFormat:@"%@ <br><b>Name</b>: %@ <bt> <br> <b>iOS Version</b>: %@",strDesc,APPDELEGATE.userCurrent.name,[UIDevice currentDevice].systemVersion];
        [mail setMessageBody:html isHTML:YES];
        [mail setToRecipients:@[@"appfeedback@myhobbycourses.com"]];
        if (imgSnap) {
            NSData *myData = UIImagePNGRepresentation(imgSnap);
            [mail addAttachmentData:myData mimeType:@"image/png" fileName:@"snap.png"];
        }
        
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)btnOpenImagePicker:(UIButton*)sender {
    if(is_iPad()){
        ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Are you sure!!" bgColor:__THEME_YELLOW button:@[@"Camera",@"Gallery"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
            if (tapped == TappedDismiss) {
                [self openCamera];
            }else if (tapped == TappedOkay) {
                [self openGallery];
            }
            [alert removeFromSuperview];
        }];
        
        [APPDELEGATE.window addSubview:alert];
    }else{
       [UIAlertController actionWithMessage:kAppName title:@"Are you sure!!" type:UIAlertControllerStyleAlert buttons:@[@"Camera",@"Gallery"] controller:self block:^(NSString * tapped) {
           if ([tapped isEqualToString:@"Camera"]) {
               [self openCamera];
           }else if ([tapped isEqualToString:@"Gallery"]) {
               [self openGallery];
           }
       }];
    }
}
-(void) openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
        
    }
    
}
-(void) openGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage,nil];
    if (is_iPad())
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:tblParent.bounds inView:tblParent permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }];
    }else{
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imgSnap = [info valueForKey: UIImagePickerControllerOriginalImage];
    [tblParent reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
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
