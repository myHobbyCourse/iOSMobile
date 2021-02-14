//
//  MessagesViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "MessagesViewController.h"

#import "DayMessages.h"
#import "MessagesTableViewCell.h"
#import "MessageModel.h"

@interface MessagesViewController (){
    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
    NSMutableArray * arrDataCopy;
    NSInteger selectedRow;
    UIRefreshControl *refreshControl;
    
}
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedRow = 0;
    
    [self initData];
    self.messageTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.messageTableView.bounds.size.width, 0.01f)];
    [self performSelector:@selector(getMsgThread) withObject:self afterDelay:0.5];
    [txtSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];
    _heightSearch.constant = 0;
    _messageTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.messageTableView.estimatedRowHeight = 70;
    self.messageTableView.rowHeight = UITableViewAutomaticDimension;
    refreshControl = [[UIRefreshControl alloc]init];
    [self.messageTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(getMsgThread) forControlEvents:UIControlEventValueChanged];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Messages List Screen"];
    if (arrData.count == 0) {
        [self getMsgThread];
    }
}
#pragma mark Search
-(IBAction)btnSearchOpen:(UIButton*)sender {
    [self.view endEditing:true];
    if (_heightSearch.constant == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 50;
            [self.view layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 0;
            [self.view layoutIfNeeded];
            
        }];
        txtSearch.text = @"";
        [self searchTextValueChange:txtSearch];
    }
}
-(void)searchTextValueChange:(UITextField *)textFiled
{
    if (textFiled.text.tringString.length > 1) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.subject contains[c] %@ OR self.last_updated contains[c] %@ OR ANY participants.participant contains[c] %@",textFiled.text,textFiled.text,textFiled.text];
        arrData = [[arrDataCopy filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        [arrData removeAllObjects];
        [arrData addObjectsFromArray:arrDataCopy];
    }
    [self.messageTableView reloadData];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self searchTextValueChange:textField];
    return true;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"conversation"])
    {
        ConversationViewController *view = segue.destinationViewController;
        NSIndexPath *index = sender;
        MessageModel *message = [arrData objectAtIndex:index.row];
        view.msgEntity = message;
    }
}


- (void) initData
{
    if(self.isNewthread)
    {
        btnBack.hidden = false;
        ConversationViewController *conViewController = self.childViewControllers.firstObject;
        conViewController.isNewthread = self.isNewthread;
        conViewController.couseEntity = self.couseEntity;
        selectedRow = -1;
        [conViewController refreshTbl];
        [tblParent reloadData];
        [tblParent reloadData];
    }else{
        btnBack.hidden = true;

    }
    arrDataCopy = [[NSMutableArray alloc]init];
    
}
-(void) getMsgThread
{
    if (![self isNetAvailable])
    {
        NSData *data = [UserDefault objectForKey:kUserMessageKey];
        if (data)
        {
            NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([retrievedDictionary isKindOfClass:[NSArray class]]) {
                arrData = [NSMutableArray array];
                
                for (NSDictionary *message in retrievedDictionary) {
                    [arrData addObject:[[MessageModel alloc] initWithDictionary:message error:nil]];
                    [arrDataCopy addObject:[[MessageModel alloc] initWithDictionary:message error:nil]];
                }
                
                NSArray *arrKeys = [arrData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    MessageModel *a = obj1;
                    MessageModel *b = obj2;
                    NSDate *aa = [ddMMMyyyyHHmmss() dateFromString:a.last_updated];
                    NSDate *bb = [ddMMMyyyyHHmmss() dateFromString:b.last_updated];
                    return [bb compare: aa];
                }];
                
                if (arrKeys && arrKeys.count > 0) {
                    [arrData removeAllObjects];
                    [arrDataCopy removeAllObjects];
                    [arrData addObjectsFromArray:arrKeys];
                    [arrDataCopy addObjectsFromArray:arrData];
                }
                
                
                [self.messageTableView reloadData];
                
            }
        }
        return;
    }
    
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiMSGThread paramter:@{@"uid":APPDELEGATE.userCurrent.uid} withCallback:^(id jsonData, WebServiceResult result) {
        NSLog(@"%@",jsonData);
        [self stopActivity];
        [refreshControl endRefreshing];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kUserMessageKey];
                [UserDefault synchronize];
                
                arrData = [NSMutableArray array];
                for (NSDictionary *message in jsonData) {
                    [arrData addObject:[[MessageModel alloc] initWithDictionary:message error:nil]];
                    [arrDataCopy addObject:[[MessageModel alloc] initWithDictionary:message error:nil]];
                }
                NSArray *arrKeys = [arrData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    MessageModel *a = obj1;
                    MessageModel *b = obj2;
                    NSDate *aa = [ddMMMyyyyHHmmss() dateFromString:a.last_updated];
                    NSDate *bb = [ddMMMyyyyHHmmss() dateFromString:b.last_updated];
                    return [bb compare: aa];
                }];
                
                if (arrKeys && arrKeys.count > 0) {
                    [arrData removeAllObjects];
                    [arrDataCopy removeAllObjects];
                    [arrData addObjectsFromArray:arrKeys];
                    [arrDataCopy addObjectsFromArray:arrData];
                }
                [self.messageTableView reloadData];
                
                // for iPad Landscape
                if (is_iPad() && arrData.count > 0 && !self.isNewthread) {
                    ConversationViewController *conViewController = self.childViewControllers.firstObject;
                    conViewController.msgEntity = arrData.firstObject;
                    [conViewController getMsgList];
                    
                }
            }
        }else
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = (NSArray*) jsonData;
                if (arr.count > 0)
                {
                    showAletViewWithMessage(arr[0]);
                }
            }else{
                showAletViewWithMessage(@"No mail at the moment, check messages later.");
            }
        }
        
    }];
    
}
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesTableViewCell"];
    MessageModel* message = [arrData objectAtIndex:indexPath.row];
    [cell setData:message];
    
    cell.backgroundColor = [UIColor clearColor];
    if (is_iPad() && selectedRow == indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:194.0/255.0 green:226.0/255.0 blue:237.0/255.0 alpha:1.0];
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // for iPad Landscape
    if (is_iPad()) {
        self.isNewthread = false;
        ConversationViewController *conViewController = self.childViewControllers.firstObject;
        conViewController.msgEntity = [arrData objectAtIndex:indexPath.row];
        [conViewController getMsgList];
        selectedRow = indexPath.row;
        [tableView reloadData];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MessageModel *message = [arrData objectAtIndex:indexPath.row];
        message.has_new = @"0";
        [self performSegueWithIdentifier:@"conversation" sender:indexPath];
        [tableView reloadData];
    }
}

@end
