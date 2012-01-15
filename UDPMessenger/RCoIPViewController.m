//
//  RCoIPViewController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 11.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCoIPViewController.h"

@implementation RCoIPViewController

@synthesize rctx, startButton, stopButton, led1Switch, batteryLabel, batteryLegendLabel;

#pragma mark - own functions

-(void)initRCoIPViewController
{
    // Init buttons, switches and labels
    [led1Switch setEnabled:FALSE];
    [startButton setEnabled:TRUE];
    [stopButton setEnabled:FALSE];
    [batteryLegendLabel setText:@""];
    [batteryLabel setText:@""];
    
    // start the RC transmitter
    rctx = [RCTx alloc];
    [rctx initRCTx];
}

-(IBAction)led1SwitchValueChanged:(id)sender
{
    if(led1Switch.on)
    {
        // set LED1 channel to 'ON'
        rctx->channels.led = 1;
    }
    else
    {
        // set LED1 channel to 'OFF'
        rctx->channels.led = 0;
    }
}

-(IBAction)startTransmission
{
    // Set states of buttons and switches
    [led1Switch setEnabled:TRUE];
    [startButton setEnabled:FALSE];
    [stopButton setEnabled:TRUE];
    [batteryLegendLabel setText:@"Battery voltage:"];
    
    // start RC transmitter
    [rctx startTransmission];
    
    // add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(processReceivedData:) 
                                                 name:@"udpDataReceived" 
                                               object:nil];
}

-(IBAction)stopTransmission
{
    // Set states of buttons and switches
    [led1Switch setEnabled:FALSE];
    [startButton setEnabled:TRUE];
    [stopButton setEnabled:FALSE];
    [batteryLegendLabel setText:@""];
    [batteryLabel setText:@""];
    
    // stop RC transmitter
    [rctx stopTransmission];
    
    // remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:@"udpDataReceived" 
                                                  object:nil];
}

#pragma mark - observer notification methods

-(void)processReceivedData:(NSNotification *)note
{
    // check, if data comes from the arduino
    NSString *senderAddress = [[NSString alloc] initWithString:[[[rctx appDelegate] udpController] getSenderAddress]];
    if(![senderAddress isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"ip_preference"]])
    {
        NSLog(@"sender address wrong");
    }
    
    // Get received data
    NSData *rxdata = [[NSData alloc] initWithData:[[[rctx appDelegate] udpController] receivedData]];
    const void *bytes = [rxdata bytes];
    int length = [rxdata length];

    // check the size of the received data
    RCOIPReplyReceiverStatus answer;
    if(sizeof(answer) != length) 
    {
        NSLog(@"size of received msg does not match");
    }
    else
    {
        // fill the answer with the received data
        answer.version        = *(uint8_t*)bytes;
        answer.batteryVoltage = *(uint8_t*)(bytes + sizeof(uint8_t));
    }
    
    
    // identify RCOIPReplyReceiverStatus message
    if(answer.version != RC_VERSION)
    {
        // received data is no RCIOPReplyReceiverStatus message
        NSLog(@"wrong data format");
    }

    // identify value of battery voltage
    float batVolt = [rctx maxBatteryVoltage] * answer.batteryVoltage / 255;
    
    // set string value of battery voltage to batteryLabel
    NSString *valueString = [[NSString alloc] initWithFormat:@"%.2f V",batVolt];
    [batteryLabel setText:valueString];
    
    // release used objects
    [senderAddress release];
    [valueString release];
    [rxdata release];
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

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
    [self initRCoIPViewController];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
