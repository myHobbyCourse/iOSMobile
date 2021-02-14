//
//  NSString+StringExtension.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 19/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringExtension)
-(NSString*) tringString;
-(NSString*) getVideoThumURL;
-(NSString*) removeNull;
-(NSString *) removeHTML;
-(NSString*) removeSymbols;
-(CGRect) getStringHeight:(CGFloat) width font:(UIFont*) font;
@end
