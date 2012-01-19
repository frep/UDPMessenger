//
//  RCTx.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 11.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCTx.h"

@implementation RCTx

@synthesize appDelegate, sendTimer, channels, sendInterval, maxBatteryVoltage;

-(void)initRCTx
{         
    [self initRCTxWithSendInterval:0.4];    // Set default send interval of 0.4 seconds
}

-(void)initRCTxWithSendInterval:(NSTimeInterval)interval
{
    [self setSendInterval:interval];
    [self setMaxBatteryVoltage:15.0];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    channels.version = RC_VERSION;
    // set default values of the channels
    channels.led = 0;
    channels.leftDirection = 0;
    channels.rightDirection = 0;
    channels.leftSpeed = 0;
    channels.rightSpeed = 0;
}

-(void)startTransmission
{
    // Start send timer
    [sendTimer invalidate];
    sendTimer = [NSTimer scheduledTimerWithTimeInterval: sendInterval 
                                                 target:self 
                                               selector:@selector(sendUDPMessage:) 
                                               userInfo:nil 
                                                repeats:YES];
    [sendTimer fire];
    
}

-(void)stopTransmission
{
    // Stop send timer
    [sendTimer invalidate];
    sendTimer = nil;
}

-(void)sendUDPMessage:(NSTimer *)theTimer
{
    NSData *data = [[NSData alloc] initWithBytes:&channels length:sizeof(channels)];
    [[appDelegate udpController] sendDataMessage:data];
}

@end
