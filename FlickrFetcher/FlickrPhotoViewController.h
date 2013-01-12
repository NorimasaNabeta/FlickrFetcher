//
//  FlickrPhotoViewController.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface FlickrPhotoViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (nonatomic,strong) NSDictionary *photo;
@end
