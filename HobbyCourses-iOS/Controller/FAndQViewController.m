//
//  FAndQViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 20/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FAndQViewController.h"
#import "AnswerViewControlleriPad.h"

@interface FAndQViewController ()
{
    NSMutableArray *arrData;
    NSMutableArray *arrCopyData,*arrValuesData;
}
@end

@implementation FAndQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrCopyData = [[NSMutableArray alloc]init];
    arrValuesData = [[NSMutableArray alloc]init];
    arrData = [[NSMutableArray alloc]init];
    
    tblFQ.rowHeight = UITableViewAutomaticDimension;
    tblFQ.estimatedRowHeight = 60;
    [self performSelector:@selector(getFAQ) withObject:nil afterDelay:0.5];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"FAQ Screen"];
}
-(void) getFAQ
{
    if (![self isNetAvailable]) {
        NSData *data = [UserDefault objectForKey:kFAQKey];
        if (data) {
            id jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self getOfflineFaq:jsonData];
        }
    } else {
        [self startActivity];
        [[NetworkManager sharedInstance] postRequestFullUrl:apiFAQUrl paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
             [self stopActivity];
             if (result == WebServiceResultSuccess) {
                 if ([jsonData isKindOfClass:[NSArray class]]) {
                     NSArray * arr = jsonData;
                     if (arr.count > 0) {
                         [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kFAQKey];
                         [UserDefault synchronize];
                     }
                 }
                 [self getOfflineFaq:jsonData];
             }
             else
             {
                 
             }
         }];
    }
}
-(void) getOfflineFaq:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSArray class]])
    {
        NSArray * arr = jsonData;
        arrCopyData = jsonData;
        for (NSDictionary *dict in arr)
        {
            [arrValuesData addObjectsFromArray:[dict allValues]];
            [arrData addObject:[[dict allKeys] firstObject]];
        }
        if (arrData.count > 0)
        {
            [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kFAQKey];
            [UserDefault synchronize];
        }
        
    }
    [tblFQ reloadData];
    
    if (is_iPad() && arrData.count > 0)
    {
        // reload detail screen
        AnswerViewControlleriPad *answerViewController = self.childViewControllers.firstObject;
        if ([[arrValuesData firstObject] isKindOfClass:[NSDictionary class]]) {
            answerViewController.arrayFAQs = [arrValuesData firstObject];
            [answerViewController reloadData];
            
        }else{
            //TODO : Need to fix for NSArray
        }
        
    }
}

#pragma mark - UItableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrData.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lblTittle = [cell viewWithTag:5];
    UIImageView *imgV = [cell viewWithTag:3];
    if (![[self getImageFromString:arrData[indexPath.row]] isEqualToString:@""]) {
        imgV.image = [UIImage imageNamed:[self getImageFromString:arrData[indexPath.row]]];
    }
    lblTittle.text = arrData[indexPath.row];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = __THEME_lightGreen;
    cell.selectedBackgroundView = bgColorView;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (is_iPad()) {
        // reload detail screen
        AnswerViewControlleriPad *answerViewController = self.childViewControllers.firstObject;
        if ([[arrValuesData objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
            answerViewController.arrayFAQs = [arrValuesData objectAtIndex:indexPath.row];
            [answerViewController reloadData];
        }else{
            //TODO : Need to fix for NSArray
        }
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"GoToQuestion" sender:indexPath];
    }
}

-(NSString *) getImageFromString:(NSString*) content {
    if ([content containsString:@"Type"]) {
        return @"ic_faq_type";
    }else if ([content containsString:@"Finding"]) {
        return @"ic_faq_find_course";
    }else if ([content containsString:@"Posting"]) {
        return @"ic_faq_post";
    }else if ([content containsString:@"Messages"]) {
        return @"ic_faq_msg";
    }else if ([content containsString:@"Setting"]) {
        return @"ic_faq_setting";
    }else if ([content containsString:@"Content"]) {
        return @"ic_faq_content";
    }else if ([content containsString:@"Reviews"]) {
        return @"ic_faq_review";
    }
    
    return @"";
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GoToQuestion"])
    {
        QuestionFQViewController *view = segue.destinationViewController;
        NSIndexPath *index = sender;
        view.arrQuestion = [arrValuesData objectAtIndex:index.row];
        view.category = [arrData objectAtIndex:index.row];
    }
}


@end
