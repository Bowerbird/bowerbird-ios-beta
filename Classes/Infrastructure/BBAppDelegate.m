/*-----------------------------------------------------------------------------------------------
 
 BowerBird V1 - Licensed under MIT 1.1 Public License
 Developers: Frank Radocaj : frank@radocaj.com, Hamish Crittenden : hamish.crittenden@gmail.com
 Project Manager: Ken Walker : kwalker@museum.vic.gov.au
 
 -----------------------------------------------------------------------------------------------*/


#import "BBAppDelegate.h"
#import "BBContainerController.h"
#import "BBObservationCreate.h"
#import "BBMappings.h"
#import "BBHelpers.h"
#import <RestKit/RestKit.h>


@implementation BBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // RestKit
    RKObjectManager *restKitManager = [RKObjectManager managerWithBaseURL:[BBConstants RootUri]];
    [restKitManager.HTTPClient setDefaultHeader:@"X-Requested-With" value:@"XMLHttpRequest"];
    [restKitManager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/www-form-urlencoded"];
    [BBMappings mappingsForRKManager:restKitManager];
    
    // Turn on Spinner when Network is Busy
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Reachability
    [restKitManager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Network Connection"
                                                           message:@"You must be connected to the internet either over 3G, 4G, LTE or WIFI to use the BowerBird app"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }];    
    
    // UI
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    BBContainerController *container = [[BBContainerController alloc]init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:container];
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    // prevent the app from going to sleep while it is active.. stops upload killing..
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
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