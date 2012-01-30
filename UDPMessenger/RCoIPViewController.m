//
//  RCoIPViewController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 11.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RCoIPViewController.h"

@implementation RCoIPViewController

@synthesize rctx, buttonTransmission, led1Switch, batteryLabel, batteryLegendLabel, buttonUp, buttonDown, buttonLeft, buttonRight, sliderSpeed, buttonGyroscopeMode, gyroUpdateTimer, motionManager, throttle, direction, motorValue, thresholdMove, labelGyro, isTransmissionOn;

const uint8_t forwards = 1;
const uint8_t backwards = 0;

#pragma mark - own functions

-(void)initRCoIPViewController
{
    // Init buttons, switches and labels
    [led1Switch setEnabled:FALSE];
    [buttonTransmission setEnabled:TRUE];
    [buttonGyroscopeMode setEnabled:TRUE];
    [batteryLegendLabel setText:@""];
    [batteryLabel setText:@""];
    [self setIsTransmissionOn:FALSE];
    [buttonTransmission setTitle:@"Start transmission" 
                        forState:UIControlStateNormal];
    
    // start the RC transmitter
    rctx = [RCTx alloc];
    [rctx initRCTx];
    
    // init the gyroscope
    motionManager = [[CMMotionManager alloc] init];
    [self setThresholdMove:0.15];   // more than 15% percent needed to move
    [buttonGyroscopeMode setTitle:@"deviceMotion off" 
                         forState:UIControlStateNormal];

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
    motorValue = [self getThrottleValue];
    
    rctx->channels.leftDirection = forwards;
    rctx->channels.rightDirection = forwards;
    rctx->channels.leftSpeed = motorValue;
    rctx->channels.rightSpeed = motorValue;
    
    NSLog(@"move forward with speed:%i",motorValue);
}

-(void)moveBackward
{    
    motorValue = [self getThrottleValue];
    
    rctx->channels.leftDirection = backwards;
    rctx->channels.rightDirection = backwards;
    rctx->channels.leftSpeed = motorValue;
    rctx->channels.rightSpeed = motorValue;
    
    NSLog(@"move backward with speed:%i",motorValue);
}

-(void)turnLeft
{    
    motorValue = [self getDirectionValue];
    
    rctx->channels.leftDirection = backwards;
    rctx->channels.rightDirection = forwards;
    rctx->channels.leftSpeed = motorValue;
    rctx->channels.rightSpeed = motorValue;
    
    NSLog(@"turn left with speed:%i",motorValue);
}

-(void)turnRight
{    
    motorValue = [self getDirectionValue];
    
    rctx->channels.leftDirection = forwards;
    rctx->channels.rightDirection = backwards;
    rctx->channels.leftSpeed = motorValue;
    rctx->channels.rightSpeed = motorValue;
        
    NSLog(@"turn right with speed:%i",motorValue);
}

-(void)stopMoving
{
    motorValue = 0;
    
    rctx->channels.leftDirection = 0;
    rctx->channels.rightDirection = 0;
    rctx->channels.leftSpeed = 0;
    rctx->channels.rightSpeed = 0;
    
    NSLog(@"stop moving");
}

-(uint8_t)getDirectionValue
{
    if([motionManager isDeviceMotionActive])
    {
        if(direction > 0.0)
        {
            if(direction > 1.0)
            {
                return 255;
            }
            else
            {
                return (255 * direction);
            }
        }
        else
        {
            if(direction < -1.0)
            {
                return 255;
            }
            else
            {
                return (-255 * direction);
            }
        }        
    }
    else
    {
        return (uint8_t)[sliderSpeed value];      
    }
}

-(uint8_t)getThrottleValue
{
    if([motionManager isDeviceMotionActive])
    {
        if(throttle > 0.0)
        {
            if(throttle > 1.0)
            {
                return 255;
            }
            else
            {
                return (255 * throttle);
            }
        }
        else
        {
            if(throttle < -1.0)
            {
                return 255;
            }
            else
            {
                return (-255 * throttle);
            }
        }
    }
    else
    {
        return (uint8_t)[sliderSpeed value];      
    }
}

#pragma mark - button actions

-(IBAction)toggleTransmission:(id)sender
{
    if(isTransmissionOn)
    {
        // turn transmission off
        [self setIsTransmissionOn:FALSE];
        [self stopTransmission];
        [buttonTransmission setTitle:@"Start transmission" forState:UIControlStateNormal];
    }
    else
    {
        // turn transmission on
        [self setIsTransmissionOn:TRUE];
        [self startTransmission];
        [buttonTransmission setTitle:@"Stop transmission" forState:UIControlStateNormal];
    }
}

-(void)startTransmission
{
    // Set states of buttons and switches
    [led1Switch setEnabled:TRUE];
    [batteryLegendLabel setText:@"Battery voltage:"];
    
    // start RC transmitter
    [rctx startTransmission];
    
    // add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(processReceivedData:) 
                                                 name:@"udpDataReceived" 
                                               object:nil];
}

-(void)stopTransmission
{
    // Set states of buttons and switches
    [led1Switch setEnabled:FALSE];
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

-(IBAction)toggleGyroUpdates:(id)sender
{
    if([motionManager isGyroAvailable])
    {
        if([motionManager isDeviceMotionActive])
        {
            // stop gyroscope
            [motionManager stopDeviceMotionUpdates];
            // stop gyroUpdateTimer
            [gyroUpdateTimer invalidate];
            // enable arrow-buttons and slider
            [buttonUp    setEnabled:TRUE];
            [buttonDown  setEnabled:TRUE];
            [buttonLeft  setEnabled:TRUE];
            [buttonRight setEnabled:TRUE];
            [sliderSpeed setEnabled:TRUE];
            // set button title
            [buttonGyroscopeMode setTitle:@"deviceMotion off" forState:UIControlStateNormal];
        }
        else
        {
            // start gyroscope
            [motionManager startDeviceMotionUpdates];
            // start gyroUpdateTimer
            gyroUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0 
                                                               target:self 
                                                             selector:@selector(doGyroUpdate) 
                                                             userInfo:nil 
                                                              repeats:YES];
            // disable arrow-buttons and slider
            [buttonUp    setEnabled:FALSE];
            [buttonDown  setEnabled:FALSE];
            [buttonLeft  setEnabled:FALSE];
            [buttonRight setEnabled:FALSE];
            [sliderSpeed setEnabled:FALSE];
            // set button title
            [buttonGyroscopeMode setTitle:@"deviceMotion on" forState:UIControlStateNormal];
            
            throttle = 0;
            direction = 0;
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }

}

-(void)doGyroUpdate
{
    throttle = motionManager.deviceMotion.attitude.roll;
    direction = motionManager.deviceMotion.attitude.pitch;
    
    if(fabs(throttle)>fabs(direction))
    {
        // drive forwards or backwards
        if(throttle > 0)
        {
            if(throttle < [self thresholdMove])         // less than 15%
            {
                [self stopMoving];
            }
            else
            {
                [self moveForward];
            }
        }
        else
        {
            if(throttle > (-1 * [self thresholdMove]))  // less than 15%
            {
                [self stopMoving];
            }
            else
            {
                [self moveBackward];
            }
        }
    }
    else
    {
        // turn left or right
        if(direction > 0)
        {
            if(direction < [self thresholdMove])        // less than 15%
            {
                [self stopMoving];
            }
            else
            {
                [self turnRight];            
            }
        }
        else
        {
            if(direction > (-1 * [self thresholdMove])) // less than 15%
            {
                [self stopMoving];
            }
            else
            {
                [self turnLeft];           
            }
        }
    }
    
    NSString *motorValueString = [[NSString alloc] initWithFormat:@"%i",motorValue];
    [labelGyro setText:motorValueString];
    [motorValueString release];
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
