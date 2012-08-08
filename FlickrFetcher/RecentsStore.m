//
//  RecentsStore.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/08/08.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "RecentsStore.h"
#import "FlickrFetcher.h"

@implementation RecentsStore

+ (NSArray*) getList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recents = [defaults arrayForKey:FAVORITES_KEY];
    if (! recents){
        recents = [NSMutableArray array];
    }
    
    return recents;
}


+ (void) pushList:(NSDictionary *) photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!favorites){
        favorites = [NSMutableArray array];
    }
    else {
        // RequiedTask #2
        NSString *newid = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_ID];
        NSMutableArray *culling = [[NSMutableArray alloc] init];
        int cnt=0;
        for (int idx=0; ((cnt<20) && (idx < [favorites count])); idx++) {
            NSDictionary *entry = [favorites objectAtIndex:idx];
            NSString *id = [FlickrFetcher stringValueFromKey:entry nameKey:FLICKR_PHOTO_ID];
            if (! [newid isEqualToString:id]) {
                [culling addObject:entry];
                cnt++;
            }
        }
        favorites = culling;
    }
    [favorites insertObject:photo atIndex:0];
    
    [defaults setObject:[favorites copy] forKey:FAVORITES_KEY];
    [defaults synchronize];
}

@end
