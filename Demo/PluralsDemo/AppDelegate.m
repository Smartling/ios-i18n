//
//  AppDelegate.m
//  PluralsDemo
//
//  Created by Pavel Ivashkov on 2013-02-25.
//  Copyright (c) 2013 Smartling. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	MainViewController *root = [[MainViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:root];
	
	self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
