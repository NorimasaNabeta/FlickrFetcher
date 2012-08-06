//
//  PlaceMapViewController.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PlaceMapViewController;
@protocol PlaceMapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(PlaceMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface PlaceMapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@property (nonatomic,weak) id <PlaceMapViewControllerDelegate> delegate;
@end
