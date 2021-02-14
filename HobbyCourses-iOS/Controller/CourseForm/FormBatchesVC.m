//
//  FormBatchesVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 29/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FormBatchesVC.h"

@interface FormBatchesVC (){
    IBOutlet UILabel *lblBatch;
    IBOutlet UILabel *lblBatchTotal;
}

@end

@implementation FormBatchesVC
@synthesize collectionBatches,currentIndex;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentIndex = 0;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Add batches from Screen"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [collectionBatches reloadData];
    [self scrollViewDidEndDecelerating:collectionBatches];
}
-(BOOL) batchValidation{
    for(Batches *objBatches in dataClass.arrCourseBatches) {
        
        NSDate *startDate = [globalDateOnlyFormatter() dateFromString:objBatches.startDate];
        NSDate *endDate = [globalDateOnlyFormatter() dateFromString:objBatches.endDate];
        if (startDate == nil || endDate == nil) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add batch data for class %lu",(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
            return false;
            break;
        }
        
        if (_isStringEmpty(objBatches.price)) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add batch price for class %lu",(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
            return false;
            break;
        }
        
        if (_isStringEmpty(objBatches.sessions)) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add batch sessions for class %lu",(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
            return false;
            break;
        }
        
        
        NSDateComponents *monthDifference = [[NSDateComponents alloc] init];
        NSMutableSet *dates = [[NSMutableSet alloc]init];
        NSUInteger monthOffset = 0;
        NSDate *nextDate = startDate;
        do {
            [dates addObject:nextDate];
            [monthDifference setMonth:monthOffset++];
            NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:monthDifference toDate:startDate options:0];
            nextDate = d;
        } while([nextDate compare:endDate] == NSOrderedAscending);
        
        [dates addObject:endDate];
        for (NSDate *date in dates) {
            NSDateComponents *dateComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
            
            NSDate * firstDateOfMonth = [self returnDateForMonth:dateComponents.month year:dateComponents.year day:1];
            NSDate * lastDateOfMonth = [self returnDateForMonth:dateComponents.month+1 year:dateComponents.year day:0];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sDate >= %@) AND (sDate <= %@)", firstDateOfMonth, lastDateOfMonth];
            
            NSArray * temp = [objBatches.batchesTimes filteredArrayUsingPredicate:predicate];
            NSLog(@"%lu",(unsigned long)temp.count);
            if (temp.count == 0) {
                showAletViewWithMessage([NSString stringWithFormat:@"Please add atleast one batch for month %@ of class %lu Please enter between start & end date",[frmMONTHFormatter() stringFromDate:firstDateOfMonth],(unsigned long)[dataClass.arrCourseBatches indexOfObject:objBatches] + 1]);
                return false;
                break;
            }
        }
    }
    return true;
}
- (NSDate *)returnDateForMonth:(NSInteger)month year:(NSInteger)year day:(NSInteger)day {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

#pragma mark - UIButton Action
-(IBAction)btnAddNewBatches:(id)sender {
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Do you want to add a new batch?" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            Batches *obj = [[Batches alloc]init];
            NSString *uID = GetTimeStampString;
            obj.batchID = uID;
            [dataClass.arrCourseBatches addObject:obj];
            [ClassList insertOrUpdate:uID objects:@[] feildName:FeildNameNone];
            [collectionBatches reloadData];
            [collectionBatches scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentIndex+1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
            [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:collectionBatches afterDelay:0.4];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];

}
-(IBAction)btnDeleteNewBatches:(id)sender{
    if  (dataClass.arrCourseBatches.count == 1) {
        return;
    }
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Do you want to delete current batch Details?" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            [ClassList deleteClass:dataClass.arrCourseBatches[currentIndex].batchID];

            [dataClass.arrCourseBatches removeObjectAtIndex:currentIndex];
            currentIndex = (currentIndex == 0) ? currentIndex : currentIndex - 1;
            [collectionBatches reloadData];
            [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:collectionBatches afterDelay:0.4];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
}
-(IBAction)btnBatchChange:(UIButton*)sender {
    if (sender.tag == 11 && dataClass.arrCourseBatches.count > 0 && currentIndex > 0) {
        //Pre
        [collectionBatches scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentIndex-1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];

    }else if(sender.tag == 12 && currentIndex < dataClass.arrCourseBatches.count -1) {
        //Nect
        [collectionBatches scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentIndex+1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];

    }
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:collectionBatches afterDelay:0.4];
}
#pragma mark - UIButton
-(IBAction)btnNext:(UIButton*)sender {
    if (![self batchValidation]) {
        return;
    }
    FromOptionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"FromOptionVC"];
    [self.navigationController pushViewController:vc animated:true];
 
}
#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return dataClass.arrCourseBatches.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width,collectionView.frame.size.height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CellBatches * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.controller = self;
    [cell.tblBatches reloadData];
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    currentIndex = self.collectionBatches.contentOffset.x / self.collectionBatches.frame.size.width;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [collectionBatches reloadData];
    CGFloat pageWidth = collectionBatches.frame.size.width;
    float currentPage = collectionBatches.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        currentIndex = currentPage + 1;
    } else {
        currentIndex = currentPage;
    }
    lblBatch.text = [NSString stringWithFormat:@"Batch %ld",currentIndex + 1];
    lblBatchTotal.text = [NSString stringWithFormat:@"Batches added: %lu",(unsigned long)dataClass.arrCourseBatches.count];
    
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
