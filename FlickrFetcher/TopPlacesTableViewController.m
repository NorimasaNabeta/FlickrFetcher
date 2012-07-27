//
//  TopPlacesTableViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesTableViewController ()
@property (nonatomic,strong) NSDictionary* place;
@end

@implementation TopPlacesTableViewController
@synthesize topPlaces=_topPlaces;

- (NSArray*) topPlaces
{
    if(! _topPlaces){
        _topPlaces = [[NSArray alloc] init];
    }
    return _topPlaces;
}
-(void) setTopPlaces:(NSArray *)topPlaces
{
    if(_topPlaces != topPlaces){
        _topPlaces = topPlaces;
        if (self.tableView.window) [self.tableView reloadData];
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

- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *topPlaces = [FlickrFetcher topPlaces];
        NSLog(@"Download cont: %d", [topPlaces count]);
        // topPacces must be display in alphabetical order.
        // Reuiqred Task #2
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedTopPlaces = [topPlaces sortedArrayUsingDescriptors:sortDescriptors];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.topPlaces = sortedTopPlaces;
        });
    });
    dispatch_release(downloadQueue);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *place = [[self.topPlaces objectAtIndex:indexPath.row] valueForKeyPath:@"_content"];
    // NSLog(@"%@", place);
    NSArray *placeDescription = [place componentsSeparatedByString:@","];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [placeDescription objectAtIndex:0]];
    cell.detailTextLabel.text = place;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    self.place = [self.topPlaces objectAtIndex:indexPath.row];
    // [self performSegueWithIdentifier:@"Detail Places View" sender:self];

}


-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    // NSString *photographer = [self photographerForSection:indexPath.section];
    // NSArray *photosByPhotographer = [self.photosByPhotographer objectForKey:photographer];
    self.place = [self.topPlaces objectAtIndex:indexPath.row];
    // self.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    /// NSLog(@"URL: %@", self.photoURL);
#ifdef __UNIVERSAL_IMPLEMENTAION__
    if ([self splitViewHappinessViewController]) {                      // if in split view
        [self splitViewHappinessViewController].setPlace = self.place;  // just set happiness in detail
    } else {
        [self performSegueWithIdentifier:@"Detail Places View" sender:self];
    }
#else // #ifdef __UNIVERSAL_IMPLEMENTAION__
    [self performSegueWithIdentifier:@"Detail Places View" sender:self];
#endif // #ifdef __UNIVERSAL_IMPLEMENTAION__
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Detail Places View"]) {
        [segue.destinationViewController setPlace:self.place ];
    }
}

@end
