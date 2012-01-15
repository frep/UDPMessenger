//
//  RCoIPViewController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 11.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RCTx.h"

@interface RCoIPViewController : UIViewController
{
    RCTx *rctx;
    
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *stopButton;
    IBOutlet UISwitch *led1Switch;
    IBOutlet UILabel  *batteryLabel;
    IBOutlet UILabel  *batteryLegendLabel;
}

@property (retain, nonatomic) RCTx *rctx;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UISwitch *led1Switch;
@property (retain, nonatomic) IBOutlet UILabel  *batteryLabel;
@property (retain, nonatomic) IBOutlet UILabel  *batteryLegendLabel;

-(void)initRCoIPViewController;

-(IBAction)startTransmission;
-(IBAction)stopTransmission;

-(IBAction)led1SwitchValueChanged:(id)sender;

-(void)processReceivedData:(NSNotification *)note;

@end
