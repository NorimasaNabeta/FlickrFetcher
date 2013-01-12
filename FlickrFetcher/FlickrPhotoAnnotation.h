//
//  FlickrPhotoAnnotation.h
//  Shutterbug
//
//  Created by Norimasa Nabeta on 2012/07/30.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPhotoAnnotation : NSObject <MKAnnotation>

+ (FlickrPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo; // Flickr photo dictionary

@property (nonatomic, strong) NSDictionary *photo;

@end
