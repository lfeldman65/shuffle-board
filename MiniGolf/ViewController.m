//
//  ViewController.m
//  MiniGolf
//
//  Created by Larry Feldman on 5/25/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "ViewController.h"
#define swipeIncrement .001
#define speedScale 20

@interface ViewController ()


@property (nonatomic, strong) UIView *square;
@property (nonatomic, strong) UIView *animationView;

@end



static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}


static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector with a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    if (length == 0) {
        length = 1;
    }
    return CGPointMake(a.x / length, a.y / length);
}


@implementation ViewController

@synthesize square;
@synthesize ballLayer;

float swipeTime;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    square = [[UIView alloc] initWithFrame: CGRectMake(100, 100, 100, 100)];
    square.backgroundColor = [UIColor grayColor];
    [self.view addSubview:square];
    
    UIView* barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
   // [self.view setUserInteractionEnabled:NO];
    self.firstPoint = [touch locationInView:self.view];
    NSLog(@"touches began");
    swipeTime = 0;
    
    self.swipeTimer = [NSTimer scheduledTimerWithTimeInterval:swipeIncrement target:self selector:@selector(swipeDuration) userInfo:nil repeats:YES];


}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.swipeTimer invalidate];
    
    NSLog(@"the timer stops at %f seconds", swipeTime);

    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.view];
    
    CGPoint tapVector = rwSub(self.lastPoint, self.firstPoint); // (vector) last point - first point
    
    NSLog(@"tapVector = %f %f", tapVector.x, tapVector.y);
    
    self.shotVectorUnit = rwNormalize(tapVector);       // unit length 1
    
    self.ballVelocityX = speedScale*self.shotVectorUnit.x/swipeTime;
    self.ballVelocityY = speedScale*self.shotVectorUnit.y/swipeTime;
    
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(gameGuts) userInfo:nil repeats:YES];

}

- (void)swipeDuration {
    
    swipeTime = swipeTime + swipeIncrement;
    
}


-(void)gameGuts {
    
    self.ballVelocityX = .8*self.ballVelocityX;
    self.ballVelocityY = .8*self.ballVelocityY;

    self.square.center = CGPointMake(self.square.center.x + self.ballVelocityX, self.square.center.y + self.ballVelocityY);
    
    [self collisionWithBoundaries];
    [self outOfSteam];

    
    /*if (CGRectIntersectsRect(self.ball.frame, self.cup.frame)) {
    
       self.ball.hidden = YES;
       [self.ball removeFromSuperview];
    
    }*/
}

- (void)collisionWithBoundaries {
    
    if (self.square.center.x < 0) {
        self.square.center = CGPointMake(0, self.square.center.y);

        self.ballVelocityX = -(self.ballVelocityX / 2.0);
    }
    
    if (self.square.center.x > self.view.bounds.size.width) {
        self.square.center = CGPointMake(self.view.bounds.size.width, self.square.center.y);

         self.ballVelocityX = -(self.ballVelocityX / 2.0);
    }
    
    if (self.square.center.y < 0) {
        self.square.center = CGPointMake(self.square.center.x, 0);
        
        self.ballVelocityY = -(self.ballVelocityY / 2.0);

    }
    
    if (self.square.center.y > self.view.bounds.size.height) {
        self.square.center = CGPointMake(self.square.center.x, self.view.bounds.size.height);

        self.ballVelocityY = -(self.ballVelocityY / 2.0);
    }
    
}

- (void)outOfSteam {
    
    if(fabs(self.ballVelocityX) < 5 && fabs(self.ballVelocityY) < 5) {
        
        [self.gameTimer invalidate];
        NSLog(@"out of steam");
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
