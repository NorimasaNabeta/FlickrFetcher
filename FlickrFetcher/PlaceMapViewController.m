//
//  PlaceMapViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "PlaceMapViewController.h"
#import "FlickrPlaceAnnotation.h"

@interface PlaceMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation PlaceMapViewController
@synthesize mapView = _mapView;
@synthesize annotations=_annotations;

// ExtraCredit2
//
- (IBAction)segMapType:(UISegmentedControl *)sender {
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
    if ([segue.identifier isEqualToString:@"MapPhoto List View"]) {
        FlickrPlaceAnnotation *anno = [self.mapView.selectedAnnotations objectAtIndex:0];
        [segue.destinationViewController setPlace:anno.place];
    }
}

#pragma mark - MKMapViewDelegate
-(void) mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"CalloutTapped:");
    [self performSegueWithIdentifier:@"MapPhoto List View" sender:self];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString* PlaceAnnotationIdentifier = @"PlaceAnnotationIdentifier";
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:PlaceAnnotationIdentifier ];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PlaceAnnotationIdentifier ];
        aView.canShowCallout = YES;
        // aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }    
    aView.annotation = annotation;
    // [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

-(void) mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)views
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.1;
    span.longitudeDelta=0.1;

    // TODO: region should include all of the annotations.
    FlickrPlaceAnnotation *anno=[views objectAtIndex:0];
    region.span=span;
    region.center=anno.coordinate;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
}

- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)aView
{
}

@end
