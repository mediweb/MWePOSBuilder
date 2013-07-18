//
//  MWAppDelegate.m
//  EpsonPrinterTest
//
//  Created by Matt on 7/16/13.
//  Copyright (c) 2013 Matthew Gillingham. All rights reserved.
//

#import "MWAppDelegate.h"
#import "MWViewController.h"
#import "MWePOSBuilder.h"
#import "MWePOSPrint.h"

@implementation MWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      self.viewController = [[MWViewController alloc] initWithNibName:@"MWViewController_iPhone" bundle:nil];
  } else {
      self.viewController = [[MWViewController alloc] initWithNibName:@"MWViewController_iPad" bundle:nil];
  }
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  
  MWePOSBuilder *builder = [[MWePOSBuilder alloc] init];
  [builder addImage:[UIImage imageNamed:@"logo1.bmp"] x:0 y:0 width:200 height:70 color:nil];
  [builder addCut:@"feed"];

  MWePOSPrint *printService = [[MWePOSPrint alloc] initWithPrinterURL:[NSURL URLWithString:@"http://192.168.1.16/cgi-bin/epos/service.cgi"]];
  [printService sendData:[builder printerData] completion:^(NSData *data, NSError *error){
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
  }];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
