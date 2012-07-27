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
    cell.textLabel.text = [FlickrFetcher retrieveValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
    // cell.textLabel.text = [NSString stringWithFormat:@"%02d: %@", (indexPath.row +1), [FlickrFetcher retrieveValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE]];
    cell.detailTextLabel.text = [FlickrFetcher retrieveValueFromKey:photo nameKey:FLICKR_PHOTO_DESCRIPTION];
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
    self.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    NSLog(@"3-URL: %@", self.photoURL);
    
}


-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    // NSString *photographer = [self photographerForSection:indexPath.section];
    // NSArray *photosByPhotographer = [self.photosByPhotographer objectForKey:photographer];
    NSDictionary *photo = [self.recentPlaces objectAtIndex:indexPath.row];
    self.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    NSLog(@"4-URL: %@", self.photoURL);
    
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
        [segue.destinationViewController setUrlPhoto:self.photoURL ];
    }
}


@end
