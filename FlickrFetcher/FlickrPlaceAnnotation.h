//
//  FlickrPlaceAnnotation.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPlaceAnnotation *)annotationForPhoto:(NSDictionary *)place; // Flickr photo dictionary

@property (nonatomic, strong) NSDictionary *place;

@end
