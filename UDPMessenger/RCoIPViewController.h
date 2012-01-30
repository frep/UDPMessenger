//
//  RCoIPViewController.h
//  UDPMessenger
//
//  Created by Pascal Frehner on 11.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "AppDelegate.h"
#import "RCTx.h"

@interface RCoIPViewController : UIViewController
{
    RCTx *rctx;
    
    IBOutlet UIButton *buttonTransmission;
    IBOutlet UISwitch *led1Switch;
    IBOutlet UILabel  *batteryLabel;
    IBOutlet UILabel  *batteryLegendLabel;
    
    IBOutlet UIButton *buttonUp;
    IBOutlet UIButton *buttonDown;
    IBOutlet UIButton *buttonLeft;
    IBOutlet UIButton *buttonRight;
    IBOutlet UISlider *sliderSpeed;
    
    IBOutlet UIButton *buttonGyroscopeMode;
    
    CMMotionManager   *motionManager;
    NSTimer           *gyroUpdateTimer;
    float             throttle;
    float             direction;
    uint8_t           motorValue;
    float             thresholdMove;
    IBOutlet UILabel  *labelGyro;
    
    BOOL              isTransmissionOn;
}

@property (retain, nonatomic) RCTx *rctx;
@property (retain, nonatomic) IBOutlet UIButton *buttonTransmission;
@property (retain, nonatomic) IBOutlet UISwitch *led1Switch;
@property (retain, nonatomic) IBOutlet UILabel  *batteryLabel;
@property (retain, nonatomic) IBOutlet UILabel  *batteryLegendLabel;
@property (retain, nonatomic) IBOutlet UIButton *buttonUp;
@property (retain, nonatomic) IBOutlet UIButton *buttonDown;
@property (retain, nonatomic) IBOutlet UIButton *buttonLeft;
@property (retain, nonatomic) IBOutlet UIButton *buttonRight;
@property (retain, nonatomic) IBOutlet UISlider *sliderSpeed;
@property (retain, nonatomic) IBOutlet UIButton *buttonGyroscopeMode;
@property (retain, nonatomic) NSTimer           *gyroUpdateTimer;
@property (retain, nonatomic) CMMotionManager   *motionManager;
@property (nonatomic)         float             throttle;
@property (nonatomic)         float             direction;
@property (nonatomic)         uint8_t           motorValue;
@property (nonatomic)         float             thresholdMove;
@property (retain, nonatomic) IBOutlet UILabel  *labelGyro;
@property (nonatomic)         BOOL              isTransmissionOn;

-(void)initRCoIPViewController;

-(IBAction)toggleTransmission:(id)sender;
-(void)startTransmission;
-(void)stopTransmission;

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

-(IBAction)toggleGyroUpdates:(id)sender;
-(void)doGyroUpdate;

-(uint8_t)getThrottleValue;
-(uint8_t)getDirectionValue;

@end
