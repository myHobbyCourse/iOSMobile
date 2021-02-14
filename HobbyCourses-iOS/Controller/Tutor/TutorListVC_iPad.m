//
//  TutorListVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 03/12/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TutorListVC_iPad.h"

@interface TutorListVC_iPad (){
    IBOutlet UITableView *tblLeft;
    IBOutlet UITableView *tblRight;
    IBOutlet UIView *viewShadow;
    NSInteger currentIndex;
    NSMutableArray<TutorsEntity*> *arrTuttors;
}


@end

@implementation TutorListVC_iPad
@synthesize selectedTutor;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addShaowForiPad:viewShadow];
    tblRight.estimatedRowHeight = 100;
    tblRight.rowHeight = UITableViewAutomaticDimension;
    tblLeft.estimatedRowHeight = 100;
    tblLeft.rowHeight = UITableViewAutomaticDimension;
    tblLeft.tableFooterView = [UIView new];
    arrTuttors = [NSMutableArray new];
    [tblRight reloadData];
    currentIndex = -1;
    [self getTutorList];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad Tutor list Screen"];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblLeft) {
        return arrTuttors.count;
    } else{
       return (selectedTutor == nil) ? 0 : 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblRight) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:{
                UIImageView *imgV = [cell viewWithTag:11];
                UILabel *lblAddres = [cell viewWithTag:12];
                lblAddres.text = selectedTutor.tutor_name;
                
                
                [imgV sd_setImageWithURL:[NSURL URLWithString:selectedTutor.imagePath] placeholderImage:_placeHolderImg];
            }   break;
            case 1:{
                UILabel *lblDesc = [cell viewWithTag:11];
                lblDesc.text = selectedTutor.tutor_details;
                
            }   break;
            
            default:
                break;
        }
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:11];
        UIImageView *imgV = [cell viewWithTag:12];
        imgV.layer.cornerRadius = 30;
        imgV.layer.masksToBounds = YES;
        [imgV sd_setImageWithURL:[NSURL URLWithString:arrTuttors[indexPath.row].imagePath] placeholderImage:_placeHolderImg];
        
        lbl.text = arrTuttors[indexPath.row].tutor_name;
        if (indexPath.row == currentIndex) {
            cell.backgroundColor = [UIColor colorWithRed:159.0/255.0 green:213.0/255.0 blue:214.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tblLeft == tableView) {
        currentIndex = indexPath.row;
        selectedTutor = arrTuttors[indexPath.row];
        [tblLeft reloadData];
        [tblRight reloadData];
    }
}
#pragma mark API Calls
-(void) getTutorList {
    [self startActivity];
    NSString *vID = (self.courseEntity == nil) ? APPDELEGATE.userCurrent.uid : self.courseEntity.author_uid;
    [[NetworkManager sharedInstance] postRequestUrl:apiTutorList paramter:@{@"uid":vID,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                TutorsEntity * objTutor = [[TutorsEntity alloc]initWith:d];
                [arrTuttors addObject:objTutor];
            }
        }if (arrTuttors.count == 0) {
            showAletViewWithMessage(@"No tutors found!!");
        }else{
            currentIndex = 0;
            selectedTutor = arrTuttors[0];
        }
        [tblLeft reloadData];
        [tblRight reloadData];
        
        
    }];
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
