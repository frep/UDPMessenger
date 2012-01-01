//
//  ViewController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 31.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize localIpLabel, destAddrTextField, portTextField, messageTextField, receivedMessageLabel, wifiAddr, ReceiveModeActive;


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
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSLog(@"delegate: udpSocket did receive data");
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [receivedMessageLabel setText:message];
    [message release];
}

/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"delegate: udpSocket did close");
}


#pragma mark - own functions

-(IBAction)sendButtonPushed:(id)sender
{
    // enter usefull stuff here
    NSString *message = [[NSString alloc] initWithString:[messageTextField text]];
    NSLog(@"Try to send: %@",message);
    [self sendMessage:message withTimeout:-1 tag:1];
    [message release];
}

-(IBAction)hideKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

-(void)initController
{
    NSLog(@"initController:");
    [destAddrTextField setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"ip_preference"]];
    [portTextField setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"port_preference"]];
    [self setReceiveModeActive:FALSE];
    [self listInterfaces];                  // just for testing purpose
    [self setWifiAddr:[self wifiAddress]];  // Initializes wifiAddr and sets localIp-Label
    [self initSocket];
    [self connectToHost];
}

- (void)listInterfaces
{
	NSLog(@"listInterfaces");
	
	struct ifaddrs *addrs;
	const struct ifaddrs *cursor;
	
	if ((getifaddrs(&addrs) == 0))
	{
		cursor = addrs;
		while (cursor != NULL)
		{
			NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
			NSLog(@"%@", name);
			
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
}

- (NSData *)wifiAddress
{
	// On iPhone, WiFi is always "en0"
	
	NSData *result = nil;
	
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
					
                    
                    //frep
                    NSString *localIp = [[NSString alloc] initWithFormat:@"%s",inet_ntoa(addr->sin_addr)];
                    [localIpLabel setText:localIp];
                    [localIp release];
                    // end frep
                    
					result = [NSData dataWithBytes:addr length:sizeof(struct sockaddr_in)];
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

-(void)initSocket
{
    asyncUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)connectToHost
{
    NSString *hostAdr = [[NSString alloc] initWithString:[destAddrTextField text]];
    uint16_t portNr = [[portTextField text] intValue];
    
    NSError *err = nil;
    if (![asyncUdpSocket connectToHost:hostAdr onPort:portNr error:&err]) 
    {
        NSLog(@"Connection Error: %@",err);
    }
    [hostAdr release];
}

-(void)sendMessage:(NSString*)message withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    if(ReceiveModeActive)
    {
        [asyncUdpSocket pauseReceiving];
        
    }
    [asyncUdpSocket sendData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:timeout tag:tag];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
