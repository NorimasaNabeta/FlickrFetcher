//
//  TopPlacesTableViewController.m
//  FlickrFetcher
//
//  Created by Norimasa Nabeta on 2012/07/27.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "DetailPlacesTableViewController.h"
#import "PlaceMapViewController.h"
#import "FlickrPlaceAnnotation.h"
#import "FlickrPhotoViewController.h"

@interface TopPlacesTableViewController ()
@property (nonatomic,strong) NSMutableDictionary *nations;
@end

@implementation TopPlacesTableViewController
@synthesize topPlaces=_topPlaces;
@synthesize nations=_nations;

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
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *topPlaces = [FlickrFetcher topPlaces];
        NSLog(@"Download cont: %d", [topPlaces count]);
        // topPacces must be display in alphabetical order.
        // Reuiqred Task #2
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_NAME ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedTopPlaces = [topPlaces sortedArrayUsingDescriptors:sortDescriptors];

        NSMutableDictionary *nationDict = [[NSMutableDictionary alloc] init];
        for (NSDictionary* place in topPlaces) {
            NSString* nationTag = [FlickrFetcher nationPlace:place];
            NSMutableArray *tmp = [nationDict objectForKey:nationTag];
            if (tmp == nil) {
                tmp = [[NSMutableArray alloc] initWithObjects:place, nil];
            } else {
                [tmp addObject:place];
            }
            [nationDict setObject:tmp forKey:nationTag];
        }
        for (NSString *section in [nationDict allKeys]){
            NSArray *unsortedArray = [nationDict objectForKey:section];
            NSArray *sortedArray = [unsortedArray sortedArrayUsingDescriptors:sortDescriptors];
            [nationDict setObject:sortedArray forKey:section];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.navigationItem.rightBarButtonItem = sender;
            self.navigationItem.leftBarButtonItem = sender;
            self.topPlaces = sortedTopPlaces;
            self.nations = nationDict;
            [self.tableView reloadData];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *recents = [defaults arrayForKey:FAVORITES_KEY];
    if (! recents){
        recents = [NSMutableArray array];
    }
    UITabBarItem *barItem = [[self.tabBarController.viewControllers objectAtIndex:1] tabBarItem];
    barItem.badgeValue = [NSString stringWithFormat:@"%d", [recents count]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // NSLog(@"SECTION: %d",[[self.nations allKeys] count] );
    return [[self.nations allKeys] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sortedArray = [[self.nations allKeys] sortedArrayUsingComparator:^(NSString* a, NSString* b) {
        return [a compare:b options:NSNumericSearch];
    }];
    NSString *title = [sortedArray objectAtIndex:section];
    return title;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSArray *sortedArray = [[self.nations allKeys] sortedArrayUsingComparator:^(NSString* a, NSString* b) {
        return [a compare:b options:NSNumericSearch];
    }];    
    NSString *title = [sortedArray objectAtIndex:section];
    NSArray *places = [self.nations objectForKey:title];
    return [places count];
    
    //return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray *sortedArray = [[self.nations allKeys] sortedArrayUsingComparator:^(NSString* a, NSString* b) {
       return [a compare:b options:NSNumericSearch];
    }];
    NSString *title = [sortedArray objectAtIndex:indexPath.section];
    NSArray *places = [self.nations objectForKey:title];
    NSDictionary *place = [places objectAtIndex:indexPath.row];
    cell.textLabel.text = [FlickrFetcher namePlace:place];
    cell.detailTextLabel.text = [place valueForKeyPath:FLICKR_PLACE_NAME];

    // NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
    // cell.textLabel.text = [FlickrFetcher namePlace:place];
    // cell.detailTextLabel.text = [place valueForKeyPath:FLICKR_PLACE_NAME];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id placeVC = [self.splitViewController.viewControllers lastObject];
    if ([placeVC isKindOfClass:[FlickrPhotoViewController class]]) {
        [self performSegueWithIdentifier:@"Photo List View" sender:self];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// "Detail Disclosure"
-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Photo List View"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"Detail:indexPath %@", indexPath);

        
        NSArray *sortedArray = [[self.nations allKeys] sortedArrayUsingComparator:^(NSString* a, NSString* b) {
            return [a compare:b options:NSNumericSearch];
        }];
        NSString *title = [sortedArray objectAtIndex:indexPath.section];
        NSArray *places = [self.nations objectForKey:title];
        NSDictionary *place = [places objectAtIndex:indexPath.row];
        
        //NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
        
        [segue.destinationViewController setPlace:place ];
    }
    else if ([segue.identifier isEqualToString:@"Place Map View"]) {
        id detail = segue.destinationViewController;
        if ([detail isKindOfClass:[PlaceMapViewController class]]) {
            PlaceMapViewController *mapVC = (PlaceMapViewController *)detail;
            mapVC.annotations = [self mapAnnotations];
            // mapVC.title = self.title;
        }
    }
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaces count]];
    for (NSDictionary *place in self.topPlaces) {
        [annotations addObject:[FlickrPlaceAnnotation annotationForPhoto:place]];
    }
    return annotations;
}


// TOCHECK: Is really implementing UISplitViewControllerDelegate only to this ViewController?
//          No need for RecentstableController?
//
#pragma mark - UISplitViewControllerDelegate
-(void) awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate=self;
}

-(id <SplitViewBarButtonItemPresenter>) splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

-(BOOL) splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

-(void) splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"FlickrFecher"; // self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
    
}

-(void) splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

@end
