//
//  RotatableViewController.m
//  Psychologist
//
//  Created by Norimasa Nabeta on 12/07/17.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

// @1443 Copying Psychologist code doesn't result in popover in portrait
// This behavior for SplitViewController was changed between 5.0 when the lecture was done and 5.1.
// You can confirm this by installing and running the app in the 5.0 emulator.
// No built in way to change it.
//
// * Xcode>>Preference>>Downloads>>Components
// --> iOS5.0 Simulator (553.7MB)
// * TARGET>>Summary>>iOS Application Target
// --> Deployment Target: 5.0
//

#import "RotatableViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface RotatableViewController ()
@end

@implementation RotatableViewController
-(void) awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate=self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UISplitViewControllerDelegate
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
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
   
}

-(void) splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}


@end
