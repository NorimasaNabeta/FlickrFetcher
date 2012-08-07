//
//  FlickrPhotoAnnotation.m
//  Shutterbug
//
//  Created by Norimasa Nabeta on 2012/07/30.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPhotoAnnotation
@synthesize photo=_photo;

// Flickr photo dictionary
+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    FlickrPhotoAnnotation *annotation = [[FlickrPhotoAnnotation alloc] init];
    annotation.photo = photo;
    // NSLog(@"ANN:%@", [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE]);
    return annotation;
}

#pragma mark - MKAnnotation
- (NSString *)title
{
    //return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
    return [FlickrFetcher stringValueFromKey:self.photo nameKey:FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitle
{
    //return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    return [FlickrFetcher stringValueFromKey:self.photo nameKey:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}


@end
