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
    getValues = [[NSString alloc] initWithFormat:@"1"];
    serverNotResponding = [[NSString alloc] initWithFormat:@"server is not responding"];
    serverResponding = [[NSString alloc] initWithFormat:@"server is responding"];
    
    [statusLabel setText:serverNotResponding];
    
    // view controller acts as an observer and is notified, when the UDPController
    // has received a message
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
        [self serverIsConnected];
    }
    [[appDelegate udpController] sendMessage:getValues];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
