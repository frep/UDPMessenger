//
//  UDPController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 01.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UDPController.h"

@implementation UDPController

@synthesize localIp, serverIp, serverPort, asyncUdpSocket, receiveData, ReceiveModeActive, defaultTag;

#pragma mark - delegate methods

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 * 
 * This method is called if one of the connect methods are invoked, and the connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSLog(@"delegate: udpSocket did connect");
    [self beginReceiving];
    
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 * 
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"delegate: udpSocket did not connect");
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"delegate: udpSocket did send data with tag:%li",tag);
    [self beginReceiving];
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"delegate: udpSocket did not send data");
    [self beginReceiving];
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock 
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSLog(@"delegate: udpSocket did receive data");
    [self setReceiveData:data];
    // An observer can add to this notification 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"udpDataReceived" object:nil];
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"delegate: udpSocket did close");
}

#pragma mark - own private methods

-(void)initUDPControllerwithServer:(NSString*)server atPort:(uint16_t) port
{
    // set default values of the members
    [self setDefaultTag:1];
    [self setReceiveModeActive:FALSE];
    [self setLocalIp:[self getLocalIp]];
    
    // init socket
    asyncUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self 
                                                   delegateQueue:dispatch_get_main_queue()];
    // connect to host
    NSError *err = nil;
    if (![asyncUdpSocket connectToHost:server onPort:port error:&err]) 
    {
        NSLog(@"Connection Error: %@",err);
    }
}

-(void)sendMessage:(NSString*)message
{
    [self sendMessage:message 
          withTimeout:-1 
                  tag:defaultTag];
}

-(void)sendMessage:(NSString*)message withTimeout:(NSTimeInterval)timeout
{
    [self sendMessage:message 
          withTimeout:timeout 
                  tag:defaultTag];
}

-(void)sendMessage:(NSString*)message withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    if(ReceiveModeActive)
    {
        [asyncUdpSocket pauseReceiving];
        [self setReceiveModeActive:FALSE];
        
    }
    [asyncUdpSocket sendData:[message dataUsingEncoding:NSUTF8StringEncoding] 
                 withTimeout:timeout 
                         tag:tag];
}

-(void)beginReceiving
{
    NSError *err;
    if(![asyncUdpSocket beginReceiving:&err])
    {
        NSLog(@"Error occured: %@",err);
    }
    else
    {
        [self setReceiveModeActive:TRUE];
    }
    [err release];
}

-(NSString *)getLocalIp
{
	// On iPhone, WiFi is always "en0"
	
	//NSData *result = nil;
    NSString *result = nil;
	
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	
	if ((getifaddrs(&addrs) == 0))
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			NSLog(@"cursor->ifa_name = %s", cursor->ifa_name);
			
			if (strcmp(cursor->ifa_name, "en0") == 0)
			{
				if (cursor->ifa_addr->sa_family == AF_INET)
				{
					struct sockaddr_in *addr = (struct sockaddr_in *)cursor->ifa_addr;
					NSLog(@"cursor->ifa_addr = %s", inet_ntoa(addr->sin_addr));
					
                    result = [[NSString alloc] initWithFormat:@"%s",inet_ntoa(addr->sin_addr)];

					cursor = NULL;
				}
				else
				{
					cursor = cursor->ifa_next;
				}
			}
			else
			{
				cursor = cursor->ifa_next;
			}
		}
		freeifaddrs(addrs);
	}
	
	return result;
}


@end
