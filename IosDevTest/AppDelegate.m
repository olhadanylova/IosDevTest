//
//  AppDelegate.m
//  IosDevTest
//
//  Created by Olha Danylova on 26.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

#import "AppDelegate.h"
#import "ProductDetailsViewController.h"
#import "Backendless.h"

static NSString *APP_ID = @"7272A465-A10C-B8FC-FFFC-EC6FAB58BA00";
static NSString *SECRET_KEY = @"5FED2132-3B26-38D4-FF91-8B08B265B600";
static NSString *VERSION = @"v1";

@interface AppDelegate () <UISplitViewControllerDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    // Backendless application initialization.
    [backendless initApp:APP_ID secret:SECRET_KEY version:VERSION];
    
    return YES;
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[ProductDetailsViewController class]] && ([(ProductDetailsViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) return YES;
    else return NO;
}

@end
