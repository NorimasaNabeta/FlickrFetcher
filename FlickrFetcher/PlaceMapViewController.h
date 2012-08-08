//
//  PlaceMapViewController.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "RotatableViewController.h"

// @interface PlaceMapViewController : RotatableViewController
@interface PlaceMapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@end
