//
//  TerminalViewController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TerminalViewController.h"

@implementation TerminalViewController

@synthesize buttonClear, buttonSend, buttonStartStop, textViewTerminal, textFieldMessage, appDelegate, receivingIsStopped;

#pragma mark - own methods

-(void)initTerminalViewController
{
    NSLog(@"initTerminalViewController");
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self stopReceiving];
    [self clearTerminal];
    
}

-(IBAction)buttonSendPushed:(id)sender
{
    [self sendUDPMessage:[textFieldMessage text]];
}

-(IBAction)buttonClearPushed:(id)sender
{
    [self clearTerminal];
}

-(IBAction)buttonStartStopPushed:(id)sender
{
    [self toggleStartStop];
}

-(IBAction)hideKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

-(void)clearTerminal
{
    [textViewTerminal setText:@""];
}

-(void)sendUDPMessage:(NSString*)message
{
    [[appDelegate udpController] sendMessage:message];
}

-(void)toggleStartStop
{
    if (receivingIsStopped) 
    {
        [self startReceiving];
    }
    else
    {
        [self stopReceiving];
    }
}

-(void)startReceiving
{
    // set internal state
    [self setReceivingIsStopped:FALSE];
    // add observer
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(processReceivedData:) 
                                                 name:@"udpDataReceived" 
                                               object:nil];
    // set button text
    [buttonStartStop setTitle:@"stop" forState:UIControlStateNormal];
    // send a message to tell the destination IP and destination PORT
    [self sendUDPMessage:@"start"];
}

-(void)stopReceiving
{
    // set internal state
    [self setReceivingIsStopped:TRUE];
    // remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"udpDataReceived" 
                                                  object:nil];
    // set button text
    [buttonStartStop setTitle:@"start" forState:UIControlStateNormal];
}

#pragma mark - observer notification methods

-(void)processReceivedData:(NSNotification *)note
{
    NSString *message = [[NSString alloc] initWithData:[[appDelegate udpController] receivedData] encoding:NSUTF8StringEncoding];
    NSLog(@"message: %@",message);
    NSString *newText = [[NSString alloc] initWithFormat:@"%@\n%@", [textViewTerminal text], message];
    [textViewTerminal setText:newText];
    [textViewTerminal scrollRangeToVisible:NSMakeRange([textViewTerminal.text length], 0)];
    [message release];
    [newText release];
}

#pragma mark - some generated methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTerminalViewController];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self stopReceiving];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
