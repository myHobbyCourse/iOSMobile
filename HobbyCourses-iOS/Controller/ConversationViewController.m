//
//  ConversationViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/21/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConvUserTableViewCell.h"
#import "ConvMyMessageTableViewCell.h"
#import "ConvOtherMessageTableViewCell.h"
#import "Constants.h"
#import "PHFComposeBarView.h"

@interface ConversationViewController ()<PHFComposeBarViewDelegate>
{
    IBOutlet UITableView *tblMsg;
    IBOutlet PHFComposeBarView *sendMsgView;
    
    NSString *sendStringMsg;
    BOOL isSwapApi;
    NSString *tempThread_id;
    BOOL isScollDown;
    
}
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isScollDown =true;
    tblMsg.tableFooterView = [[UIView alloc]init];
    tblMsg.rowHeight = UITableViewAutomaticDimension;
    tblMsg.estimatedRowHeight = 70;
    // Do any additional setup after loading the view.
    [self initWidget];
    [self initData];
    tblMsg.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (is_iPad() && self.isNewthread)
    {
        [tblMsg reloadData];
    }
    [self updateToGoogleAnalytics:@"Message with vendor Screen"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isNewthread)
    {
        msgTittle.text = self.couseEntity.author;
    }else
    {
        if (self.msgEntity.participants && self.msgEntity.participants.count>0)
        {
            ParticipantModel * entiity = self.msgEntity.participants[0];
            msgTittle.text = self.msgEntity.subject;//entiity.participant;
        }
        if (self.isNewthread || self.msgEntity)
        {
            [self getMsgList];
        }
    }
}
- (void) initWidget {
   // UIColor *color = UIColorFromRGB(0xf1f1f1);
   // tfSendMessage.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[tfSendMessage placeholder] attributes:@{NSForegroundColorAttributeName: color}];
}

- (void) initData {
    arrData = [[NSMutableArray alloc] init];
    
    //ComposebarView appereance
    sendMsgView.placeholder = @" Your message...";
    sendMsgView.placeholderLabel.textColor = __THEME_GRAY;
    sendMsgView.delegate = self;
    sendMsgView.maxLinesCount = 5;
    sendMsgView.backgroundColor = [UIColor whiteColor];
    sendMsgView.button.frame = CGRectMake(0, 0, 0, 0);
    sendMsgView.textView.font = [UIFont systemFontOfSize:(is_iPad()) ? 18 : 15];
    sendMsgView.textView.textColor = __THEME_GRAY;
    //[sendMsgView.button setHidden:true];
    sendMsgView.placeholderLabel.font =[UIFont systemFontOfSize:(is_iPad()) ? 18 : 15];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Your message..." attributes:@{ NSForegroundColorAttributeName : __THEME_GRAY }];
    tfSendMessage.attributedPlaceholder = str;
}
-(void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView
{
    tfSendMessage.text = composeBarView.textView.text;
    sendStringMsg = [[composeBarView.textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" \n "];
    if (self.isNewthread && !isSwapApi)
    {
        [self sendNewMsg];
    }else
    {
        [self sendReplyMSg];
    }
}
-(void) refreshTbl
{
    [tblMsg reloadData];
}
-(void) getMsgList
{
    NSDictionary *dict;
    NSString *strID;
    if (isSwapApi)
    {
        dict =@{@"thread_id":tempThread_id};
        strID = tempThread_id;
    }else
    {
        dict = @{@"thread_id":[NSString stringWithFormat:@"%d",self.msgEntity.thread_id]};
        strID = [NSString stringWithFormat:@"%d",self.msgEntity.thread_id];
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiMSgConversationUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
       if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:strID];
                [UserDefault synchronize];
                [arrData removeAllObjects];
                for (NSDictionary *dict in jsonData)
                {
                    Message *msg = [[Message alloc] initWith:dict];
                    [arrData addObject:msg];
                }
                
                NSArray *arrKeys = [arrData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    Message *a = obj1;
                    Message *b = obj2;
                    return [a.dateSending compare: b.dateSending];
                }];
                
                if (arrKeys && arrKeys.count > 0)
                {
                    [arrData removeAllObjects];
                    [arrData addObjectsFromArray:arrKeys];
                }
                [tblMsg reloadData];
            }
        }else
        {
            if (jsonData && [jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = jsonData;
                if (arr.count > 0)
                {
                    NSString *str = jsonData[0];
                    if ([str isKindOfClass:[NSString class]]) {
                        showAletViewWithMessage(str);
                    }
                }
                if (!is_iPad())
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
            else
            {
                NSData *data = [UserDefault objectForKey:strID];
                if (data)
                {
                    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if ([retrievedDictionary isKindOfClass:[NSArray class]]) {
                        [arrData removeAllObjects];
                        for (NSDictionary *dict in retrievedDictionary)
                        {
                            Message *msg = [[Message alloc] initWith:dict];
                            [arrData addObject:msg];
                        }
                        NSArray *arrKeys = [arrData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                            NSDateFormatter *df = [[NSDateFormatter alloc] init];
                            //                     [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                            [df setDateFormat:@"dd EEE yy HH:mm:ss"];
                            Message *a = obj1;
                            Message *b = obj2;
                            NSDate *d1 = [df dateFromString:a.sending_time];
                            NSDate *d2 = [df dateFromString:b.sending_time];
                            return [d2 compare: d1];
                        }];
                        
                        if (arrKeys && arrKeys.count > 0)
                        {
                            [arrData removeAllObjects];
                            [arrData addObjectsFromArray:arrKeys];
                        }
                        [tblMsg reloadData];
                    }else{
                        showAletViewWithMessage(kFailAPI);
                    }
                    
                }else{
                    showAletViewWithMessage(kFailAPI);
                }
            }
            
        }
    }];
    
}
-(void) sendReplyMSg
{
    if ([self checkStringValue:sendStringMsg]) {
        return;
    }
    [self startActivity];
    NSDictionary *dict;
    if (isSwapApi)
    {
        dict = @{@"thread_id" :tempThread_id,@"body" : sendStringMsg};
        
    }else
    {
        dict = @{@"thread_id" :[NSString stringWithFormat:@"%d",self.msgEntity.thread_id],@"body" : sendStringMsg};
    }
    
    [[NetworkManager sharedInstance] postRequestUrl:apiReplyMsg paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        NSLog(@"%@",jsonData);
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                if (jsonData[@"success"])
                {
                    showAletViewWithMessage(@"That’s the sound of success. Your messages have been posted to Tutor");
                    tfSendMessage.text = @"";
                    sendMsgView.text = @"";
                    [self getMsgList];
                }
            }
        }else{
            showAletViewWithMessage(@"Failed to send message,Please try again.");
        }
    }];
}

-(void) sendNewMsg{
    if ([self checkStringValue:sendStringMsg.tringString]) {
        return;
    }
    [self startActivity];
    
    NSDictionary *dict = @{@"recipient" :self.couseEntity.author,@"body" : sendStringMsg,@"subject":self.couseEntity.title};
    [[NetworkManager sharedInstance] postRequestUrl:apiSendMSg paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        NSLog(@"%@",jsonData);
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSDictionary class]])
            {
                if (jsonData[@"success"])
                {
                    showAletViewWithMessage(@"That’s the sound of success. Your messages have been posted to Tutor");
                    tfSendMessage.text = @"";
                    sendMsgView.text = @"";
                    tempThread_id = jsonData[@"message"][@"thread_id"];
                    isSwapApi = true;
                    [self getMsgList];
                    
                }
            }
        }else{
            showAletViewWithMessage(@"Failed to send message,Please try again.");
        }
    }];
    
    
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onSend:(id)sender {
    if (![self isNetAvailable]) {
        showAletViewWithMessage(netMSG);
        return;
    }
    sendStringMsg = sendMsgView.textView.text;
    [tfSendMessage resignFirstResponder];
    if (self.isNewthread && !isSwapApi) {
        [self sendNewMsg];
    }else{
        [self sendReplyMSg];
    }
    
}

#pragma mark - tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ConvUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConvUserTableViewCell"];
        if (self.isNewthread) {
            [cell setNewData:self.couseEntity];
        }else {
            [cell setData:self.msgEntity];
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else {
        Message *msg = arrData[indexPath.row];
        if ([msg.uid isEqualToString:APPDELEGATE.userCurrent.uid]) {
            ConvMyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConvMyMessageTableViewCell"];
            Message* message = [arrData objectAtIndex:indexPath.row];
            
            [cell setData:message];
            MGSwipeButton *btnDelete = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:UIColorFromRGB(0xfe347e) callback:^BOOL(MGSwipeTableCell *sender)
                                        {
                                            [self deleteMsg:message.mid];
                                            return YES;
                                        }];
            MGSwipeButton *btnCopy = [MGSwipeButton buttonWithTitle:@"Copy" backgroundColor:UIColorFromRGB(0x242c39) callback:^BOOL(MGSwipeTableCell *sender) {
                [UIPasteboard generalPasteboard].string = message.body;
                return YES;
            }];
            
            
            cell.rightButtons = @[btnDelete,btnCopy];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        } else {
            ConvOtherMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConvOtherMessageTableViewCell"];
            Message* message = [arrData objectAtIndex:indexPath.row];
            [cell setData:message];
            MGSwipeButton *btnDelete = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:UIColorFromRGB(0xfe347e) callback:^BOOL(MGSwipeTableCell *sender) {
                NSLog(@"delete button click event!");
                [self deleteMsg:message.mid];
                
                return YES;
            }];
            MGSwipeButton *btnCopy = [MGSwipeButton buttonWithTitle:@"Copy" backgroundColor:UIColorFromRGB(0x242c39) callback:^BOOL(MGSwipeTableCell *sender) {
                [UIPasteboard generalPasteboard].string = message.body;
                return YES;
            }];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.rightButtons = @[btnDelete,btnCopy];
            
            return cell;
        }
        
        
    }
    return nil;
}
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
    
}

-(BOOL) tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
    {
        return true;
    }
    return false;
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    Message *msg = arrData[indexPath.row];
    [UIPasteboard generalPasteboard].string = msg.body;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void) deleteMsg:(NSString*)mid
{
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Do you want to delete this message?" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            [self startActivity];
            NSDictionary * dict = @{@"mid":mid};
            [[NetworkManager sharedInstance] postRequestUrl:apiDelMsg paramter:dict withCallback:^(id jsonData, WebServiceResult result)
             {
                 [self stopActivity];
                 if (result == WebServiceResultSuccess)
                 {
                     [self getMsgList];
                 }
             }];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];

    
    
}

@end
