//
//  FlickrPlaceAnnotation.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPlaceAnnotation

@synthesize place=_place;

// Flickr photo dictionary
+ (FlickrPlaceAnnotation *)annotationForPhoto:(NSDictionary *)place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.place = place;
    // NSLog(@"ANN:%@ %@ %@", [FlickrFetcher namePlace:place], [place objectForKey:FLICKR_LATITUDE], [place objectForKey:FLICKR_LONGITUDE]);
    return annotation;
}

#pragma mark - MKAnnotation
- (NSString *)title
{
    // return [self.place objectForKey:FLICKR_PHOTO_TITLE];
    return [FlickrFetcher namePlace:self.place];
}

- (NSString *)subtitle
{
    // return [self.place valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    return [self.place valueForKeyPath:FLICKR_PLACE_NAME];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end
