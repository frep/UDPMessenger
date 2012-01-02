//
//  ViewController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 31.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDPController.h"

@interface ViewController : UIViewController
{
    IBOutlet UILabel     *localIpLabel;
    IBOutlet UILabel     *serverIpLabel;
    IBOutlet UILabel     *portLabel;
    IBOutlet UITextField *messageTextField;
    IBOutlet UILabel     *receivedMessageLabel;
    
    UDPController        *udpController;
}

@property (retain, nonatomic) UILabel       *localIpLabel;
@property (retain, nonatomic) UILabel       *serverIpLabel;
@property (retain, nonatomic) UILabel       *portLabel;
@property (retain, nonatomic) UITextField   *messageTextField;
@property (retain, nonatomic) UILabel       *receivedMessageLabel;
@property (retain, nonatomic) UDPController *udpController;

-(IBAction)sendButtonPushed:(id)sender;
-(IBAction)hideKeyboard:(id)sender;

-(void)initController;
-(void)processReceivedData:(NSNotification *)note;


@end
