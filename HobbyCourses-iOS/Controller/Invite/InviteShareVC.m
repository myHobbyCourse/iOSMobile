//
//  InviteShareVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 18/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "InviteShareVC.h"

@class ShareController;

@interface InviteShareVC ()
{
    NSMutableArray<NSString*> *arrTitle;
}
@end

@implementation InviteShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTitle = [[NSMutableArray alloc] initWithObjects:@"Email",@"SMS",@"Copy Link",@"More", nil];
    tblParent.tableFooterView = [[UIView alloc]init];
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 90;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Invite Screen"];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrTitle.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIView *viewContainer = [cell viewWithTag:13];
    UIImageView *imgV = [cell viewWithTag:11];
    UILabel *lbl = [cell viewWithTag:12];
    cell.backgroundColor = [UIColor clearColor];
    lbl.text = arrTitle[indexPath.row];
    viewContainer.backgroundColor = [UIColor whiteColor];
    imgV.hidden = YES;
    lbl.textColor = __THEME_GRAY;

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *msg = [NSString stringWithFormat:@"%@ invited you to join hobby courses.\nhttps://myhobbycourses.com/getapp. \nApp store: %@",APPDELEGATE.userCurrent.name,kAppLink];
    switch (indexPath.row) {
        case 0: {
            [self sendMailToRecipients:@[] message:@[@"",msg] toController:self];
        }
            break;
        case 1: {
            [self sendMessageToRecipients:@[] message:@[kAppName,msg] toController:self];
        }
            break;
        case 2:
        {
            [UIPasteboard generalPasteboard].string = msg;
            showAletViewWithMessage(@"Copied done.");

        }
            break;
        case 3:
        {
            NSMutableArray *sharingItems = [NSMutableArray new];
            [sharingItems addObject:msg];
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
            [activityController setTitle:kAppLink];
            if (is_iPad()) {
                UITableViewCell *cell = [tblParent cellForRowAtIndexPath:indexPath];
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:activityController];
                [popover presentPopoverFromRect:cell.bounds inView:cell permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }else{
                [self presentViewController:activityController animated:YES completion:nil];
            }

        }
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
