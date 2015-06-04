//
//  ViewController.h
//  MiniGolf
//
//  Created by Larry Feldman on 5/25/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreMotion/CoreMotion.h>
//#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>


@interface ViewController : UIViewController

@property (nonatomic) CGPoint firstPoint;
@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint shotVectorUnit;

@property (nonatomic) float ballVelocityX;
@property (nonatomic) float ballVelocityY;

@property (strong, nonatomic) NSTimer *swipeTimer;
@property (strong, nonatomic) NSTimer *gameTimer;
@property (strong, nonatomic) NSTimer *placeBallTimer;

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;
@property (strong, nonatomic) IBOutlet UIImageView *image6;
@property (strong, nonatomic) IBOutlet UIImageView *image7;
@property (strong, nonatomic) IBOutlet UIImageView *image8;
@property (strong, nonatomic) IBOutlet UIImageView *image9;
@property (strong, nonatomic) IBOutlet UIImageView *image10;
@property (strong, nonatomic) IBOutlet UIImageView *image11;
@property (strong, nonatomic) IBOutlet UIImageView *image12;
@property (strong, nonatomic) IBOutlet UIImageView *image13;
@property (strong, nonatomic) IBOutlet UIImageView *image14;
@property (strong, nonatomic) IBOutlet UIImageView *image15;
@property (strong, nonatomic) IBOutlet UIImageView *image16;
@property (strong, nonatomic) IBOutlet UIImageView *image17;
@property (strong, nonatomic) IBOutlet UIImageView *image18;
@property (strong, nonatomic) IBOutlet UIImageView *image19;
@property (strong, nonatomic) IBOutlet UIImageView *image20;
@property (strong, nonatomic) IBOutlet UIImageView *image21;
@property (strong, nonatomic) IBOutlet UIImageView *image22;
@property (strong, nonatomic) IBOutlet UIImageView *image23;
@property (strong, nonatomic) IBOutlet UIImageView *image24;
@property (strong, nonatomic) IBOutlet UIImageView *image25;

@property (strong, nonatomic) IBOutlet UIImageView *ball;

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *shotLabel;

@property (strong, nonatomic) NSMutableArray *overlapArray;

- (IBAction)newGamePressed:(id)sender;

@end

