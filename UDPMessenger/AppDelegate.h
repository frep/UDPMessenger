//
//  AppDelegate.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 31.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDPController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @public
    UDPController        *udpController;
}

@property (strong, nonatomic) UIWindow      *window;
@property (retain, nonatomic) UDPController *udpController;

-(BOOL)serverSettingsHaveChanged;

@end
