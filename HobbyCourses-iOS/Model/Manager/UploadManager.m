//
//  UploadManager.m
//  HobbyCourses-iOS
//
//  Created by Kirit on 14/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "UploadManager.h"
#import "AppUtils.h"

@implementation UploadManager{
    NSArray *arrayImagesForUpload;
    int totalUploads;
    NSMutableArray *arrayFids;
}

+ (instancetype) sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)uploadImagesWithArray:(NSArray *)arrayImages{
    
    arrayImagesForUpload = arrayImages;
    totalUploads = arrayImages.count;
    arrayFids = [NSMutableArray array];
    
    [self uploadImageForIndex:0];
    
}

-(void)uploadImageForIndex:(int)index{
    
    UIImage *image = [arrayImagesForUpload objectAtIndex:index];
    
    NSDictionary *dataDict = @{@"filename" : @"savedImage001.jpg",
                               @"target_uri" : @"public://savedImage001.jpg",
                               @"filemime" : @"image/jpeg",
                               @"file" : [AppUtils convertImageToBase64:image]};
    
    [[NetworkManager sharedInstance] postRequestFullUrl:apiUploadFile paramter:dataDict withCallback:^(id jsonData, WebServiceResult result) {
        
        if (result == WebServiceResultSuccess){
            
            NSLog(@"response of Image upload Deal Dict  result---------aaaaa-------===>%@",jsonData);
            if ([jsonData valueForKey:@"fid"])
            {
                [arrayFids addObject:[jsonData valueForKey:@"fid"]];
                
                if (self.delegate) {
                    
                    if ([self.delegate respondsToSelector:@selector(updateProgress:total:)]) {
                        [self.delegate performSelector:@selector(updateProgress:total:) withObject:[NSNumber numberWithInt:index+1] withObject:[NSNumber numberWithInt:totalUploads]];
                    }
                    
                    if (index == totalUploads - 1) {
                        if ([self.delegate respondsToSelector:@selector(uploadCompleted:)]) {
                            [self.delegate performSelector:@selector(uploadCompleted:) withObject:[NSArray arrayWithArray:arrayFids]];
                        }
                    }else{

                        // upload next image
                        [self uploadImageForIndex:index+1];
                    }
                }
            }
            
        }else{
            
            NSLog(@"Fail to upload");
            if (self.delegate && [self.delegate respondsToSelector:@selector(uploadFailed)]) {
                [self.delegate performSelector:@selector(uploadFailed) withObject:nil];
            }
        }
    }];
}
@end
