//
//  ImageZoomViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 16/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ImageZoomViewController.h"
#import "HobbyCourses-Swift.h"

#define VIEW_FOR_ZOOM_TAG (1)

@interface ImageZoomViewController ()
{
    IBOutlet UICollectionView *collectionV;
    IBOutlet UIView *ContainerView;
    UIScrollView *mainScrollView;
}
@end

@implementation ImageZoomViewController
@synthesize img,path;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    zoomScrollView.contentSize = imageView.image.size;
    zoomScrollView.delegate = self;
    zoomScrollView.minimumZoomScale = 1.0;
    zoomScrollView.maximumZoomScale = 4.0;
    lblCourseTitle.text = self.course.title;
    if (self.course.author_image) {
        [imgProfile sd_setImageWithURL:[NSURL URLWithString:self.course.author_image]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    lblTittle.text = self.course.author;
    lblTopDate.text = self.course.post_date;
    if (![self checkStringValue:self.course.comment_count]) {
        lblComments.text = [NSString stringWithFormat:@"%@ comments",self.course.comment_count];
    }else{
        lblComments.text = @"";
    }
    
    //Scrollview for images
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ContainerView.frame.size.width, ContainerView.frame.size.height)];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    
    CGRect innerScrollFrame = mainScrollView.bounds;
    
    for (NSInteger i = 0; i < _arrData.count; i++) {
        UIImageView *imageForZooming = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ContainerView.frame.size.width, ContainerView.frame.size.height)];
        if ([_arrData[i] isKindOfClass:[NSString class]]) {
            [imageForZooming sd_setImageWithURL:[NSURL URLWithString:_arrData[i]]
                    placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }else if([_arrData[i] isKindOfClass:[UIImage class]]) {
            imageForZooming.image = _arrData[i];
        }
        
        imageForZooming.tag = VIEW_FOR_ZOOM_TAG;
        imageForZooming.contentMode = UIViewContentModeScaleAspectFit;
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        pageScrollView.minimumZoomScale = 1.0f;
        pageScrollView.maximumZoomScale = 2.0f;
        pageScrollView.zoomScale = 3.0f;
        pageScrollView.contentSize = imageForZooming.bounds.size;
        pageScrollView.delegate = self;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        [pageScrollView addSubview:imageForZooming];
        pageScrollView.tag = i;
        [mainScrollView addSubview:pageScrollView];
        
        if (i < _arrData.count- 1) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
        UITapGestureRecognizer *dblRecognizer;
        dblRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(handleDoubleTapFrom:)];
        [dblRecognizer setNumberOfTapsRequired:2];
        
        [pageScrollView addGestureRecognizer:dblRecognizer];
        
        UITapGestureRecognizer *recognizer;
        recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(handleTapFrom:)];
        [recognizer requireGestureRecognizerToFail:dblRecognizer];
        [pageScrollView addGestureRecognizer:recognizer];
        
    }
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x +
                                            innerScrollFrame.size.width, mainScrollView.bounds.size.height);
    
    [ContainerView addSubview:mainScrollView];
    [self scrollViewDidEndDecelerating:mainScrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Image Gallery Screen"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(zoomScrollView.bounds),
                                      CGRectGetMidY(zoomScrollView.bounds));
    [self view:imageView setCenter:centerPoint];
    [collectionV reloadData];
}

- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint
{
    CGRect vf = view.frame;
    CGPoint co = zoomScrollView.contentOffset;
    
    CGFloat x = centerPoint.x - vf.size.width / 2.0;
    CGFloat y = centerPoint.y - vf.size.height / 2.0;
    
    if(x < 0)
    {
        co.x = -x;
        vf.origin.x = 0.0;
    }
    else
    {
        vf.origin.x = x;
    }
    if(y < 0)
    {
        co.y = -y;
        vf.origin.y = 0.0;
    }
    else
    {
        vf.origin.y = y;
    }
    
    view.frame = vf;
    zoomScrollView.contentOffset = co;
}

#pragma mark UIScrollViewDelegate
-(CGSize) pageSize {
    UPCarouselFlowLayout *layout = (UPCarouselFlowLayout*)collectionV.collectionViewLayout;
    CGSize pageSize = layout.itemSize;
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        pageSize.width += layout.minimumLineSpacing;
    } else {
        pageSize.height += layout.minimumLineSpacing;
    }
    return pageSize;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    if (is_iPad()) {
        UPCarouselFlowLayout *layout = collectionV.collectionViewLayout;
        CGFloat pageSide = (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? [self pageSize].width : [self pageSize].height;
        
        CGFloat offset = (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y;
        NSInteger currentPage = (floor((offset - pageSide / 2) / pageSide) + 1);
        
        //int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        lblCurrentImage.text = [NSString stringWithFormat:@"Image: %d/%lu",currentPage + 1,(unsigned long)_arrData.count];
    }else{
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        lblCurrentImage.text = [NSString stringWithFormat:@"Image: %d/%lu",page + 1,(unsigned long)_arrData.count];
    }
    
    
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews[0];//imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    zoomView.frame = zvf;
}


-(IBAction) handleDoubleTapFrom:(UITapGestureRecognizer*) tapRecognizer{
    UIScrollView * scroll =  tapRecognizer.view;//mainScrollView.subviews[VIEW_FOR_ZOOM_TAG];
    if(scroll.zoomScale > scroll.minimumZoomScale) {
        [scroll setZoomScale:scroll.minimumZoomScale animated:YES];
    } else{
        [scroll setZoomScale:scroll.maximumZoomScale animated:YES];
    }
}
-(void) handleTapFrom:(UITapGestureRecognizer*) singleRecognizer {
    NSLog(@"single tap");
    //    UIScrollView * scroll =  singleRecognizer.view;//mainScrollView.subviews[VIEW_FOR_ZOOM_TAG];
    //    [scroll setZoomScale:zoomScrollView.minimumZoomScale animated:YES];
    //    viewTop.hidden = !viewTop.hidden;
    //    viewBottom.hidden = !viewBottom.hidden;
    //    cvImages.hidden = !cvImages.hidden;
}
#pragma mark -

-(IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnOpenCommentView:(UIButton*)sender{
    if ([self.course.comment_count intValue] > 0) {
        [self performSegueWithIdentifier:@"segueReviews" sender:self];
    }else{
        showAletViewWithMessage(@"No comments");
    }
}


-(IBAction)btnShare:(UIButton*)sender {
    
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrData.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:111];
    if ([_arrData[indexPath.row] isKindOfClass:[NSString class]]) {
        [imgV sd_setImageWithURL:[NSURL URLWithString:_arrData[indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }else if([_arrData[indexPath.row] isKindOfClass:[UIImage class]]) {
        imgV.image = _arrData[indexPath.row];
    }
    return cell;
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueReviews"]) {
        if (is_iPad()) {
            CommentListVC *vc = segue.destinationViewController;
            vc.nid = self.course.nid;
            vc.courseTittle = self.course.title;
            vc.isCourseAllReview = true;

        }else{
            CourseReviewVC *vc =segue.destinationViewController;
            vc.nid = self.course.nid;
        }
    }
}
@end
