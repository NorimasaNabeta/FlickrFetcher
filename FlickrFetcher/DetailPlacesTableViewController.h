//
//  DetailPlacesTableViewController.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPlacesTableViewController : UITableViewController
@property (nonatomic,strong) NSDictionary *place;
@property (nonatomic,strong) NSArray *detailPlaces;
@end
