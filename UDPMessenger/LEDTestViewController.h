//
//  LEDTestViewController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LEDTestViewController : UIViewController
{
    AppDelegate       *appDelegate;
    
    IBOutlet UISwitch *led1Switch;
    IBOutlet UILabel  *statusLabel;
    IBOutlet UIButton *connectButton;
    
    NSString          *serverNotResponding;
    NSString          *serverResponding;
    NSString          *getValues;
    BOOL              serverIsResponding;
}

@property (retain, nonatomic) AppDelegate       *appDelegate;
@property (retain, nonatomic) IBOutlet UISwitch *led1Switch;
@property (retain, nonatomic) IBOutlet UILabel  *statusLabel;
@property (retain, nonatomic) IBOutlet UIButton *connectButton;
@property (retain, nonatomic) NSString          *serverNotResponding;
@property (retain, nonatomic) NSString          *serverResponding;
@property (retain, nonatomic) NSString          *getValues;
@property (nonatomic)         BOOL              serverIsResponding;

-(IBAction)connectButtonPushed:(id)sender;
-(IBAction)led1SwitchValueChanged:(id)sender;

-(void)initLEDTestViewController;
-(void)serverIsConnected;
-(void)serverCanBeDisconnected;

// methods called by observer-notifications 
-(void)processReceivedData:(NSNotification *)note;

@end