//
//  Constant.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <MapKit/MapKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "YTPlayerView.h"
#import <AddressBook/AddressBook.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "QBImagePickerController.h"
#import "UIImageView+WebCache.h"
#import "NSMutableArray+Extension.h"
#import "AppUtils.h"
#import "AppDelegate.h"
#import "MYLocationManager.h"
#import "ParentViewController.h"
#import "SelectCityViewController.h"
#import "PayPalMobile.h"
#import "PayPalManager.h"
#import "SelectCityTableViewCell.h"
#import "YoutubeCollectionViewCell.h"
#import "RateView.h"
#import "Review.h"
#import "PaddingTextField.h"
#import "NMRangeSlider.h"
#import "WriteReviewViewController.h"
#import "FAndQViewController.h"
#import "MyCommentViewController.h"
#import "QuestionFQViewController.h"
#import "VendorViewController.h"
#import "AnswerViewController.h"
#import "SalesStatViewController.h"
#import "VendorCollectionReusableView.h"
#import "NetworkManager.h"
#import "CommentListVC.h"
#import "ShoppingCartViewController.h"

#import "CategoryEntity.h"
#import "SubCategoryEntity.h"
#import "Course.h"
#import "CourseDetail.h"

#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import "OAToken.h"

#import "User.h"
#import "ReviewTableViewCell.h"
#import "CourseTableViewCell.h"
#import "MyReview.h"
#import "UserDetail.h"
#import "UserOrder.h"
#import "Coupon.h"
#import "SoldCourses.h"
#import "SoldCourseCell.h"
#import "ConversationViewController.h"
#import "JSONModel.h"
#import "YoutubeCell.h"
#import "CertificatesCell.h"
#import "MyReview.h"
#import "OrderDetailCell.h"
#import "OrderDetail.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "UploadManager.h"
#import "CourseListCollectionViewCell.h"
#import "CourseLocationViewController.h"
#import "SearchViewController.h"
#import "PDKPin.h"
#import "ShareActivity.h"
#import "NSMutableDictionary+Extension.h"
#import "MessagesViewController.h"
#import "MyCouponsViewController.h"
#import "OrderCoursesViewController.h"
#import "JTMaterialSwitch.h"
#import "PopUpViewController.h"
#import "FavCourseViewController.h"
#import "FavCourse.h"
#import "SpalshViewController.h"
#import "UIColor+Hex.h"
#import "NSString+StringExtension.h"

#import "MyCourseOffline.h"
#import "MyCourseOffline+CoreDataProperties.h"
#import "CourseFrom.h"
#import "ProductEntity.h"
#import "ProductCell.h"
#import "CollectionBatchesCell.h"
#import "MAWeekView.h"
#import "MAGridView.h"
#import "TimePopUp.h"
#import "BatchTimeTable.h"
#import "DateCalenderPickerVC.h"
#import "CourseBatchDisplayVC.h"
#import "TempStore.h"
#import "BatchDisplay.h"
#import "NSDate+NSDateUtility.h"
#import "TimeBatch.h"
#import "BankTransferVC.h"
#import "ValidationToast.h"
#import "PopVC.h"
#import "MyCoursesViewController.h"
#import "AFNetworking.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Google/Analytics.h>
#import "BankTransferVC.h"
#import "RevisionListVC.h"
#import "RevisionListCell.h"
#import "RevisionHistoryData.h"
#import "RevisionHistoryTimings.h"
#import "RevisionDetailVC.h"
#import "RevisonBatches.h"
#import "AttScheduleVC.h"
#import "CourseSchedule.h"
#import "AttCalenderVC.h"
#import "StudentAttendaceVC.h"
#import "StudentAttCell.h"
#import "Student.h"
#import "Attendance.h"
#import "AttendanceViewCell.h"
#import "AttendanceVC.h"
#import "AttAddCommentVC.h"
#import "OrderCoursesViewController.h"
#import "ImageZoomViewController.h"

#import "TutorListVC.h"
#import "TutorsEntity.h"
#import "TutorDetailsVC.h"
#import "VenueListVC.h"
#import "VenuesEntity.h"
#import "VenueDetailsVC.h"

#import "SalesDashBoardVC.h"
#import "ConstrainedTableViewCell.h"
#import "CourseListingCell.h"
#import "CourseListingVC.h"
#import "CourseDetailsVC.h"
#import "CourseWebTextCell.h"
#import "CourseDetailBatchVC.h"
#import "CourseReviewVC.h"
#import "CourseShareVC.h"
#import "CancellationVC.h"
#import "CourseDetailsCell.h"
#import "ConstrainedView.h"
#import "ActionAlert.h"
#import "EditProfileCell.h"
#import "VendorProfileVC.h"
#import "VendorCell.h"
#import "FormLocationCell.h"

#import "FormHintVC.h"
#import "FromPicCell.h"
#import "ValueSelectorVC.h"
#import "CategoryEntity.h"
#import "CourseLocationVC.h"
#import "FromDetailsVC.h"
#import "CourseDescVC.h"
#import "FormPriceVC.h"
#import "FromOptionVC.h"
#import "SignUpCell.h"
#import "TTRangeSlider.h"
#import "Search.h"
#import "ClassSelectionVC.h"
#import "OrderBySelectionVC.h"
#import "RadiusSelectionVC.h"
#import "FiltersVC.h"
#import "AgeSelectionVC.h"
#import "PriceRangeVC.h"
#import "SessionSelectionVC.h"
#import "WeekDaysVC.h"
#import "CitySelectionVC.h"
#import "Batches.h"
#import "CellBatches.h"
#import "CellCalenderBatch.h"
#import "FormBatchesVC.h"
#import "TimeSelectionVC.h"
#import "SessionSelectionVC.h"
#import "CourseSummaryVC.h"
#import "ReadyToPublishCourseVC.h"
#import "FromHomeVC.h"
#import "PaymentAddressVC.h"
#import "BatchTimeAlert.h"
#import "ActivityHud.h"
#import "CourseMapPop.h"
#import "UserPhoneBook.h"
#import "ProfileComlateVC.h"
#import "EditProfileVC.h"
#import "StudeInfo.h"
#import "PaymentOptionVC.h"
#import "PaymentAddressVC.h"
#import "PhoneVerifyVC.h"
#import "PreviewCourseVC.h"
#import "BookingSettingVC.h"
#import "CategoryCoursesVC.h"
#import "AllowNotificationVC.h"
#import "HelpVC.h"
#import "ForgotPasswordViewController.h"
#import <SafariServices/SafariServices.h>
#import "AllowLocationVC.h"
#import "CourseListingVC_iPad.h"
#import "CourseDetailsVC_iPad.h"
#import "AgeSelectionVC.h"
#import "PriceRangeVC.h"
#import "WeekDaysVC.h"
#import "SessionSelectionVC.h"
#import "BraintreeCore.h"
#import "BraintreeUI.h"
#import "BraintreeApplePay.h"
#import "Braintree3DSecure.h"
#import "FromOptionVC_iPad.h"
#import "AttMarkVC_iPad.h"
#import "AttReportVC_iPad.h"
#import "SelectCategorySubPopVC_iPad.h"
#import "ProfileComlateVC_iPad.h"
#import "FavCollectionCell.h"
#import "MyCourseCVCell.h"
#import "VendorCell_iPad.h"
#import "AddTutorVC_iPad.h"
#import "AddTutorCell.h"
#import "AddVenueCell.h"
#import "HobbyTabBarController.h"
#import "CitySelectionVC.h"
#import "TutorListVC_iPad.h"
#import "VenueListVC_iPad.h"
#import "AmenitiesVC.h"
#import "BatchHeaderView.h"

#import "SubCategoryEntity.h"
#import "ScheduleList+CoreDataClass.h"
#import "CategoryTbl+CoreDataClass.h"
#import "SubCategoryTbl+CoreDataClass.h"
#import "ClassList+CoreDataClass.h"
#import "CertificateList+CoreDataClass.h"
#import "CourseForm+CoreDataClass.h"
#import "ImageList+CoreDataClass.h"
#import "AmeitiesList+CoreDataClass.h"
#import "VideoList+CoreDataClass.h"
#import "Amenities.h"
#import "QRScanPopVC.h"

@import GooglePlaces;
@import GoogleMaps;

#import "DataClass.h"

#import "SubmitForm+CoreDataClass.h"


#import "HobbyCourses-Swift.h"




#define googleKey @"AIzaSyDw5hS5DfkvOX-rWGL-ZhT-5EfrKqDlwM0"

#define _courseNidOfflince @"E6FF9C"

#define kCurrency               @"£"
#define kAppBuildNo             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
#define kAppVersion             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define _screenSize  [UIScreen mainScreen].bounds.size

#define _heighRatio   _screenSize.height/736
#define _widthRatio   _screenSize.width/414

#define _widthRatioIPAD   _screenSize.width/1024

#define _placeHolderImg   [UIImage imageNamed:@"placeholder"]

#define __THEME_COLOR       [UIColor colorWithRed:(float)245/255 green:(float)43/255  blue:(float)121/255  alpha:1.0]
#define __Light_Gray       [UIColor colorWithRed:(float)244/255 green:(float)244/255  blue:(float)244/255  alpha:1.0]
#define __THEME_GRAY       [UIColor colorWithRed:(float)69/255 green:(float)69/255  blue:(float)69/255  alpha:1.0]
#define __THEME_GREEN       [UIColor colorWithRed:(float)56/255 green:(float)99/255  blue:(float)0/255  alpha:1.0]
#define __THEME_DarkBrown       [UIColor colorWithRed:(float)144/255 green:(float)62/255  blue:(float)0/255  alpha:1.0]

#define __THEME_YELLOW       [UIColor colorFromHexString:@"E6FF9C"]
#define __THEME_lightGreen       [UIColor colorFromHexString:@"89CBC9"]
#define __THEME_DarkGreen       [UIColor colorWithRed:(float)0/255 green:(float)68/255  blue:(float)105/255  alpha:1.0]


#define dataClass [DataClass getInstance]
#define DefaultCenter           [NSNotificationCenter defaultCenter]


#define __text_placeholder_color [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]


#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

#define _COLOR(R,G,B,ALPHA) [[UIColor alloc]initWithRed:(float)R/255 green:(float)G/255 blue:(float)B/255 alpha:ALPHA]

#define __APP_AVENIRLTSTD_LIGHT_FONT(X)   [UIFont fontWithName:@"AvenirLTStd-Light" size:X]
#define __APP_AVENIRLTSTD_BOOK_FONT(X)   [UIFont fontWithName:@"AvenirLTStd-Book" size:X]
#define __APP_AVENIRLTSTD_HEAVY_FONT(X)   [UIFont fontWithName:@"AvenirLTStd-Heavy" size:X]

#define LOCACTION_SHAREOBJ       [NNLocationManager sharedInstance]

# define APPDELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefault   [NSUserDefaults standardUserDefaults]
#define DefaultCenter [NSNotificationCenter defaultCenter]

#define __QUE_PH_IMG  [UIImage imageNamed:@"back_welcome_4inch_blur"]
#define __USER_PH_IMG [UIImage imageNamed:@"user_placeholder_gray"]
#define __QUE_PH_IMG_THUMB  [UIImage imageNamed:@"_que_holder_thumb"]
#define __QUE_PH_IMG_FULL   [UIImage imageNamed:@"_que_holder"]

#define __LOGO_PH_IMG   [UIImage imageNamed:@"icon_Logo 1"]

#define kAppName @"Hobby Courses"
#define kUserAppType @"kUserAppType"
#define __CURRENT_USER userInformation[@"userID"]

#define kLocalNotificationTime (6*60*60)

#define GetTimeStampString [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




//#define kBasePath @"http://myhobbycourses.aegir.onncrm.com/myhobbycourses_endpoint/"
#define kBasePath @"http://myhobbycourses.com/myhobbycourses_endpoint/"

#define googleKey @"AIzaSyCliTJwWyUQrusEdaWGhCc7KLyQdvps1BE"//@"AIzaSyCFzY8PwXmXAd_2Aj1zDrUmBRAa_wI-WDg"

#define WebServiceURLPaymentSandbox @"https://svcs.sandbox.paypal.com/AdaptivePayments/PaymentDetails"

#define apiPostOrder @"getorder"
#define apiPostCourse @"http://myhobbycourses.com/myhobbycourses_endpoint/node_create/create_course"
#define apiPublish @"http://myhobbycourses.com/myhobbycourses_endpoint/node_create/publish_unpublish"
#define apiUpdateCourse @"http://myhobbycourses.com/myhobbycourses_endpoint/node_create/update_course"
#define apiDeleteCourse @"http://myhobbycourses.com/myhobbycourses_endpoint/node_create/delete_course"
#define apiEditUserUrl @"http://myhobbycourses.com/myhobbycourses_endpoint/custom_user_service/update"
#define apiUploadFile @"http://myhobbycourses.com/myhobbycourses_endpoint/file"
#define apiLoginUrl @"custom_email_login/mail_login"
#define apiForgotApi @"user/request_new_password"
#define apiRegisterUrl @"user/register"
#define apiFBUrl @"custom_social_login/facebook_login"
#define apiLogoutUrl @"user/logout"
#define apiCategorylistUrl @"category_list/get"
#define apiRecentCourseUrl @"recent-50-deals-service.json"
#define apiSearchUrl @"search_courses/get_search"
#define apiTwitterUrl @"custom_social_login/twitter_login"
#define apiCityListUrl @"cities_list/get_list"
#define apiTop50Url @"top50-courses-service.json/"
#define apiRecentViewed @"recent-50-deals-service.json/"
#define apiCommentDetail @"comments.json/"
#define apifavFlagUrl @"custom_flags/flag_an_entity/"

#define apiMSGThread @"custom_privatemsg/get_all_threads_list"
#define apiMSgConversationUrl @"custom_privatemsg/get_threads_messages"
#define apiSendMSg @"custom_privatemsg/send_new_message"
#define apiReplyMsg @"custom_privatemsg/reply_to_message"
#define apiDelMsg @"custom_privatemsg/delete_message"
#define apiWishList @"info/favorite-deals"

#define apiOrderNewURL @"http://myhobbycourses.com/myhobbycourses_endpoint/vendor_sales/get_orders"
#define apiOrderURL @"http://myhobbycourses.com/user-orders.json"
#define apiCoupanUrl @"http://myhobbycourses.com/user-coupons.json"

#define apiSellerReviewUrl @"http://myhobbycourses.com/reviews-on-educator.json/"
#define apiUserDetailUrl @"http://myhobbycourses.com/user-details-service.json"
#define apiSaveProfile @"http://myhobbycourses.com/myhobbycourses_endpoint/user/"
#define apiEducatorCourseUrl @"http://myhobbycourses.com/myhobbycourses_endpoint/educator-deals.json/"

#define apiTop50Commented @"http://myhobbycourses.com/myhobbycourses_endpoint/commented50-courses-service.json/"

#define apiCourseDetailUrl @"http://myhobbycourses.com/myhobbycourses_endpoint/course-service.json/"
#define apiCommentURL @"http://myhobbycourses.com/comments.json/"

#define apiUserCommentURL @"info/user-comments"

#define apiMyCourseNew @"http://myhobbycourses.com/myhobbycourses_endpoint/my-sales-service.json/"
#define apiMysalesUrl @"http://myhobbycourses.com/myhobbycourses_endpoint/vendor_sales/get_sales"
#define apiFAQUrl @"http://myhobbycourses.com/myhobbycourses_endpoint/get_faq/get"

#define apiPostReviewComment @"http://myhobbycourses.com/myhobbycourses_endpoint/custom_add_comment/adding"
#define apiEditReviewComment @"http://myhobbycourses.com/myhobbycourses_endpoint/custom_add_comment/editing"
#define apiPush @"push_notifications"
#define apiDeletePendingOrder @"http://myhobbycourses.com//myhobbycourses_endpoint/getorder/delete_order"

#define apiRevisonList @"http://myhobbycourses.com/myhobbycourses_endpoint/get_batch_history/get_updated_ids"
#define apiRevisionDetails @"http://myhobbycourses.com/myhobbycourses_endpoint/get_batch_history/get"

#define apiGetSchedule @"http://myhobbycourses.com/myhobbycourses_endpoint/attendance/get_schedule"
#define apiAttendance @"http://myhobbycourses.com/myhobbycourses_endpoint/attendance/get_attendance"
#define apiRegAttendance @"http://myhobbycourses.com/myhobbycourses_endpoint/attendance/register_attendance"

#define apiTutorList @"info/service-tutors"
#define update_del_Tutor @"http://myhobbycourses.com/myhobbycourses_endpoint/node_create/update_delete_tutor"
//#define apiAddTutor @"http://myhobbycourses.com/myhobbycourses/myhobbycourses_endpoint/node_create/create_tutor"
#define apiTutorDetails @"http://myhobbycourses.com/service-tutor-details/"

#define apiVenueList @"info/service-venues"
#define apiUpdate_delete_venue @"http://myhobbycourses.com/myhobbycourses_endpoint/node_create/update_delete_venue"
#define apiSalesDash @"http://myhobbycourses.com/myhobbycourses_endpoint/vendor_sales/dashboard"
#define apiVerify @"http://myhobbycourses.com/myhobbycourses_endpoint/sms_pin/verify"
#define apiGetAmenities @"http://myhobbycourses.com/myhobbycourses_endpoint/amenities/get"
#define apiGoogleLogin @"http://myhobbycourses.com/myhobbycourses_endpoint/custom_social_login/google_login"

#define kFaqURL @"https://myhobbycourses.com/faq"
#define kSupportURL @"http://support.myhobbycourses.com/"
#define kPrivacyURL @"https://myhobbycourses.com/content/privacy-policy"
#define kTermURL @"https://myhobbycourses.com/terms"

#define kBraintreeToken @"http://myhobbycourses.com/myhobbycourses_endpoint/getorder"

/* ===================New Changes================ */


#define kget_hour_profile @"http://myhobbycourses.com/myhobbycourses_endpoint/hour_profile/get_hour_profile"


/* ===================New Changes================ */

#define kOAuthConsumerKey				@"cPlmGDKvKdhlskO1ZLbY8Q8XB"//@"0RBaB6eJsWkdiyA4qzdkxPy7e";//y5XunreJE0GNPa0w1ZDcSqXEi"		//REPLACE ME
#define kOAuthConsumerSecret @"IGnsaKEXl2tFF2Zz3oxOR2OIwB1VgT6vuBYRxOH5UZ8VtykyIw"			//@"RR3VxLpCs3AVvD8SUpOFGDmXmpWlmdpRyt2Zz3y6TpYXXlD9Sr";

//Live
#define ClientId_live @"AX4tI9VTFra2qDbi4ScMSF2EDjoQFuIZ6WTC6JKYazuhbOcjiN7O59bYHWdtvN6gQU3lRncc2l_TABb9"
//#define secretId_live @"EJiJBNXi7lURLlZh5zfBKqOuTPituqKigNhEInWQkUrNYsjkmxUjk_GuMXa97Z3AyBiag-5XSyYpHbeC"
//client
#define ClientId_dev @"AVSJRpTob8i7wIL2clNf90cvhXARv3je0apAUZZpeUmD4YhL7Iv-3ZNZmYIgJvX-8C1oGfhKy7OQMyl_"
//#define secretId_dev @"EPyyOVJAMimYCm9k5t04vUXd-vW6FJtUrvABdw-g2mlmiNfRUdvsbTsuPwYy5s1N8jRgILYmEpu0D-1o"
//my
//#define myClientID_Dev @"AfmthZuQhZwRMU3mh4SGmtBH5U3tnZ1B4O4CGRlWKtwclhZRDKvdQTtNPpcLUHPu8K8XdydeQHx89YDs"
//#define mySecret_dev @"ENlNYTm9NbcLeZMffblmgxO5_k28jl-0OEZo9lN8_weWHzumcryYEpKhaQ8smJENjGJu5bqIVSBHyzK6"



#define DATE_COMPONENTS (NSCalendarUnitYear| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)


#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define ThemEColor [UIColor colorFromHexString:@"F52375"]

/* global variables */
extern NSDictionary            *userInformation;
extern AppDelegate           *appDelegator;

extern NSDateFormatter         *__serverFormatter;
extern BOOL                    showCame;
extern BOOL                    isFBRegister;
//Custom Object
extern UserDetail *userINFO;

//Statusbar related
extern NSInteger statusBarStyle;
extern NSInteger indexController;
/* keys */
extern NSString* const kUserTokenKey;
extern NSString* const kUserTokenSecretKey;

extern NSString* const kUserMessageKey;
extern NSString* const kUserInformationKey;
extern NSString* const kCategoryKey;
extern NSString* const kVendorSalesKey;
extern NSString* const kUserCouponKey;
extern NSString* const kCourseListKey;
extern NSString* const kUserOrderKey;
extern NSString* const kCourseDetailKey;
extern NSString* const kMyReviewKey;
extern NSString* const kFAQKey;
extern NSString* const kFavKey;

extern NSString* const kLocalKey;
extern NSString* const kRecentKey;
extern NSString* const kWeekendKey;

extern NSString* const kUserDeviceTokenKey;
extern NSString* const kUserIsFBLogin;
extern NSString* const kUserAddress;
extern NSString* const kisTwitterLogin;
extern NSString* const kisFBLogin;
extern NSString* const kisGoogleLogin;
/* errors */
extern NSString* const kInternalError;
extern NSString* const kNoRecord;

extern NSString* const kSelectedCity;

extern NSMutableArray<CategoryEntity*> * _arrCategoryC;
extern NSMutableArray<NSString*> *_arrColorsBathces;
/* device check */
extern inline bool is_iPad();

typedef enum : NSUInteger {
    StoryboardFaq,
    StoryboardMain,
    StoryboardEntry,
    StoryboardPop,
    StoryboardRevision,
    StoryboardAttendance,
    StoryboardTutor,
    StoryboardVenue,
    StoryboardSalesDash,
    StoryboardFormPop,
    StoryboardCourseFrom,
    StoryboardCourseDetails,
    StoryboardSearch,
    StoryboardProfile,
    StoryboardLearnerMain,
    StoryboardSettings,
    StoryboardCourseDetail
} StoryboardName;



/* C functions */
extern NSString* getUDID();

extern UIStoryboard* getStoryBoardDeviceBased(StoryboardName type);

extern BOOL validateEmail(NSString *candidate);
extern BOOL validateMobile(NSString *candidate);
extern NSInteger getLength(NSString* mobileNumber);
extern NSString* formatNumber(NSString* mobileNumber);
extern NSString* showformatNumber(NSString* mobileNumber);
extern  NSString* NSStringWithoutSpace(NSString* string);
extern  NSString* NSStringFromCurrentDate(void);
extern  NSString* NSImageNameStringFromCurrentDate(void);
extern  NSString* NSStringWithMergeofString(NSString* first,NSString* last);
extern  NSString* NSStringFullname(NSDictionary* aDict);
extern  void showAletViewWithMessage(NSString* msg);
extern  void showAletViewWithTitleMessage(NSString* title,NSString* msg);
extern  NSString* AgoStringFromTime(NSDate* dateTime);
extern UIImage* takeSnapshotOfView(UIView *view);

extern NSString* convertObjectToJson(NSObject* object);
extern NSString* getTime(id entity);
extern NSString* getDays(id entity);
extern NSString* getBatchColor(NSDate *date);

extern NSDate * nextDayFromDate(NSDate *date);
extern NSMutableArray* getWeekDate(NSDate *week);
extern NSDateFormatter* globalDAYFormatter();
extern NSDateFormatter* global24Formatter();
extern NSDateFormatter* globalDateOnlyFormatter();
extern NSDateFormatter* global12Formatter();
extern NSDateFormatter* _timeFormatter();
extern NSDateFormatter* globalDateFormatter();
extern NSDateFormatter* global2DIGItYearFormatter();
extern NSDateFormatter* mmm24Formatter();
extern NSDateFormatter * f2DIGItYearTimeFormatter();
extern NSDateFormatter* dateSimpleFormatter();
extern NSDateFormatter* frmtDaysTimeFormatter();
extern NSDateFormatter* frmMONTHFormatter();
extern NSDateFormatter* dayNameFormatter();
extern NSDateFormatter* ddMMMyyyyHHmmss();
extern NSDateFormatter* ddMMMHHmmss();
extern NSDateFormatter* ddMMMHHmm();
extern NSDateFormatter * ddMMMyyhhmma();
/* parse related funtion */



typedef enum : NSUInteger {
    SelCategory,
    SelSubCategory,
    
} CatType;
