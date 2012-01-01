//
//  ViewController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 31.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CFNetwork/CFNetwork.h>
#import "GCDAsyncUdpSocket.h"

#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>

@interface ViewController : UIViewController <GCDAsyncUdpSocketDelegate>
{
    IBOutlet UILabel     *localIpLabel;
    IBOutlet UITextField *destAddrTextField;
    IBOutlet UITextField *portTextField;
    IBOutlet UITextField *messageTextField;
    IBOutlet UILabel     *receivedMessageLabel;
    
    uint16_t             defaultPort;
    
    CFHostRef            host;
    NSData               *wifiAddr;
    NSData               *answerFromHost;
	GCDAsyncUdpSocket    *asyncUdpSocket;
    BOOL                 ReceiveModeActive;
}

@property (retain, nonatomic) UILabel     *localIpLabel;
@property (retain, nonatomic) UITextField *destAddrTextField;
@property (retain, nonatomic) UITextField *portTextField;
@property (retain, nonatomic) UITextField *messageTextField;
@property (retain, nonatomic) UILabel     *receivedMessageLabel;
@property (retain, nonatomic) NSData      *wifiAddr;
@property (nonatomic)         uint16_t    defaultPort;
@property (nonatomic)         BOOL        ReceiveModeActive;

-(IBAction)sendButtonPushed:(id)sender;
-(IBAction)hideKeyboard:(id)sender;

-(void)initController;
-(void)listInterfaces;
-(NSData *)wifiAddress;
-(void)initSocket;
-(void)connectToHost;
-(void)sendMessage:(NSString*)message withTimeout:(NSTimeInterval)timeout tag:(long)tag;
-(void)beginReceiving;

@end
