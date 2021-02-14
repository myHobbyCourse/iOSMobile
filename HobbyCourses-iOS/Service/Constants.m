//
//  Constant.m


#import "Constants.h"

NSString* const kInternalError      = @"Some internal error occured";
NSString* const kNoRecord           = @"No record found";

NSString* const kUserInformationKey = @"UserInformationDictionaryKey";
NSString* const kUserMessageKey     = @"KUserMessageKey";
NSString* const kUserOrderKey       = @"kUserOrderKey";
NSString* const kFavKey             = @"kFavKey";
NSString* const kVendorSalesKey     = @"kVendorSalesKey";
NSString* const kUserCouponKey      = @"kUserCouponKey";
NSString* const kCategoryKey        = @"kCategoryKey";
NSString* const kCourseListKey      = @"kCourseListKey";
NSString* const kCourseDetailKey    = @"kCourseDetailKey";
NSString* const kLocalKey           = @"kLocalKey";
NSString* const kRecentKey          = @"kRecentKey";
NSString* const kWeekendKey         = @"kWeekendKey";

NSString* const kMyReviewKey        = @"kMyReviewKey";
NSString* const kFAQKey             = @"kFAQKey";
NSString* const kisTwitterLogin     = @"kisTwitterLogin";
NSString* const kisFBLogin          = @"kisFBLogin";
NSString* const kisGoogleLogin      = @"kisGoogleLogin";

NSString* const kSelectedCity       = @"kSelectedCity";

NSString* const kUserDeviceTokenKey = @"UserDeviceTokenKey";
NSString* const kUserTokenKey       = @"UserOuthTokenKey";
NSString* const kUserTokenSecretKey = @"UserOuthSecretKey";
NSString* const kUserIsFBLogin      = @"isFBLogin";
NSString* const kUserAddress        = @"UserAddress";
UserDetail *userINFO = nil;



///* global variables */
NSDictionary          *userInformation = nil;
AppDelegate           *appDelegator = nil;
NSDateFormatter       *__serverFormatter = nil ;
BOOL                  showCame = NO;
BOOL                  isFBRegister = NO;
NSMutableArray<CategoryEntity*>  *_arrCategoryC;
NSMutableArray<NSString*> *_arrColorsBathces;

//Statusbar related

NSInteger statusBarStyle = 0;
NSInteger indexController = 0;


inline bool is_iPad()
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return NO;
}


BOOL validateEmail(NSString *candidate)
{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:candidate];
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

BOOL validateMobile(NSString *candidate)
{
    NSString *mobileRegex = @"^((\\+91-?)|0)?[0-9]{10}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:candidate];
}
NSString* getUDID()
{
    NSString *udid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    NSLog(@"%@",udid);
    return udid;
}
NSString* formatNumber(NSString* mobileNumber)
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
    }
    return mobileNumber;
}
NSString* showformatNumber(NSString* mobileNumber)
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
    }
    if (mobileNumber.length>0) {
        mobileNumber = [NSString stringWithFormat:@"%@-%@-%@", [mobileNumber substringToIndex:3], [mobileNumber substringWithRange:NSMakeRange(3, 3)],[mobileNumber substringFromIndex:6]];
    }
    return mobileNumber;
}

NSInteger getLength(NSString* mobileNumber)
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
   
    NSInteger length = [mobileNumber length];
    
    return length;
}
 NSString* NSStringWithoutSpace(NSString* string)
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

 NSString* NSStringFromCurrentDate(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

 NSString* NSImageNameStringFromCurrentDate(void)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpeg",[formatter stringFromDate:[NSDate date]]];
    return imageName;
}

 NSString* NSStringWithMergeofString(NSString* first,NSString* last)
{
    return [NSString stringWithFormat:@"%@ %@",first,last];
}

 NSString* NSStringFullname(NSDictionary* aDict)
{
    if(!aDict[@"vLast"] || ![aDict[@"vLast"] length])
        return aDict[@"vFirst"];
    else
        return [NSString stringWithFormat:@"%@ %@",aDict[@"vFirst"],aDict[@"vLast"]];
}

void showAletViewWithMessage(NSString* msg)
{
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:msg bgColor:__THEME_YELLOW button:@[@"Ok"] controller:nil block:^(Tapped tapped, ActionAlert *alert) {
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
    
    /*UIAlertView *alert123 = [[UIAlertView alloc]initWithTitle:kAppName
                                      message:msg
                                     delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil, nil];
    [alert123 show];*/
}
void showAletViewWithTitleMessage(NSString* title,NSString* msg)
{
    UIAlertView *alert123 = [[UIAlertView alloc]initWithTitle:title
                                                      message:msg
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil, nil];
    [alert123 show];
}
NSString* AgoStringFromTime(NSDate* dateTime)
{
    NSDictionary *timeScale = @{@"sec"  :@1,
                                @"min"  :@60,
                                @"hr"   :@3600,
                                @"day"  :@86400,
                                @"week" :@605800,
                                @"month":@2629743,
                                @"year" :@31556926};
    NSString *scale;
    int timeAgo = 0-(int)[dateTime timeIntervalSinceNow];
    if (timeAgo < 60) {
        scale = @"sec";
    } else if (timeAgo < 3600) {
        scale = @"min";
    } else if (timeAgo < 86400) {
        scale = @"hr";
    } else if (timeAgo < 605800) {
        scale = @"day";
    } else if (timeAgo < 2629743) {
        scale = @"week";
    } else if (timeAgo < 31556926) {
        scale = @"month";
    } else {
        scale = @"year";
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    NSString *s = @"";
    if (timeAgo > 1) {
        s = @"s";
    }
    
    return [NSString stringWithFormat:@"%d %@%@", timeAgo, scale, s];
}

UIImage* takeSnapshotOfView(UIView *view)
 {
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}
NSString* convertObjectToJson(NSObject* object)
{
    if (object) {
        NSError *writeError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
        NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return result;
    }
    return @"";
}
#pragma mark - Get Time From course modal
NSString* getTime(id entity)
{
    if ([entity isKindOfClass:[Course class]])
    {
        Course * course = entity;
        NSDateFormatter *format24 = global24Formatter();
        NSDateFormatter *fromatTime = _timeFormatter();
        NSMutableArray *times =[[NSMutableArray alloc]init];
        if (course.productArr && course.productArr.count > 0) {
            for (ProductEntity *obj in course.productArr) {
                for (NSDictionary * d in obj.timings) {
                    if (d[@"value"] != nil && d[@"value2"] != nil) {
                        NSString *start = d[@"value"];
                        NSString *end = d[@"value2"];
                        NSDate *s1 = [format24 dateFromString:start];
                        NSDate *e2 = [format24 dateFromString:end];
                        if (s1 && e2) {
                            NSString  *startDate = [fromatTime stringFromDate:s1];
                            NSString *endDate = [fromatTime stringFromDate:e2];
                            [times addObject:[NSString stringWithFormat:@"%@-%@",startDate,endDate]];
                        }
                    }
                    if (times.count > 0) {
                        break;
                    }
                }
                if (times.count > 0) {
                    break;
                }
            }
        }
        
        return (times.count == 0)? @"No Time":times[0];
    }
    else
    {
        CourseDetail * course = entity;
        NSDateFormatter *format24 = global24Formatter();
        NSDateFormatter *fromatTime = _timeFormatter();
        NSMutableArray *times =[[NSMutableArray alloc]init];
        if (course.productArr && course.productArr.count > 0) {
            for (ProductEntity *obj in course.productArr) {
                for (NSDictionary * d in obj.timings) {
                    if (d[@"value"] != nil && d[@"value2"] != nil) {
                        NSString *start = d[@"value"];
                        NSString *end = d[@"value2"];
                        NSDate *s1 = [format24 dateFromString:start];
                        NSDate *e2 = [format24 dateFromString:end];
                        if (s1 && e2) {
                            NSString  *startDate = [fromatTime stringFromDate:s1];
                            NSString *endDate = [fromatTime stringFromDate:e2];
                            [times addObject:[NSString stringWithFormat:@"%@-%@",startDate,endDate]];
                        }
                    }
                    if (times.count > 0) {
                        break;
                    }
                }
                if (times.count > 0) {
                    break;
                }
            }
        }
        return (times.count == 0)? @"No Time":times[0];
    }
    return @"";
    
}
NSString* getDays(id entity)
{
    NSString *names = @"";
    if ([entity isKindOfClass:[Course class]])
    {
        Course * course = entity;
        if(course.productArr.count > 0) {
            ProductEntity * ent = course.productArr[0];
            NSArray *arrDays = [ent.timingsDate mapObjectsUsingBlock:^id(TimeBatch *obj, NSUInteger idx){
                return obj.dayName;
            }];
            NSSet *daysSet = [NSSet setWithArray:arrDays];
            names = [[daysSet allObjects] componentsJoinedByString:@","];

        }
    }
    else
    {
        CourseDetail * course = entity;
        if(course.productArr.count > 0) {
            ProductEntity * ent = course.productArr[0];
            
            NSArray *arrDays = [ent.timingsDate mapObjectsUsingBlock:^id(TimeBatch *obj, NSUInteger idx){
                return obj.dayName;
            }];
            NSSet *daysSet = [NSSet setWithArray:arrDays];
            names = [[daysSet allObjects] componentsJoinedByString:@","];
        }
    }
    return ([names isEqualToString:@""]) ? @"No Day" :names;
    
}
NSMutableArray* getWeekDate(NSDate *week) {
    
    NSDate *date = nextDayFromDate(week);
    NSDateComponents *components;
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    [components2 setDay:1];
    
    NSMutableArray *_weekdays = [[NSMutableArray alloc] init];
    
    for (register unsigned int i=0; i < 7; i++) {
        [_weekdays addObject:date];
        components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
        [components setDay:1];
        date = [CURRENT_CALENDAR dateByAddingComponents:components2 toDate:date options:0];
    }
    return _weekdays;
}
NSDate * nextDayFromDate(NSDate *date) {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    [components setDay:[components day] + 1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [CURRENT_CALENDAR dateFromComponents:components];
}
#pragma mark - Get Storyboard
UIStoryboard* getStoryBoardDeviceBased(StoryboardName name)
{
    UIStoryboard *mainStoryboard;
    if (is_iPad())
    {
        switch (name) {
            case StoryboardProfile:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Profile_iPad" bundle: nil];
                break;
            case StoryboardPop:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Pop" bundle: nil];
                break;
            case StoryboardRevision:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Revision_iPad" bundle: nil];
                break;
            case StoryboardAttendance:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Attendance_iPad" bundle: nil];
                break;
            case StoryboardTutor:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Tutor_iPad" bundle: nil];
                break;
            case StoryboardVenue:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Venue_iPad" bundle: nil];
                break;
            case StoryboardLearnerMain:
                mainStoryboard = [UIStoryboard storyboardWithName:@"CourseMain_iPad" bundle: nil];
                break;
            case StoryboardCourseFrom:
                mainStoryboard = [UIStoryboard storyboardWithName:@"CourseFrom_iPad" bundle: nil];
                break;
            case StoryboardFormPop:
                mainStoryboard = [UIStoryboard storyboardWithName:@"FormPop_iPad" bundle: nil];
                break;
            case StoryboardSearch:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Search_iPad" bundle: nil];
                break;
            case StoryboardCourseDetails:
                mainStoryboard = [UIStoryboard storyboardWithName:@"CourseDetails" bundle: nil]; // This is Mobile StoryBoard
                break;
            case StoryboardSettings:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Setting_iPad" bundle: nil];
                break;
            case StoryboardCourseDetail:
                mainStoryboard = [UIStoryboard storyboardWithName:@"CourseBooking" bundle: nil];
                break;
            default:
                mainStoryboard = [UIStoryboard storyboardWithName:@"StoryboardiPad"
                                                           bundle: nil];
            break;
        }
    }else{
        switch (name) {
            case StoryboardMain:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                break;
            case StoryboardFaq:
                mainStoryboard = [UIStoryboard storyboardWithName:@"FAQ" bundle: nil];
                break;
            case StoryboardEntry:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Entry" bundle: nil];
                break;
            case StoryboardPop:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Pop" bundle: nil];
                break;
            case StoryboardRevision:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Revision" bundle: nil];
                break;
            case StoryboardAttendance:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Attendance" bundle: nil];
                break;
            case StoryboardTutor:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Tutor" bundle: nil];
                break;
            case StoryboardVenue:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Venue" bundle: nil];
                break;
            case StoryboardSalesDash:
                mainStoryboard = [UIStoryboard storyboardWithName:@"SalesDashboard" bundle: nil];
                break;
            case StoryboardFormPop:
                mainStoryboard = [UIStoryboard storyboardWithName:@"FormPop" bundle: nil];
                break;
            case StoryboardSearch:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle: nil];
                break;
            case StoryboardCourseFrom:
                mainStoryboard = [UIStoryboard storyboardWithName:@"CourseFrom" bundle: nil];
                break;
            case StoryboardProfile:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Profile" bundle: nil];
                break;
            case StoryboardLearnerMain:
                mainStoryboard = [UIStoryboard storyboardWithName:@"CourseMain" bundle: nil];
                break;
            case StoryboardSettings:
                mainStoryboard = [UIStoryboard storyboardWithName:@"Setting" bundle: nil];
                break;
            case StoryboardCourseDetail:
                mainStoryboard = [UIStoryboard storyboardWithName:@"CourseDetail" bundle: nil];
                break;
            default:
                break;
        }
    }
    return mainStoryboard;
}
NSDateFormatter* dateSimpleFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MM-yyyy";
    });
    return formatter;
}
NSDateFormatter* global24Formatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    });
    return formatter;
}
NSDateFormatter* mmm24Formatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yyyy HH:mm";
    });
    return formatter;
}
NSDateFormatter* ddMMMyyyyHHmmss(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yyyy HH:mm:ss";
    });
    return formatter;
}
NSDateFormatter* ddMMMHHmmss(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM HH:mm:ss";
    });
    return formatter;
}
NSDateFormatter* ddMMMHHmm(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM HH:mm";
    });
    return formatter;
}
NSDateFormatter* globalDAYFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EE";
    });
    return formatter;
}
NSDateFormatter* dayNameFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE";
    });
    return formatter;
}
NSDateFormatter* frmMONTHFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMMM";
    });
    return formatter;
}
NSDateFormatter* _timeFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"hh:mm a";
    });
    return formatter;
}

NSDateFormatter* global12Formatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd hh:mm a";
    });
    return formatter;
}
NSDateFormatter* globalDateOnlyFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yyyy";
    });
    return formatter;
}
NSDateFormatter* global2DIGItYearFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yy";
    });
    return formatter;
}
NSDateFormatter* frmtDaysTimeFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE, hh:mm a";
    });
    return formatter;
}
NSDateFormatter * f2DIGItYearTimeFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yy HH:mm";
    });
    return formatter;
}

NSDateFormatter * ddMMMyyhhmma(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MMM-yy hh:mm a";
    });
    return formatter;
}
NSDateFormatter* globalDateFormatter(){
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return formatter;
}

NSString* getBatchColor(NSDate *date){
    if ([[globalDAYFormatter() stringFromDate:date] isEqualToString:@"Sun"]) {
        return _arrColorsBathces[0];
    }
    if ([[globalDAYFormatter() stringFromDate:date] isEqualToString:@"Mon"]) {
        return _arrColorsBathces[1];
    }
    if ([[globalDAYFormatter() stringFromDate:date] isEqualToString:@"Tue"]) {
        return _arrColorsBathces[2];
    }
    if ([[globalDAYFormatter() stringFromDate:date] isEqualToString:@"Wed"]) {
        return _arrColorsBathces[3];
    }
    if ([[globalDAYFormatter() stringFromDate:date] isEqualToString:@"Thu"]) {
        return _arrColorsBathces[4];
    }
    if ([[globalDAYFormatter() stringFromDate:date] isEqualToString:@"Fri"]) {
        return _arrColorsBathces[5];
    }
    if ([[globalDAYFormatter() stringFromDate:date] isEqualToString:@"Sat"]) {
        return _arrColorsBathces[6];
    }
    
    return @"F52375";
}
