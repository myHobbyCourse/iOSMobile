//
//  ParentViewController.h

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface ParentViewController : UIViewController
{
    IBOutlet UITableView *tblParent;
}
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *horizontalConstraints;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *verticalConstraints;


-(void)startActivity;
-(void)startActivityWithoutBG;

-(void)stopActivity;
-(void)showAlertWithTitle:(NSString*)title forMessage: (NSString*)msg;
-(IBAction)parentDismiss:(UIButton*)sender;
-(IBAction)btnBackNav:(id)sender;

#pragma mark - utility methods
-(BOOL)checkTextfieldValue:(UITextField *)textField;
-(BOOL)checkStringValue:(NSString *)txt;
-(BOOL)validateEmail:(NSString *)candidate;
-(BOOL)validateMobile:(NSString *)candidate;
-(BOOL) isNetAvailable;
-(void) orientationChanged:(NSNotification *)note;
-(void) updateToGoogleAnalytics:(NSString*) valueString;
-(void) addShaowForiPad:(UIView *) viewLeft;
- (void) sendMessageToRecipients : (NSArray*) recipents message:(NSArray*) messages toController:(UIViewController*) controller;
- (void) sendMailToRecipients : (NSArray*) recipents message:(NSArray*) messages toController:(UIViewController*) controller;
-(void) configuraModalPopOver:(UIView*) sender controller:(UIViewController*) controller;
@end
