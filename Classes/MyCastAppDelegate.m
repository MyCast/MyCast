//
//  MyCastAppDelegate.m
//  MyCast
//
//  Created by Jannes Klaas
//  Copyright 2011 JannesCode. All rights reserved.
//

#import "MyCastAppDelegate.h"
#import "BackgroundLoader.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIDevice-Reachability.h"
#import "BWQuincyManager.h"
#import "CastView.h"


@implementation MyCastAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize queue;
@synthesize tabBar;
@synthesize navigationBarColor;
@synthesize backroundImagePath;
@synthesize textColor;
@synthesize hasInternet;
@synthesize castView;

#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://www.lk-media.com/mycast/crash_reporter_ios/crash_v200.php"];

    // Add the tab bar controller's view to the window and display.
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
	// und legen auch gleich die queue an.
    queue = [[NSOperationQueue alloc] init];
    
	// Wenn die App von einer Notification gestartet wird und nicht nur in den Vordergrund geholt, dann gibt es in den launchOptions einen key „UIApplicationLaunchOptionsRemoteNotificationKey“ in welchem
    //  wiederum unsere userInfo der Notification steht. Da in dem Fall NICHT noch extra didReceiveRemoteNotification() aufgerufen wird, müssen wir die Notification hier direkt behandeln.´
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (setCategoryError) { /* handle the error condition */ }
    
    NSError *activationError = nil;
    [audioSession setActive:YES error:&activationError];
    if (activationError) { /* handle the error condition */ }
    
	if(launchOptions)
	{
		NSDictionary *userInfo=[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
		if(userInfo)
			[self handleUserInfo:userInfo];
	};
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void) handleUserInfo:(NSDictionary *)userInfo {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if ([[UIDevice currentDevice] activeWLAN]) {
        hasInternet = YES;
    }
    if ([[UIDevice currentDevice] activeWWAN]) {
        hasInternet = YES;
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    if (castView) {
        if (castView.isDownloading) {
            [castView abboardDownload];
        }
    }
    
}

#pragma mark -
#pragma mark push

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{ 
	// wir starten die Registrierung im Hintergrund
	if(queue)
	{
		BackgroundLoader *backLoader=[[BackgroundLoader alloc] initWithToken:devToken];
		if(backLoader)
		{
			[queue  addOperation:backLoader];
			[backLoader release];
		}
	}
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
	// Tja hier machen wir was immer wir wollen wenn die Registrierung fehlgeschlagen hat
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo 
{	
	// und hier behandeln wir eine eigehende Notification. Dabei steht in der userInfo genau das was wir auf unserem Server in den $payload geschrieben haben.
	[self handleUserInfo:userInfo];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [tabBar release];
    [textColor release];
    [super dealloc];
}

@end

