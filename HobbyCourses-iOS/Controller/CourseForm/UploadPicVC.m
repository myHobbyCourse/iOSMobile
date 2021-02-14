//
//  UploadPicVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "UploadPicVC.h"

@interface UploadPicVC ()<QBImagePickerControllerDelegate>

@end

@implementation UploadPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Image Upload Screen"];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    if ([DataClass getInstance].crsImages.count > 0 && indexPath.row == 0) {
        cellIdentifier = @"Cell2";
        FromPicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell.cvImages reloadData];
        NSString *imgString = [[DocumentAccess obj] mediaForNameString:dataClass.crsImages[indexPath.row]];
        if (imgString) {
            cell.imgPreview.image = [UIImage imageWithContentsOfFile:imgString];
        }

        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 1) {
            UIView *viewBorder = [cell viewWithTag:11];
            viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
            viewBorder.layer.borderWidth = 1.0;
            viewBorder.layer.cornerRadius = 8;
        }
        return cell;
    }
    
}
#pragma mark - UIButton
-(IBAction)btnNext:(UIButton*)sender {
    if (dataClass.crsImages.count == 0) {
        showAletViewWithMessage(@"No need for a thousand words, please select a picture for course");
        return;
    }

    FormBatchesVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: (is_iPad()) ? @"FormBatchesVC_iPad" : @"FormBatchesVC"];
    [self.navigationController pushViewController:vc animated:true];
}
-(IBAction)btnOpenGallery:(UIButton*)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized)
        {
            if ([DataClass getInstance].crsImages.count == 5) {
                return;
            }
            QBImagePickerController *imagePickerController = [QBImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.minimumNumberOfSelection = 1;
            imagePickerController.maximumNumberOfSelection = 5 - [DataClass getInstance].crsImages.count;
            imagePickerController.showsNumberOfSelectedAssets = YES;
            [self presentViewController:imagePickerController animated:YES completion:NULL];
        } else {
            //No permission. Trying to normally request it
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status != PHAuthorizationStatusAuthorized)
                {
                    //User don't give us permission. Showing alert with redirection to settings
                    //Getting description string from info.plist file
                    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
                    [AppUtils actionWithMessage:accessDescription withMessage:@"To give permissions tap on 'Change Settings' button" alertType:UIAlertControllerStyleAlert button:@[@"Change Settings"] controller:self block:^(NSString *tapped) {
                        if ([tapped isEqualToString:@"Change Settings"]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                        }
                    }];
                }
            }];
        }
    });
}
-(IBAction)btnCamera:(UIButton*)sender {
    
    if ([DataClass getInstance].crsImages.count == 5) {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        showAletViewWithMessage(@"Your device don't have camera");
    }
}
-(IBAction)btnRemovePic:(UIButton*)sender{
    [AppUtils actionWithMessage:kAppName withMessage:@"Do you want to Upload or Delete snap?" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            NSString *row = dataClass.crsImages[dataClass.selectedPreviewImg];
            [ImageList deleteImage:row];
            [dataClass.crsImages removeObjectAtIndex:[DataClass getInstance].selectedPreviewImg];
            if ([DataClass getInstance].selectedPreviewImg > 1) {
                [DataClass getInstance].selectedPreviewImg = [DataClass getInstance].selectedPreviewImg - 1;
            }else if([DataClass getInstance].crsImages.count > 0){
                [DataClass getInstance].selectedPreviewImg = 0;
            }
            [tblParent reloadData];
        }
    }];
}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *uID = GetTimeStampString;
    NSData *data= UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 0.4);
    HCLog(@"Size of Image(bytes):%lu",(unsigned long)[data length]);
    [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[uID] feildName:FeildNameImage];
    
    if ([[DocumentAccess obj] setMedia:data forName:uID]) {
        [[DataClass getInstance].crsImages addObject:uID];
    }
    
    [tblParent reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Picker Delegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    for (PHAsset *asset in assets) {
        // Do something with the asset
        NSString *uID = GetTimeStampString;
        NSData *data= UIImageJPEGRepresentation([asset getAssetOriginal], 0.4);
        HCLog(@"Size of Image(bytes):%lu",(unsigned long)[data length]);
        [CourseForm insertOrUpdateCourseForm:dataClass.rowID objects:@[uID] feildName:FeildNameImage];
        if ([[DocumentAccess obj] setMedia:data forName:uID]) {
            [[DataClass getInstance].crsImages addObject:uID];
        }
    }
    
    [DataClass getInstance].selectedPreviewImg = 0;
    [tblParent reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
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
