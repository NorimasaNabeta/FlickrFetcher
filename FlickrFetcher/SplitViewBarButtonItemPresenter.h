//
//  SplitViewBarButtonItemPresenter.h
//  Psychologist/RotatableViewController
//
//  Created by 式正 鍋田 on 12/07/20.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SplitViewBarButtonItemPresenter <NSObject>
@property (nonatomic,strong) UIBarButtonItem *splitViewBarButtonItem;
@end


/*
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
 barButtonItem.title = self.title;
 [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
 
 }
 
 -(void) splitViewController:(UISplitViewController *)svc
 willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
 {
 [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
 }



*/