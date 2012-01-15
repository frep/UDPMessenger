//
//  RCTx.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 11.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCOIP.h"
#import "AppDelegate.h"

// channels
typedef struct
{
    uint8_t version;
    uint8_t led;
} Channels;

// RCTx defines the timers and the data for sending the messages
@interface RCTx : NSObject
{
    @public
    Channels       channels;
    
    @protected 
    AppDelegate    *appDelegate;
    NSTimer        *sendTimer;
    NSTimeInterval sendInterval;
    float          maxBatteryVoltage;
    
}

@property (nonatomic)         Channels       channels;
@property (retain, nonatomic) AppDelegate    *appDelegate;
@property (retain, nonatomic) NSTimer        *sendTimer;
@property (nonatomic)         NSTimeInterval sendInterval;
@property (nonatomic)         float          maxBatteryVoltage;

-(void)initRCTx;
-(void)initRCTxWithSendInterval:(NSTimeInterval)interval;
-(void)startTransmission;
-(void)stopTransmission;
-(void)sendUDPMessage:(NSTimer *)theTimer;


@end
