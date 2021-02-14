//
//  TutorListVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TutorListVC.h"

@interface TutorListVC () {
    IBOutlet UICollectionView *cvTutors;
    NSMutableArray<TutorsEntity*> *arrTuttors;
}
@end

@implementation TutorListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrTuttors = [NSMutableArray new];
    [self getTutorList];
    [DefaultCenter addObserver:self selector:@selector(getNotifcationForUpdate:) name:@"refreshTutorList" object:nil];
    if (_isFromDetails) {
        btnAddTutor.hidden = true;
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Tutor List Screen"];
}
-(void) getNotifcationForUpdate:(NSNotification *)notification{
    [self.navigationController popToViewController:self animated:true];
    [self getTutorList];
}
-(void) getRefreshBlock:(CommonBlock)commonBlock {
    self.commonBlock = commonBlock;
}

-(IBAction)btnAddNewTutor:(UIButton*)sender {
    if (is_iPad()) {
        [self dismissViewControllerAnimated:false completion:nil];
        [[JPUtility shared] performOperation:0.2 block:^{
            AddTutorVC_iPad *vc = [getStoryBoardDeviceBased(StoryboardTutor) instantiateViewControllerWithIdentifier:@"AddTutorVC_iPad"];
            UINavigationController *nav =  APPDELEGATE.window.rootViewController;
            [nav pushViewController:vc animated:true];
        }];
        
    }else{
        [self performSegueWithIdentifier:@"segueAddTutor" sender:self];
    }
}

#pragma mark API Calls
-(void) getTutorList {
    [self startActivity];
    NSString *vID = (self.courseEntity == nil) ? APPDELEGATE.userCurrent.uid : self.courseEntity.author_uid;
    [[NetworkManager sharedInstance] postRequestUrl:apiTutorList paramter:@{@"uid":vID,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [arrTuttors removeAllObjects];
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                TutorsEntity * objTutor = [[TutorsEntity alloc]initWith:d];
                [arrTuttors addObject:objTutor];
            }
            [cvTutors reloadData];
        }
        if (arrTuttors.count == 0) {
            showAletViewWithMessage(@"No tutors found!!");
        }
    }];
    
}

#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrTuttors.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (is_iPad()) {
        return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
    }
    return CGSizeMake(self.view.frame.size.width/2, (self.view.frame.size.width/2)* 1.2);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblName =[cell viewWithTag:11];
    UIImageView *imgView =[cell viewWithTag:12];
    UIButton *btnMoreInfor =[cell viewWithTag:13];
    
    lblName.text = arrTuttors[indexPath.row].tutor_name;
    [imgView sd_setImageWithURL:[NSURL URLWithString:arrTuttors[indexPath.row].imagePath] placeholderImage:_placeHolderImg];
    btnMoreInfor.layer.cornerRadius = 8;
    btnMoreInfor.layer.masksToBounds = true;
    if (!self.isSelectTutor) {
        [btnMoreInfor setTitle:@"More" forState:UIControlStateNormal];
    }else{
        [btnMoreInfor setTitle:@"select" forState:UIControlStateNormal];
    }

    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isSelectTutor) {
        [self performSegueWithIdentifier:@"segueTutorDetails" sender:arrTuttors[indexPath.row]];
    }else{
        if (self.commonBlock && !_isStringEmpty(arrTuttors[indexPath.row].tutor_name)) {
            self.commonBlock(arrTuttors[indexPath.row].tutor_name);
            (is_iPad()) ? [self dismissViewControllerAnimated:true completion:nil] :[self.navigationController popViewControllerAnimated:true];
        }else{
            showAletViewWithMessage(@"Tutor name is mandatory");
        }
    }
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.destinationViewController isKindOfClass:[TutorDetailsVC class]]) {
         TutorDetailsVC *vc = segue.destinationViewController;
         vc.tutor = sender;
         vc.isFromDetails = self.isFromDetails;
     }
     
 }


@end
