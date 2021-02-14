//
//  ContactVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 08/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ContactVC.h"

@interface ContactVC () {
    IBOutlet UIView *viewBottom;
    NSArray *sortedKeys;
    NSMutableDictionary *indexDictionary;
    NSMutableArray<NSIndexPath*> *selectedIndex;
}

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    sortedKeys = [NSArray new];
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 60;
    tblParent.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    selectedIndex = [NSMutableArray new];
    [self getContactList];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Contact invites Screen"];
}
#pragma mark - GET Contact List
-(void) getContactList {
    [[UserPhoneBook sharedInstance] checkAuthorizationStatus:^(BOOL isGranted, NSError *error) {
        if (isGranted) {
            [[UserPhoneBook sharedInstance] fetchUserNameNumberEmail:^(NSArray<NSDictionary *> *arrayContacts) {
                [self createDictionayForSectionalIndex:arrayContacts];
            }];
        }else{
            //alert
        }
    }];
}
-(void) createDictionayForSectionalIndex:(NSArray*) arrayContacts{
    indexDictionary = [NSMutableDictionary dictionary];
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
    {
        //NSPredicates are fast
        
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSArray *filteredarray = [arrayContacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(firstName beginswith[cd] %@)", firstCharacter]];
        NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:filteredarray];
        
        if ([mutableContent count] > 0)
        {
            NSString *key = [firstCharacter uppercaseString];
            [indexDictionary setObject:mutableContent forKey:key];
            NSLog(@"%@: %u", key, [mutableContent count]);
        }
    }
    sortedKeys = [[indexDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [tblParent reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([sortedKeys count]);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [sortedKeys objectAtIndex:section];
    return [[indexDictionary valueForKey:key] count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ([sortedKeys objectAtIndex:section]);
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sortedKeys;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblValue = [cell viewWithTag:13];
    UIImageView *imgV = [cell viewWithTag:11];
    UILabel *lblTitle = [cell viewWithTag:12];
    
    NSString *key = [sortedKeys objectAtIndex:indexPath.section];
    NSArray *array = [indexDictionary objectForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    lblTitle.text = [NSString stringWithFormat:@"%@ %@",dict[@"firstName"],dict[@"lastName"]];
    lblValue.text = ([self checkStringValue:dict[@"number"]]) ? dict[@"email"] : dict[@"number"];
    if ([selectedIndex containsObject:indexPath]) {
        imgV.image = [UIImage imageNamed:@"ic_f_checked"];
    }else{
        imgV.image = [UIImage imageNamed:@"ic_f_unchecked"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([selectedIndex containsObject:indexPath]) {
        [selectedIndex removeObject:indexPath];
    }else{
        [selectedIndex addObject:indexPath];
    }
    if (selectedIndex.count == 0) {
        viewBottom.hidden = true;
    }else{
        viewBottom.hidden = false;
    }
    [tableView reloadData];
}
#pragma mark- Action
-(IBAction)btnSendInvitation:(id)sender {
    NSMutableArray * arrNumber = [NSMutableArray new];
    for (NSIndexPath *indexPath in selectedIndex) {
        NSString *key = [sortedKeys objectAtIndex:indexPath.section];
        NSArray *array = [indexDictionary objectForKey:key];
        NSDictionary *dict = [array objectAtIndex:indexPath.row];
        if (![self checkStringValue:dict[@"number"]]) {
            [arrNumber addObject:dict[@"number"]];
        }
    }
    NSString *msg = [NSString stringWithFormat:@"%@ invoted you to join hobby courses.Sing up & Get $5 off your first course buy. /n Link:%@",APPDELEGATE.userCurrent.name,kAppLink];
    if (arrNumber.count > 0) {
        
        [self sendMessageToRecipients:arrNumber message:@[kAppName,msg] toController:self];
    }else{
        for (NSIndexPath *indexPath in selectedIndex) {
            NSString *key = [sortedKeys objectAtIndex:indexPath.section];
            NSArray *array = [indexDictionary objectForKey:key];
            NSDictionary *dict = [array objectAtIndex:indexPath.row];
            if (![self checkStringValue:dict[@"email"]]) {
                [arrNumber addObject:dict[@"email"]];
            }
        }
        [self sendMailToRecipients:arrNumber message:@[kAppName,msg] toController:self];
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
