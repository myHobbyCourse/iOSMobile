//
//  SubmitForm+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 14/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SubmitForm+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SubmitForm (CoreDataProperties)

+ (NSFetchRequest<SubmitForm *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *courseData;
@property (nullable, nonatomic, copy) NSString *courseID;

@end

NS_ASSUME_NONNULL_END
