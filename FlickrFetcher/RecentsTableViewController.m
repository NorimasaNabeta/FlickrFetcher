//
//  RecentsTableViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoViewController.h"
#import "RecentsStore.h"

@interface RecentsTableViewController ()

@end

@implementation RecentsTableViewController
@synthesize recentPlaces=_recentPlaces;

/*
//
// recent-list が更新されてもバッジの値に反映されないのはどうしたものか
// →バッジはrequiredTask じゃないからいいけど.
- (NSArray*) recentPlaces
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recents = [defaults arrayForKey:FAVORITES_KEY];
    if (! recents){
        recents = [NSMutableArray array];
    }
    UITabBarItem *barItem = [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem];
    barItem.badgeValue = [NSString stringWithFormat:@"%d", [recents count]];

    return recents;
}
*/
- (NSArray*) recentPlaces
{
    if(! _recentPlaces){
        _recentPlaces = [RecentsStore getList];
    }
    return _recentPlaces;
}
- (void) setRecentPlaces:(NSArray *)recentPlaces
{
    _recentPlaces = recentPlaces;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}
- (void) viewWillAppear:(BOOL)animated
{
    [self setRecentPlaces:[RecentsStore getList]];
//    UITabBarItem *barItem = [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem];
//    barItem.badgeValue = [NSString stringWithFormat:@"%d", [self.recentPlaces count]];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.recentPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recents Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id photoVC = [self.splitViewController.viewControllers lastObject];
    if ([photoVC isKindOfClass:[FlickrPhotoViewController class]]) {
        [photoVC setPhoto:[self.recentPlaces objectAtIndex:indexPath.row]];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Recents Photo View"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // NSLog(@"indexPath %@", indexPath);
        [segue.destinationViewController setPhoto:[self.recentPlaces objectAtIndex:indexPath.row]];
    }
}


@end
