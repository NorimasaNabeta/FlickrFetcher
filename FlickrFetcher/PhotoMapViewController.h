//
//  PhotoMapViewController.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PhotoMapViewController;
@protocol PhotoMapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(PhotoMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface PhotoMapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@property (nonatomic,weak) id <PhotoMapViewControllerDelegate> delegate;
@end
