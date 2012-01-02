//
//  ViewController.m
//  UDPMessenger
//
//  Created by Pascal Frehner on 31.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize localIpLabel, serverIpLabel, portLabel, messageTextField, receivedMessageLabel, appDelegate;

#pragma mark - own functions

-(IBAction)sendButtonPushed:(id)sender
{
    [[appDelegate udpController] sendMessage:[messageTextField text]];
}

-(IBAction)hideKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

-(void)initViewController
{
    NSLog(@"initViewController:");
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setViewLabels];
    
    // view controller acts as an observer and is notified, when the UDPController
    // has received a message
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(processReceivedData:) 
                                                 name:@"udpDataReceived" 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(serverSettingsHaveChanged:) 
                                                 name:@"serverSettingsHaveChanged" 
                                               object:nil];
    
}

-(void)setViewLabels
{
    NSString *portString = [[NSString alloc] initWithFormat:@"%i",[[appDelegate udpController] serverPort]];
    [serverIpLabel setText:[[appDelegate udpController] serverIp]];
    [portLabel setText:portString];
    [localIpLabel setText:[[appDelegate udpController] localIp]];
    [portString release];
}

#pragma mark - observer notification methods

-(void)processReceivedData:(NSNotification *)note
{
    NSString *message = [[NSString alloc] initWithData:[[appDelegate udpController] receiveData] encoding:NSUTF8StringEncoding];
    NSLog(@"message: %@",message);
    [receivedMessageLabel setText:message];
    [message release];
}

-(void)serverSettingsHaveChanged:(NSNotification *)note
{
    [self setViewLabels];
}

#pragma mark - memory management

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
    [self initViewController];
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
