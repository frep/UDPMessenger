//
//  TerminalViewController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TerminalViewController : UIViewController
{

    IBOutlet UIButton    *buttonClear;
    IBOutlet UIButton    *buttonSend;
    IBOutlet UIButton    *buttonStartStop;
    IBOutlet UITextView  *textViewTerminal;
    IBOutlet UITextField *textFieldMessage;
    
    AppDelegate          *appDelegate;
    bool                 receivingIsStopped;
    
}

@property (retain, nonatomic) UIButton    *buttonClear;
@property (retain, nonatomic) UIButton    *buttonSend;
@property (retain, nonatomic) UIButton    *buttonStartStop;
@property (retain, nonatomic) UITextView  *textViewTerminal;
@property (retain, nonatomic) UITextField *textFieldMessage;
@property (retain, nonatomic) AppDelegate *appDelegate;
@property (nonatomic)         bool        receivingIsStopped;

-(IBAction)buttonSendPushed:(id)sender;
-(IBAction)buttonClearPushed:(id)sender;
-(IBAction)buttonStartStopPushed:(id)sender;
-(IBAction)hideKeyboard:(id)sender;

-(void)initTerminalViewController;

-(void)clearTerminal;
-(void)sendUDPMessage:(NSString*)message;
-(void)toggleStartStop;
-(void)startReceiving;
-(void)stopReceiving;

// methods called by observer-notifications 
-(void)processReceivedData:(NSNotification *)note;

@end
