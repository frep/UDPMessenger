//
//  LEDTestViewController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 02.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LEDTestViewController.h"

@implementation LEDTestViewController

@synthesize appDelegate, led1Switch, statusLabel, connectButton, serverNotResponding, serverResponding, getValues, serverIsResponding;

#pragma mark - own functions

-(void)initLEDTestViewController
{
    NSLog(@"initLEDTestViewController:");
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    getValues = [[NSString alloc] initWithFormat:@"g"];
    serverNotResponding = [[NSString alloc] initWithFormat:@"server is not responding"];
    serverResponding = [[NSString alloc] initWithFormat:@"server is responding"];
    
    [statusLabel setText:serverNotResponding];
    
    // view controller acts as an observer and is notified, when the UDPController has received a message
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(processReceivedData:) 
                                                 name:@"udpDataReceived" 
                                               object:nil];
    [self serverCanBeDisconnected];
    // try to connect to server
    [[appDelegate udpController] sendMessage:getValues];
}

-(IBAction)connectButtonPushed:(id)sender
{
    [[appDelegate udpController] sendMessage:getValues];
}

-(IBAction)led1SwitchValueChanged:(id)sender
{
    if(led1Switch.on)
    {
        // LED shall be set to ON
        [[appDelegate udpController] sendMessage:@"s_1"];
    }
    else
    {
        // LED shall be set to OFF
        [[appDelegate udpController] sendMessage:@"s_0"];
    }
}

-(void)serverIsConnected
{
    [self setServerIsResponding:TRUE];
    [led1Switch setEnabled:TRUE];
    [connectButton setEnabled:FALSE];
    [statusLabel setText:serverResponding];
    //[led1Switch setOn:<#(BOOL)#> animated:<#(BOOL)#>];
}

-(void)serverCanBeDisconnected
{
    [self setServerIsResponding:FALSE];
    [led1Switch setEnabled:FALSE];
    [connectButton setEnabled:TRUE];
    [statusLabel setText:serverNotResponding];
}

#pragma mark - observer notification methods

-(void)processReceivedData:(NSNotification *)note
{
    if(!serverIsResponding)
    {
        NSString *message = [[NSString alloc] initWithData:[[appDelegate udpController] receivedData] 
                                                  encoding:NSUTF8StringEncoding];
        if([message isEqualToString:@"LED1_1"])         // LED1 is actual on
        {
            [led1Switch setOn:TRUE];
        }
        else if([message isEqualToString:@"LED1_0"])    // LED1 is actual off
        {
            [led1Switch setOn:FALSE];
        }
        else
        {
            NSLog(@"message not recognized");
        }
        [self serverIsConnected];
        [message release];
    }
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initLEDTestViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self serverCanBeDisconnected];
    // remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"udpDataReceived" 
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
