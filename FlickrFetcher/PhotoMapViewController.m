//
//  PhotoMapViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "PhotoMapViewController.h"
#import <MapKit/MapKit.h>
//#import "FlickrFetcher.h"
#import "FlickrPhotoAnnotation.h"

@interface PhotoMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation PhotoMapViewController
@synthesize annotations=_annotations;
@synthesize mapView=_mapView;

- (IBAction)segmentMapType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 1:
            self.mapView.mapType=MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType=MKMapTypeHybrid;
            break;
        default:
            self.mapView.mapType=MKMapTypeStandard;
            break;
    }
}

-(void) updateMapView
{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    if (self.annotations) {
        [self.mapView addAnnotations:self.annotations];
    }
}
-(void)setMapView:(MKMapView *)mapView
{
    _mapView=mapView;
    [self updateMapView];
}
-(void) setAnnotations:(NSArray *)annotations
{
    _annotations=annotations;
    [self updateMapView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.mapView.delegate=self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Map Photo View"]) {
        FlickrPhotoAnnotation *anno = [self.mapView.selectedAnnotations objectAtIndex:0];
        [segue.destinationViewController setPhoto:anno.photo];
    }
}

#pragma mark - MKMapViewDelegate

-(void) mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"CalloutTapped:");
    [self performSegueWithIdentifier:@"Map Photo View" sender:self];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString* PhotoAnnotationIdentifier = @"PhotoAnnotationIdentifier";
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:PhotoAnnotationIdentifier];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PhotoAnnotationIdentifier];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        // Apple "MapCallouts" sample >>
        // add a detail disclosure button to the callout which will open a new view controller page
        //
        // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
        //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
        //
        // UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        // [rightButton addTarget:self
        //                 action:@selector(showDetails:)
        //       forControlEvents:UIControlEventTouchUpInside];
        // aView.rightCalloutAccessoryView = rightButton;
        // Apple "MapCallouts" sample <<

    }
    aView.annotation = annotation;
    
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

// @1640 (Eytan Bernet's code)
#define __EYTANS_CODE__ 1
-(void) mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)views
{
#ifdef __EYTANS_CODE__
    if (self.annotations && self.mapView.window) {
        // Set min and max to the 1st object in the annotations
        __block CLLocationCoordinate2D min = [[self.annotations objectAtIndex:0] coordinate];
        __block CLLocationCoordinate2D max = min;
        
        [self.annotations enumerateObjectsUsingBlock:^(id element, NSUInteger idx, BOOL *stop){
            // We want to throw an error if it is not a dictionary
            assert([element isKindOfClass:[FlickrPhotoAnnotation class]]);
            FlickrPhotoAnnotation *location = element;
            
            // Get the coordinates name for each location
            CLLocationCoordinate2D currentCcoordinate = location.coordinate;
            
            min.latitude = MIN(min.latitude, currentCcoordinate.latitude);
            min.longitude = MIN(min.longitude, currentCcoordinate.longitude);
            max.latitude = MAX(max.latitude, currentCcoordinate.latitude);
            max.longitude = MAX(max.longitude, currentCcoordinate.longitude);
        }];
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((max.latitude + min.latitude)/2.0, (max.longitude + min.longitude)/2.0);
        MKCoordinateSpan span = MKCoordinateSpanMake(max.latitude - min.latitude, max.longitude - min.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    }
#else // #ifdef __EYTANS_CODE__
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;
    
    // TODO: region should include all of the annotations.
    FlickrPhotoAnnotation *anno=[views objectAtIndex:0];
    region.span=span;
    region.center=anno.coordinate;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
#endif // #ifdef __EYTANS_CODE__
}


- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)aView
{
#define __ANNOTAION_IMAGE_WITH_BLOCK__ 0
#ifdef __ANNOTAION_IMAGE_WITH_BLOCK__
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.bounds = aView.leftCalloutAccessoryView.bounds;
    spinner.hidesWhenStopped = YES;
    spinner.alpha = 0.7f;

    aView.leftCalloutAccessoryView = spinner;
    //[UIImage imageWithData:data]
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader3", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
            UIImageView *thumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [thumb setImage:image];
            aView.leftCalloutAccessoryView = thumb;
            if (thumb != nil) { NSLog(@"IMG OK"); }
        });
    });
    dispatch_release(downloadQueue);
#else  // #ifdef __ANNOTAION_IMAGE_WITH_BLOCK__
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
#endif // #ifdef __ANNOTAION_IMAGE_WITH_BLOCK__
}

@end
