//
//  RCoIPViewController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 11.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCoIPViewController.h"

@implementation RCoIPViewController

@synthesize rctx, startButton, stopButton, led1Switch, batteryLabel, batteryLegendLabel, buttonUp, buttonDown, buttonLeft, buttonRight, sliderSpeed;

const uint8_t forwards = 1;
const uint8_t backwards = 0;

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

#pragma mark - movement commands

-(void)moveForward
{
    rctx->channels.leftDirection = forwards;
    rctx->channels.rightDirection = forwards;
    rctx->channels.leftSpeed = (uint8_t)[sliderSpeed value];
    rctx->channels.rightSpeed = (uint8_t)[sliderSpeed value];
    
    NSLog(@"move forward with speed:%i",(uint8_t)[sliderSpeed value]);
}

-(void)moveBackward
{
    rctx->channels.leftDirection = backwards;
    rctx->channels.rightDirection = backwards;
    rctx->channels.leftSpeed = (uint8_t)[sliderSpeed value];
    rctx->channels.rightSpeed = (uint8_t)[sliderSpeed value];
    
    NSLog(@"move backward with speed:%i",(uint8_t)[sliderSpeed value]);
}

-(void)turnLeft
{
    rctx->channels.leftDirection = backwards;
    rctx->channels.rightDirection = forwards;
    rctx->channels.leftSpeed = (uint8_t)[sliderSpeed value];
    rctx->channels.rightSpeed = (uint8_t)[sliderSpeed value];
    
    NSLog(@"turn left with speed:%i",(uint8_t)[sliderSpeed value]);
}

-(void)turnRight
{
    rctx->channels.leftDirection = forwards;
    rctx->channels.rightDirection = backwards;
    rctx->channels.leftSpeed = (uint8_t)[sliderSpeed value];
    rctx->channels.rightSpeed = (uint8_t)[sliderSpeed value];
    
    NSLog(@"turn right with speed:%i",(uint8_t)[sliderSpeed value]);
}

-(void)stopMoving
{
    rctx->channels.leftDirection = 0;
    rctx->channels.rightDirection = 0;
    rctx->channels.leftSpeed = 0;
    rctx->channels.rightSpeed = 0;
    
    NSLog(@"stop moving");
}

#pragma mark - button actions

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

-(IBAction)buttonUpPushed:(id)sender
{
    [self moveForward];
}

-(IBAction)buttonDownPushed:(id)sender
{
    [self moveBackward];
}

-(IBAction)buttonLeftPushed:(id)sender
{
    [self turnLeft];
}

-(IBAction)buttonRightPushed:(id)sender
{
    [self turnRight];
}

-(IBAction)buttonUpReleased:(id)sender
{
    [self stopMoving];
}

-(IBAction)buttonDownReleased:(id)sender
{
    [self stopMoving];
}

-(IBAction)buttonLeftReleased:(id)sender
{
    [self stopMoving];
}

-(IBAction)buttonRightReleased:(id)sender
{
    [self stopMoving];
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
