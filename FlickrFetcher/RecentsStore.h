//
//  RecentsStore.h
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/08.
//  Copyright (c) 2012 Norimasa Nabeta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentsStore : NSObject

+ (NSArray*) getList;
+ (void) pushList:(NSDictionary *) photo;

@end
