//
//  FlickrPhotoViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "FlickrPhotoViewController.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoViewController ()  <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FlickrPhotoViewController
@synthesize scrollView;
@synthesize imageView;

// http://piazza.com/class#summer2012/codingtogether/1519
// うまくいかない→setup the struts and strings of the scrollView -->OK
-(void) resetScrollView
{
//    self.scrollView.contentSize = self.imageView.image.size;
//    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    CGFloat horZoomScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    CGFloat verZoomScale = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    [self.scrollView setZoomScale:MAX(horZoomScale, verZoomScale)];
    [self.scrollView setNeedsDisplay];
}

-(void) resetView
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    // http://stackoverflow.com/questions/11587513/how-to-center-uiactivityindicator
    //spinner.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    // http://stackoverflow.com/questions/8585715/could-not-resize-the-activity-indicator-in-ios-5-0
    //spinner.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *urlPhoto = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        self.title = [FlickrFetcher stringValueFromKey:self.photo nameKey:FLICKR_PHOTO_TITLE];
        NSData *photo = [NSData dataWithContentsOfURL:urlPhoto];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollView.delegate=self;
            self.scrollView.zoomScale=1.0;
            self.scrollView.minimumZoomScale=0.2;
            self.scrollView.maximumZoomScale=5.0;
            self.imageView.image = [UIImage imageWithData:photo];
            self.imageView.frame=CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
            self.scrollView.contentSize=self.imageView.image.size;
            [self resetScrollView];
            self.navigationItem.rightBarButtonItem = nil;
        });
    });
    dispatch_release(downloadQueue);
    [self.view setNeedsDisplay];
}

- (void) setPhoto:(NSDictionary *)photo
{
    if(_photo != photo){
        _photo = photo;
        [self resetView];
    }
}

//  Psychologist/RotatableViewController.m
-(void) awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"nib %g %g", self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self resetScrollView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self resetView];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


#pragma mark - UIScrollViewDelegate
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                      withView:(UIView *)view
                       atScale:(float)scale
{
    NSLog(@"scale=%g", scale);
}



@end
