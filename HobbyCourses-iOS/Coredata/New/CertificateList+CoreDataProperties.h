//
//  CertificateList+CoreDataProperties.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CertificateList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CertificateList (CoreDataProperties)

+ (NSFetchRequest<CertificateList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *certificateName;
@property (nullable, nonatomic, copy) NSString *certificateIndex;
@property (nullable, nonatomic, copy) NSString *courseID;
@property (nullable, nonatomic, retain) CourseForm *course;
@end

NS_ASSUME_NONNULL_END
