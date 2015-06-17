//
//  ViewController.h
//  MiniGolf
//
//  Created by Larry Feldman on 5/25/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SettingsViewController.h"


@interface ViewController : UIViewController <SettingsDelegate, ADBannerViewDelegate, GameCenterManagerDelegate>

@property (nonatomic) CGPoint firstPoint;
@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint shotVectorUnit;

@property (nonatomic) float ballVelocityX;
@property (nonatomic) float ballVelocityY;

@property (nonatomic) int tiltSpeed;

@property (strong, nonatomic) NSTimer *swipeTimer;
@property (strong, nonatomic) NSTimer *gameTimer;
@property (strong, nonatomic) NSTimer *placeBallTimer;

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;

@property (strong, nonatomic) IBOutlet UIImageView *leftTilt;
@property (strong, nonatomic) IBOutlet UIImageView *rightTilt;
@property (strong, nonatomic) IBOutlet UIImageView *image3;

@property (strong, nonatomic) IBOutlet UIImageView *ball;

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *shotLabel;
@property (strong, nonatomic) IBOutlet UILabel *ngLabel;
@property (strong, nonatomic) IBOutlet UILabel *tiltLabel;

@property (weak, nonatomic) IBOutlet ADBannerView *iAdOutlet;

@property (strong, nonatomic) NSMutableArray *overlapArray;

@property (nonatomic, strong) AVAudioPlayer *redSound;
@property (nonatomic, strong) AVAudioPlayer *slideSound;
@property (nonatomic, strong) AVAudioPlayer *greenSound;
@property (nonatomic, strong) AVAudioPlayer *backgroundSound;

- (IBAction)newGamePressed:(id)sender;


@end

