//
//  YoutubeCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 14/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YoutubeCelldelegate <NSObject>

// we will make one function mandatory to include
@optional
- (void)editDidFinish:(NSMutableDictionary *)result;


// and the other one is optional (this function has not been used in this tutorial)
- (void)editStarted:(NSString *)field;

@end

@interface YoutubeCell : UITableViewCell<UITextFieldDelegate>
{
    id <YoutubeCelldelegate> delegate;
}
@property(strong,nonatomic) IBOutlet UIButton *btnYoutube;
@property(strong,nonatomic) IBOutlet UITextField *tfYoutube;
@property (nonatomic, assign) id <YoutubeCelldelegate> delegate;

@end
