//
//  QuestionFQViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "QuestionFQViewController.h"

@interface QuestionFQViewController ()
{
    NSMutableArray *arrData,*arrExceptionCase;
}
@end

@implementation QuestionFQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrData = [[NSMutableArray alloc]init];//WithObjects:@"Are my account up to date?",@"I am getting something wrong", nil];
    arrExceptionCase = [[NSMutableArray alloc]init];
    
    tblQuestion.rowHeight = UITableViewAutomaticDimension;
    tblQuestion.estimatedRowHeight = 60;
    [self setData];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [tblQuestion reloadData];
}


-(void) setData
{
    for (NSString *str in self.arrQuestion) {
        if ([str isKindOfClass:[NSString class]]) {
            [arrData addObject:str];
        }else if ([str isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray*)str;
            for (NSString *str in arr) {
                if ([str isKindOfClass:[NSString class]]) {
                    [arrData addObject:str];
                }
            }
        }
    }
    
    if (arrData.count == 0) {
        for (int i = 0; i<self.arrQuestion.count; i++) {
            id str = self.arrQuestion[i];
            if ([str isKindOfClass:[NSDictionary class]]) {
                NSDictionary *d = (NSDictionary*) str;
                if (i == 0) {
                    NSString *keyF = [[d allKeys] firstObject];
                    [arrData addObjectsFromArray:[d valueForKey:keyF]];
                }else if (i == 1) {
                    NSString *keyL = [[d allKeys] lastObject];
                    [arrExceptionCase addObjectsFromArray:[d valueForKey:keyL]];
                }
            }
        }
    }
    [tblQuestion reloadData];
    
}

#pragma mark - UItableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (arrExceptionCase.count > 0) ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? arrData.count : arrExceptionCase.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lblTittle = [cell viewWithTag:5];
    lblTittle.text = (indexPath.section == 0) ? arrData[indexPath.row] : arrExceptionCase[indexPath.row];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = __THEME_lightGreen;
    cell.selectedBackgroundView = bgColorView;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"GoToAns" sender:indexPath];
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
    if ([segue.identifier isEqualToString:@"GoToAns"]) {
        AnswerViewController *view = segue.destinationViewController;
        NSIndexPath *index = sender;
        view.category = self.category;
        if (arrExceptionCase.count > 0) {
            if (index.section == 0) {
                view.question = [arrData objectAtIndex:index.row];
            }else{
                view.question = [arrExceptionCase objectAtIndex:index.row];
            }
        }else{
            view.question = [arrData objectAtIndex:index.row];
        }
        
        if([self.arrQuestion isKindOfClass:[NSDictionary class]])
        {
            id obj = [self.arrQuestion valueForKey:view.question];
            if ([obj isKindOfClass:[NSArray class]]){
                NSArray *arr = obj;
                if (arr && arr.count>0) {
                    view.answer = arr[0];
                }
            }
        }else if([self.arrQuestion isKindOfClass:[NSArray class]]) {
            NSDictionary *dict;
            if (index.section == 0) {
               NSDictionary *d = [self.arrQuestion firstObject];
                NSString *s =[[d allKeys] firstObject];
                dict = [d valueForKey:s];
                
            }else{
                NSDictionary *d = [self.arrQuestion lastObject];
                NSString *s =[[d allKeys] firstObject];
                dict = [d valueForKey:s];
            }
            
            id obj = [dict valueForKey:view.question];
            if ([obj isKindOfClass:[NSArray class]]){
                NSArray *arr = obj;
                if (arr && arr.count>0) {
                    view.answer = arr[0];
                }
            }
            
        }
    }
}


@end
