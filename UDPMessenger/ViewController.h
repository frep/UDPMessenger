//
//  ViewController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 31.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController
{
    IBOutlet UILabel     *localIpLabel;
    IBOutlet UILabel     *serverIpLabel;
    IBOutlet UILabel     *portLabel;
    IBOutlet UITextField *messageTextField;
    IBOutlet UILabel     *receivedMessageLabel;
    
    AppDelegate          *appDelegate;
    
}

@property (retain, nonatomic) UILabel       *localIpLabel;
@property (retain, nonatomic) UILabel       *serverIpLabel;
@property (retain, nonatomic) UILabel       *portLabel;
@property (retain, nonatomic) UITextField   *messageTextField;
@property (retain, nonatomic) UILabel       *receivedMessageLabel;
@property (retain, nonatomic) AppDelegate   *appDelegate;

-(IBAction)sendButtonPushed:(id)sender;
-(IBAction)hideKeyboard:(id)sender;

-(void)initViewController;
-(void)setViewLabels;

// methods called by observer-notifications 
-(void)processReceivedData:(NSNotification *)note;
-(void)serverSettingsHaveChanged:(NSNotification *)note;


@end
