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

@interface RecentsTableViewController ()

@end

@implementation RecentsTableViewController

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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
//    self.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
//    self.photoTitle = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
//    NSLog(@"3-URL: %@ %@", self.photoTitle, self.photoURL);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
//    self.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
//    self.photoTitle = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
//    NSLog(@"4-URL: %@ %@", self.photoTitle, self.photoURL);
#ifdef __UNIVERSAL_IMPLEMENTAION__
    if ([self splitViewHappinessViewController]) {                      // if in split view
        [self splitViewHappinessViewController].urlPhoto = self.photoURL;  // just set happiness in detail
    } else {
        [self performSegueWithIdentifier:@"Recents Photo View" sender:self];
    }
#else // #ifdef __UNIVERSAL_IMPLEMENTAION__
    [self performSegueWithIdentifier:@"Recents Photo View" sender:self];
#endif // #ifdef __UNIVERSAL_IMPLEMENTAION__
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Recents Photo View"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"indexPath %@", indexPath);
        NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
        [segue.destinationViewController setPhoto:photo ];
    }
}


@end
