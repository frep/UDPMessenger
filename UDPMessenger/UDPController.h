//
//  UDPController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 01.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// The UDPController handles the GCDAsyncUdpSocket. It listens to the UDPSocket until
// a UPD-Message has to be send. Then, it stops receiving, send the message, and start
// listening again.
// If a message is received, the data and the sender address are stored and the
// notification 'udpDataReceived' is set.

#import <Foundation/Foundation.h>
// own imports:
#import <CFNetwork/CFNetwork.h>
#import "GCDAsyncUdpSocket.h"

#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>

@interface UDPController : NSObject <GCDAsyncUdpSocketDelegate>
{
    @public
    NSString            *localIp;
    NSString            *serverIp;
    uint16_t            serverPort;
    NSData              *receivedData;
    NSData              *receivedDataSenderAddress;
    
    @private
    GCDAsyncUdpSocket   *asyncUdpSocket;
    BOOL                ReceiveModeActive;
    long                defaultTag;
}

@property (retain, nonatomic) NSString          *localIp;
@property (retain, nonatomic) NSString          *serverIp;
@property (nonatomic)         uint16_t          serverPort;
@property (retain, nonatomic) GCDAsyncUdpSocket *asyncUdpSocket;
@property (retain, nonatomic) NSData            *receivedData;
@property (retain, nonatomic) NSData            *receivedDataSenderAddress;
@property (nonatomic)         BOOL              ReceiveModeActive;
@property (nonatomic)         long              defaultTag;


-(void)initUDPControllerwithServer:(NSString*)server atPort:(uint16_t) port;
-(void)changeUDPControllerToServer:(NSString*)server atPort:(uint16_t) port;
-(void)sendMessage:(NSString*)message;
-(void)sendDataMessage:(NSData *)data;
-(void)sendMessage:(NSString*)message withTimeout:(NSTimeInterval)timeout;
-(void)sendDataMessage:(NSData *)data withTimeout:(NSTimeInterval)timeout;
-(void)sendMessage:(NSString*)message withTimeout:(NSTimeInterval)timeout tag:(long)tag;
-(void)sendDataMessage:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
-(void)beginReceiving;
-(NSString *)getLocalIp;
-(NSString *)getSenderAddress;

@end
