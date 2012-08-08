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
#import "PhotoMapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface DetailPlacesTableViewController () <PhotoMapViewControllerDelegate>
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
    UIBarButtonItem *backupButtonItem = self.navigationItem.rightBarButtonItem;
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
            self.navigationItem.rightBarButtonItem=backupButtonItem;
        });
    });
    dispatch_release(downloadQueue);
}

- (void) setPlace:(NSDictionary *)place
{
    if(_place != place){
        _place = place;
        self.title = [FlickrFetcher namePlace:place];
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

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

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
    cell.textLabel.text=[FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text=[FlickrFetcher stringValueFromKey:photo nameKey:FLICKR_PHOTO_DESCRIPTION];

    // ExtraCredit1
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.center=CGPointMake(20, 20); // <-- check !
    spinner.alpha = 0.7f;
    [cell.imageView addSubview:spinner];
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader4", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:[UIImage imageWithData:data]];
            [spinner stopAnimating];
            [spinner removeFromSuperview];
        });
    });
    dispatch_release(downloadQueue);
    
    return cell;
}

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
    //[self performSegueWithIdentifier:@"Flickr Photo View" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    // NSString *photographer = [self photographerForSection:indexPath.section];
    // NSArray *photosByPhotographer = [self.photosByPhotographer objectForKey:photographer];
    //    NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
    // self.place = [self.detailPlaces objectAtIndex:indexPath.row];
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
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"indexPath %@", indexPath);
        NSDictionary *photo = [self.detailPlaces objectAtIndex:indexPath.row];
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

        [segue.destinationViewController setPhoto:photo ];
    }
    else if ([segue.identifier isEqualToString:@"Photo Map View"]) {
        // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // NSLog(@"Map:indexPath %@", indexPath);
        id detail = segue.destinationViewController;
        if ([detail isKindOfClass:[PhotoMapViewController class]]) {
            PhotoMapViewController *mapVC = (PhotoMapViewController *)detail;
            mapVC.delegate = self;
            mapVC.annotations = [self mapAnnotations];
            // mapVC.title = self.title;
        }

    }
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.detailPlaces count]];
    for (NSDictionary *photo in self.detailPlaces) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)updateSplitViewDetail
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if ([detail isKindOfClass:[PhotoMapViewController class]]) {
        PhotoMapViewController *mapVC = (PhotoMapViewController *)detail;
        mapVC.delegate = self;
        mapVC.annotations = [self mapAnnotations];
    }
}

#pragma mark - PhotoMapViewControllerDelegate

- (UIImage *)mapViewController:(PhotoMapViewController *)sender
            imageForAnnotation:(id <MKAnnotation>)annotation
{    
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return data ? [UIImage imageWithData:data] : nil;
}



@end
