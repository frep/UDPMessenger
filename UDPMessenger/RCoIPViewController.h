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
    
    IBOutlet UIButton *buttonUp;
    IBOutlet UIButton *buttonDown;
    IBOutlet UIButton *buttonLeft;
    IBOutlet UIButton *buttonRight;
    IBOutlet UISlider *sliderSpeed;
}

@property (retain, nonatomic) RCTx *rctx;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UIButton *stopButton;
@property (retain, nonatomic) IBOutlet UISwitch *led1Switch;
@property (retain, nonatomic) IBOutlet UILabel  *batteryLabel;
@property (retain, nonatomic) IBOutlet UILabel  *batteryLegendLabel;
@property (retain, nonatomic) IBOutlet UIButton *buttonUp;
@property (retain, nonatomic) IBOutlet UIButton *buttonDown;
@property (retain, nonatomic) IBOutlet UIButton *buttonLeft;
@property (retain, nonatomic) IBOutlet UIButton *buttonRight;
@property (retain, nonatomic) IBOutlet UISlider *sliderSpeed;

-(void)initRCoIPViewController;

-(IBAction)startTransmission;
-(IBAction)stopTransmission;

-(IBAction)led1SwitchValueChanged:(id)sender;

-(IBAction)buttonUpPushed:(id)sender;
-(IBAction)buttonDownPushed:(id)sender;
-(IBAction)buttonLeftPushed:(id)sender;
-(IBAction)buttonRightPushed:(id)sender;
-(IBAction)buttonUpReleased:(id)sender;
-(IBAction)buttonDownReleased:(id)sender;
-(IBAction)buttonLeftReleased:(id)sender;
-(IBAction)buttonRightReleased:(id)sender;

-(void)moveForward;
-(void)moveBackward;
-(void)turnLeft;
-(void)turnRight;
-(void)stopMoving;

-(void)processReceivedData:(NSNotification *)note;

@end
