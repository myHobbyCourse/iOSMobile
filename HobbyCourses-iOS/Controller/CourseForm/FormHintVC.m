//
//  FormHintVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FormHintVC.h"
#import "HobbyCourses-Swift.h"

@interface FormHintVC (){
    NSMutableArray *arrText,*arrTitle;
    IBOutlet UILabel *lblScreenTitle;

    IBOutlet UILabel *lbl1;
    IBOutlet UILabel *lbl2;
}

@end

@implementation FormHintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 500;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    arrText = [NSMutableArray new];
    arrTitle = [NSMutableArray new];

    [arrText addObject:@"A great title is unique and descriptive. It should highlight main strengths of your course in 80 Characters or less.\n\nHow does it work?\nLet’s take an example.\nEnglish Lessons for Beginners – too broad \nEnglish Lessons for Beginners – better.\nSpoken English for Spanish Speakers – best\nOR\nDance for Beginners – umn, dull dry and unfocused \nLearn Dance in 2 weeks for Beginners – perfect!\n\nCreating course titles that are to the point and powerful, give learners the chance to pre-determine if your course will offer them the skills and knowledge they need to achieve their goals."];
    [arrTitle addObject:@"Category and Title"];
    
    [arrText addObject:@"Your course summary explains what your course is about to potential students. It is largely responsible for convincing them that your course will change their lives! Please keep introduction concise. To less than 80-100 words\n\nLet’s take an example.This course contains over 10 sessions. It's designed for anyone, regardless of experience level, who wishes to improve their memory and learn a new language at the same time.In this course, you will learn the Magnetic Memory Method, and you'll understand what a Memory Palace is and how to build one."];
    [arrTitle addObject:@"Course introduction or summary"];

    [arrText addObject:@"Most businesses choose a location that provides exposure to customers. \nAdditionally, there are less obvious factors and needs to consider, for example:\n - Brand Image – Is the location consistent with image you want to maintain?\n-Competition – Are the businesses around you complementary or competing?\n-Local Market – Does the area have potential learners? What will their commute be like?\n-Safety – Consider the crime rate. Will learners feel safe alone in the building or walking to their vehicles?\n-Zoning Regulations – These determine whether you can conduct your type of business in certain properties or locations."];
    [arrTitle addObject:@"Course Address/Location"];

    [arrText addObject:@"Additional details will provide learners more information about classes you offer. Potential learners would like to know your terms for important considerations such as money back guarantee and free trial sessions. Write your terms as clear as possible to avoid future complications.\n\nMONEY BACK GUARANTEE Are you happy to refund money to students in case they were not fully satisfied with your training? Money back Guarantee is only valid if raised on first session of the course . Note vendors have to refund students directly within 30 days of raising a request"];
    [arrTitle addObject:@"Additional Details"];

    [arrText addObject:@"What else would you want the potential learner to know about your class? Add more details that can encourage the learner that the class fits his/her interests.\n\nFor example, if you are offering Intermediate Spanish Classes for English Speakers, you can write the course description and prerequisite as follows:\n     The class meets twice a week, an ideal schedule for busy working people who are interested in acquiring a foreign language. We help you develop your reading, writing, and speaking skills in Spanish. Also, we use the best materials that will help speed up your linguistic abilities by assisting in retaining more Spanish words and practicing proper pronunciation.\n Make sure you have passed beginner Spanish before taking this course as the basics will no longer be reviewed to avoid wasting time."];
    [arrTitle addObject:@"Course Detailed Description"];

    [arrText addObject:@"Learners will get excited to try out your classes if you post photos of your classes.\nAdd any images that will surely get the learners interested in your class.\n- What to post?\n- Photos of facilities\n- Photos of you while delivering the class\n- Photos of what your class does\n- Photos that will get attention"];
    [arrTitle addObject:@"Course Images"];

    [arrText addObject:@"Since interested learners come at different times, let them know when is the soonest time they can start your class by specifying your batch schedule. \nSet your preferred details for different batches and learners can choose which one suits them.\n\nFor example:\nBatch 1 will be from October-November, Mondays and Fridays at 10am-12pm. Number of sessions is 5 with 10 slots available.\n\nBatch 2 will be from October-November, Tuesdays and Saturdays at 10am-12pm. Number of sessions is 5 with 20 slots available.\nAdd as much batches as you would like."];
    [arrTitle addObject:@"Class Timings"];
    [arrTitle addObject:@"Course Price"];

    [arrText addObject:@"Show off what else you can offer to potential learners. Make use of other medium to promote your services and amenities.\n\nCERTIFICATIONS Add your own Endorsement as a robust quality check on training you are providing. It ensures a minimum standard of training within footprint that is regulated. Employers and individuals look for such credential logo and have confidence in knowing that the training they book onto is safe, effective and regulated\n\nNote : Classes can have more than one Tutor or different tutors to conduct sessions"];
    [arrTitle addObject:@"Optional Details"];

    [arrText addObject:@"You are responsible for choosing the price and availability of your Course listing.\nPlease pay attention to your listing's features, location, amenities, booking history, availability and seasonal supply and demand in your area from other suppliers while rafting your price strategy.\n We do show you competitor prices from around areas to give you some insights."];
    [arrTitle addObject:@"Youtube URLs"];
    [arrTitle addObject:@"TUTOR CERTIFICATIONS"];
    [arrTitle addObject:@"Verify Your Mobile"];
    [arrTitle addObject:@"Course Terms"];

    if (is_iPad()) {
        NSString *str = arrText[self.selectedText];
        //NSAttributedString *attrStr  = [[NSAttributedString alloc] attributedText:@[@"A great title ",str] attributes:@[@{ NSForegroundColorAttributeName : __THEME_GREEN},@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}]];
        lbl1.text = str;
    }else{
        NSString *str = arrTitle[self.selectedText];
        lblScreenTitle.text = str;
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Hint Screen"];
    [self preferredStatusBarStyle];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)parentDismiss:(UIButton*)sender{
    [self dismissViewControllerAnimated:true completion:nil];

}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *idf = [NSString stringWithFormat:@"Cell%ld",(long)self.selectedText + 1];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idf forIndexPath:indexPath];
//    UILabel *lbl = [cell viewWithTag:11];
//    lbl.text = arrText[self.selectedText];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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
