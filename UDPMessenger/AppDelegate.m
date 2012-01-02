//
//  AppDelegate.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 31.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize udpController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
    [udpController release];
}

#pragma mark - own functions

-(BOOL)serverSettingsHaveChanged
{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"ip_preference"] isEqualToString:[udpController serverIp]] &&
       ([[[NSUserDefaults standardUserDefaults] stringForKey:@"port_preference"] intValue] == [udpController serverPort]))
    {
        return FALSE;
    }

    return YES;
}

#pragma mark - delegate functions

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults stringForKey:@"ip_preference"] == nil)
    {
        [defaults setObject:NSLocalizedString(@"192.168.1.30", nil) forKey:@"ip_preference"];
        [defaults setObject:NSLocalizedString(@"9048", nil) forKey:@"port_preference"];
        [defaults synchronize];
        
        UIAlertView *infoView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Achtung", nil) message:NSLocalizedString(@"Diese Anwendung wurde das erste Mal gestartet. Bitte überprüfen Sie Ihre Daten in der \"Einstellungen\"-Anwendung.",nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [infoView show];
        [infoView release];
    }
    
    udpController = [UDPController alloc];
    [udpController initUDPControllerwithServer:[defaults stringForKey:@"ip_preference"] 
                                        atPort:[[defaults stringForKey:@"port_preference"] intValue]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    if([self serverSettingsHaveChanged])
    {        
        // connect to the new server
        [udpController changeUDPControllerToServer:[[NSUserDefaults standardUserDefaults] stringForKey:@"ip_preference"] 
                                            atPort:[[[NSUserDefaults standardUserDefaults] stringForKey:@"port_preference"] intValue]];
        
        // An observer can add to this notification 
        [[NSNotificationCenter defaultCenter] postNotificationName:@"serverSettingsHaveChanged" object:nil];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
