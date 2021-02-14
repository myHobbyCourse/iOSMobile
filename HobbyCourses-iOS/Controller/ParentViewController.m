//
//  ParentViewController.m


#import "ParentViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>

@interface ParentViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    UIActivityIndicatorView     *_actInd;
    UILabel                     *_lblProgress;
    UIImageView *_roundActInd;
    UILabel *_lblActInd;
    CABasicAnimation *rotationAnimation;
    MBProgressHUD *hud;
    ActivityHud *activityHud;
}
@end

@implementation ParentViewController
@synthesize verticalConstraints,horizontalConstraints;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Oritntaion event
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    self.navigationController.navigationBar.backItem.title = @"";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_white"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton setTintColor:[UIColor blackColor]];
 
    self.navigationController.navigationBarHidden = YES;
    [self constraintUpdate];
    
    //Custom HUD alloc
    activityHud =  [ActivityHud instanceFromNib:[UIColor whiteColor] Controller:self];
    [activityHud layoutIfNeeded];
}

//MARK;-Update constraintUpdate
-(void) constraintUpdate {
    if (horizontalConstraints) {
        for (NSLayoutConstraint * v1 in horizontalConstraints) {
            CGFloat v2 = v1.constant * _widthRatio;
            v1.constant = v2;
        }
    }
    if (verticalConstraints) {
        for (NSLayoutConstraint * v1 in verticalConstraints) {
            CGFloat v2 = v1.constant * _heighRatio;
            v1.constant = v2;
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            /* start special animation */
            break;
            
        case UIDeviceOrientationLandscapeRight:
            /* start special animation */
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            break;
            
        default:
            break;
    };
}
-(void) updateToGoogleAnalytics:(NSString*) valueString {
    if (valueString) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:valueString];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}
-(void)startActivityWithoutBG {
    [activityHud configure];
    activityHud.backgroundColor = [UIColor clearColor];
    [APPDELEGATE.window addSubview:activityHud];
}
-(void)startActivity {
    [activityHud configure];
    [APPDELEGATE.window addSubview:activityHud];
}
-(void)stopActivity {
    [activityHud removeFromSuperview];
}

#pragma mark - utility methods
-(BOOL)checkTextfieldValue:(UITextField *)textField{
    
    if (textField.text == nil || [textField.text isEqualToString:@""] || textField.text.length == 0) {
        return TRUE;
    }
    else{
        return FALSE;
    }
}
-(BOOL)checkStringValue:(NSString *)txt{
    
    if ([txt isKindOfClass:[NSNumber class]]){
        return false;
    }
    if ([txt isKindOfClass:[NSNull class]] || txt == nil || [txt isEqualToString:@""] || txt.length == 0)
    {
        return TRUE;
    }
    else{
        return FALSE;
    }
}

-(BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
-(BOOL)validateMobile:(NSString *)candidate
{
    NSString *mobileRegex = @"^((\\+91-?)|0)?[0-9]{10}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:candidate];
}
-(void)showAlertWithTitle:(NSString*)title forMessage: (NSString*)msg
{
    [[[UIAlertView alloc]initWithTitle:title
                               message:msg
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil, nil]show];
    
}
-(IBAction)btnBackNav:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
-(IBAction)parentDismiss:(UIButton*)sender{
    [self dismissViewControllerAnimated:false completion:nil];
}
-(BOOL)isNetAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        if (!APPDELEGATE.isAlert) {
            showAletViewWithMessage(netMSG);
            APPDELEGATE.isAlert = true;
        }
        return false;
    } else {
        NSLog(@"There IS internet connection");
        APPDELEGATE.isAlert = false;
        return true;
    }
}
#pragma mark- UITextField delegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}
#pragma mark - Hint PopUp
-(IBAction)btnOpenHint:(UIButton*)sender {
    FormHintVC  *vc =(FormHintVC*) [getStoryBoardDeviceBased(StoryboardFormPop) instantiateViewControllerWithIdentifier: @"FormHintVC"];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    vc.selectedText = sender.tag;
    [self presentViewController:vc animated:true completion:nil];
}

#pragma mark- Social Share
- (void) sendMessageToRecipients:(NSArray*) recipents message:(NSArray*) messages toController:(UIViewController*) controller {
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setTitle:messages[0]];
    [messageController setBody:messages[1]];
    [controller presentViewController:messageController animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
- (void) sendMailToRecipients:(NSArray*) recipents message:(NSArray*) messages toController:(UIViewController*) controller {
    if (![MFMailComposeViewController canSendMail]) {
        showAletViewWithMessage(@"Please configure one email account in setting menu");
        return;
    }
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    [mailController setSubject: messages[0]];
    [mailController setMessageBody:messages[1] isHTML:true];
    [mailController setCcRecipients:recipents];
    [controller presentViewController:mailController animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-
-(void) addShaowForiPad:(UIView *) viewLeft{
    if (!is_iPad()) {
        return;
    }
    [viewLeft layoutIfNeeded];
    //viewLeft.backgroundColor = __Light_Gray;
    viewLeft.layer.shadowRadius  = 3.0f;
    viewLeft.layer.shadowColor   = __THEME_GRAY.CGColor;
    viewLeft.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    viewLeft.layer.shadowOpacity = 0.3f;
    viewLeft.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -3.0f, -3.0f);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(viewLeft.bounds, shadowInsets)];
    viewLeft.layer.shadowPath    = shadowPath.CGPath;
}
-(void) configuraModalPopOver:(UIView*) sender controller:(UIViewController*) controller{
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.sourceView = sender;
    popController.sourceRect = sender.bounds;

}
@end
