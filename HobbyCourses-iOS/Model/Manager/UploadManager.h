//
//  UploadManager.h
//  HobbyCourses-iOS
//
//  Created by Kirit on 14/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadManagerDelegate <NSObject>

- (void)updateProgress:(NSNumber *)completed total:(NSNumber *)totalUpload;
- (void)uploadCompleted:(NSArray *)arrayFids;
- (void)uploadFailed;

@end

@interface UploadManager : NSObject
{
    NSMutableArray *tempImg;
}
@property (nonatomic, weak) id<UploadManagerDelegate> delegate;

+ (instancetype) sharedInstance;

-(void)uploadImagesWithArray:(NSArray *)arrayImages;

@end
