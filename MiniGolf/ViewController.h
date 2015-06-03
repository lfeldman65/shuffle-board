//
//  ViewController.h
//  MiniGolf
//
//  Created by Larry Feldman on 5/25/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>



@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *cup;
@property (strong, nonatomic) IBOutlet UIImageView *ball;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *verWall;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *horWall;


@property (nonatomic) CGPoint firstPoint;
@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) CGPoint shotVectorUnit;

@property (nonatomic) float ballVelocityX;
@property (nonatomic) float ballVelocityY;

@property (strong, nonatomic) NSTimer *swipeTimer;
@property (strong, nonatomic) NSTimer *gameTimer;








@end

