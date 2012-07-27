//
//  DetailPlacesTableViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "DetailPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoViewController.h"

@interface DetailPlacesTableViewController ()
@end

@implementation DetailPlacesTableViewController
@synthesize detailPlaces=_detailPlaces;

- (void)setDetailPlaces:(NSArray *)detailPlaces
{
    if (_detailPlaces != detailPlaces) {
        _detailPlaces = detailPlaces;
        if (self.tableView.window) [self.tableView reloadData];
    }
}
- (NSArray*) detailPlaces
{
    if (! _detailPlaces){
        _detailPlaces= [NSMutableArray array];
    }
    return _detailPlaces;
}

- (void) resetPlaces:(NSDictionary *)place {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader2", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *detailPlaces = [FlickrFetcher photosInPlace:place maxResults:50];
        NSLog(@"[DETAIL] Download cont: %d", [detailPlaces count]);
        // detailPacces must be also display in alphabetical order.
        // Reuiqred Task #2
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedDetailPlaces = [detailPlaces sortedArrayUsingDescriptors:sortDescriptors];

        dispatch_async(dispatch_get_main_queue(), ^{
            // self.navigationItem.rightBarButtonItem = sender;
            self.detailPlaces = sortedDetailPlaces;
            self.navigationItem.rightBarButtonItem=nil;
        });
    });
    dispatch_release(downloadQueue);
}

- (void) setPlace:(NSDictionary *)place
{
    if(_place != place){
        _place = place;
        [self resetPlaces:place];
        [self.tableView reloadData];

    }
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.detailPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Detail Places Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
    cell.textLabel.text=[FlickrFetcher retrieveValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text=[FlickrFetcher retrieveValueFromKey:photo nameKey:FLICKR_PHOTO_DESCRIPTION];
 
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
    NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
    self.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    NSLog(@"1-URL: %@", self.photoURL);
    //[self performSegueWithIdentifier:@"Flickr Photo View" sender:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!favorites){
        favorites = [NSMutableArray array];
    }
    else {
        // RequiedTask #2
        NSString *newid = [FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_ID];
        NSMutableArray *culling = [[NSMutableArray alloc] init];
        for (int idx=0; ((idx<19) && (idx < [favorites count])); idx++) {
            NSDictionary *entry = [favorites objectAtIndex:idx];
            NSString *id = [FlickrFetcher stringValueFromKey:entry nameKey:FLICKR_PHOTO_ID];
            if (! [newid isEqualToString:id]) {
                [culling addObject:entry];
            }
        }
        favorites = culling;        
    }
    [favorites insertObject:photo atIndex:0];
    
    [defaults setObject:[favorites copy] forKey:FAVORITES_KEY];
    [defaults synchronize];
}


-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    // NSString *photographer = [self photographerForSection:indexPath.section];
    // NSArray *photosByPhotographer = [self.photosByPhotographer objectForKey:photographer];
    NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
    self.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    NSLog(@"2-URL: %@", self.photoURL);
    
#ifdef __UNIVERSAL_IMPLEMENTAION__
    if ([self splitViewHappinessViewController]) {                      // if in split view
        [self splitViewHappinessViewController].urlPhoto = self.photoURL;  // just set happiness in detail
    } else {
        [self performSegueWithIdentifier:@"Flickr Photo View" sender:self];
    }
#else // #ifdef __UNIVERSAL_IMPLEMENTAION__
    [self performSegueWithIdentifier:@"Flickr Photo View" sender:self];
#endif // #ifdef __UNIVERSAL_IMPLEMENTAION__
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Flickr Photo View"]) {
        [segue.destinationViewController setUrlPhoto:self.photoURL ];
    }
}



@end
