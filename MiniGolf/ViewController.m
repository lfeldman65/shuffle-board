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

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collider;
@property (nonatomic, strong) UIDynamicItemBehavior *elastic;

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
@synthesize ball;

float swipeTime;

- (void)viewDidLoad {
    
    [super viewDidLoad];

  }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self.view setUserInteractionEnabled:NO];
    self.firstPoint = [touch locationInView:self.view];
    NSLog(@"touches began");
    swipeTime = 0;
    
    self.swipeTimer = [NSTimer scheduledTimerWithTimeInterval:swipeIncrement target:self selector:@selector(swipeDuration) userInfo:nil repeats:YES];

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.swipeTimer invalidate];
    
    NSLog(@"the timer stops at %f seconds", swipeTime);

    UITouch *touch = [touches anyObject];//
    self.lastPoint = [touch locationInView:self.view];
    
    CGPoint tapVector = rwSub(self.lastPoint, self.firstPoint); // (vector) last point - first point
    
    NSLog(@"tapVector = %f %f", tapVector.x, tapVector.y);
    
    self.shotVectorUnit = rwNormalize(tapVector);       // unit length 1
    
    self.ballVelocityX = speedScale*self.shotVectorUnit.x/swipeTime;
    self.ballVelocityY = speedScale*self.shotVectorUnit.y/swipeTime;
    
    [self.gravity addItem:self.ball];
    [self.collider addItem:self.ball];
    
    [self.motionManager startAccelerometerUpdates];
    
    //  self.ballVelocityY = self.motionManager.accelerometerData.acceleration.y;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelData, NSError *error) {
        
        CGFloat x = accelData.acceleration.x;
        
        CGFloat y = accelData.acceleration.y;
        NSLog(@"here");
        
        self.gravity.gravityDirection = CGVectorMake(self.ballVelocityX, self.ballVelocityY);
        
    }];

    
 //   self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];

}

- (void)swipeDuration {
    
    NSLog(@"swipe duration");
    swipeTime = swipeTime + swipeIncrement;
    
}


-(void)moveBall {
    
    self.ballVelocityX = .8*self.ballVelocityX;
    self.ballVelocityY = .8*self.ballVelocityY;

    self.ball.center = CGPointMake(self.ball.center.x + self.ballVelocityX, self.ball.center.y + self.ballVelocityY);
    
 //   [self inTheCup];
 //   [self collisionWithBoundaries];
 //   [self collisionWithWalls];
 //   [self outOfSteam];

}

- (void)collisionWithBoundaries {
    
    if (self.ball.center.x < 0) {
        self.ball.center = CGPointMake(0, self.ball.center.y);

        self.ballVelocityX = -(.8*self.ballVelocityX);
    }
    
    if (self.ball.center.x > self.view.bounds.size.width) {
        self.ball.center = CGPointMake(self.view.bounds.size.width, self.ball.center.y);

         self.ballVelocityX = -(.8*self.ballVelocityX);
    }
    
    if (self.ball.center.y < 0) {
        self.ball.center = CGPointMake(self.ball.center.x, 0);
        
        self.ballVelocityY = -(.8*self.ballVelocityY);

    }
    
    if (self.ball.center.y > self.view.bounds.size.height) {
        self.ball.center = CGPointMake(self.ball.center.x, self.view.bounds.size.height);

        self.ballVelocityY = -(.8*self.ballVelocityY);
    }
    
}


- (void)collisionWithWalls {
    
    
    for (UIImageView *image1 in self.verWall) {
        
        if (CGRectIntersectsRect(self.ball.frame, image1.frame)) {
            self.ballVelocityX = -(self.ballVelocityX);
        }
    }
    
    for (UIImageView *image2 in self.horWall) {
        
        if (CGRectIntersectsRect(self.ball.frame, image2.frame)) {
            self.ballVelocityY = -(self.ballVelocityY);
        }
    }
}



- (void)inTheCup {
    
    if (CGRectIntersectsRect(self.ball.frame, self.cup.frame)) {
        
        [self.gameTimer invalidate];
        self.ball.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                        message:@"You've won the game!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}


- (void)outOfSteam {
    
    if(fabs(self.ballVelocityX) < 5 && fabs(self.ballVelocityY) < 5) {
        
        [self.gameTimer invalidate];
        [self.view setUserInteractionEnabled:YES];

        NSLog(@"out of steam");
        
    }
    
}

- (CMMotionManager *)motionManager {
    
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.1;

    }
    return _motionManager;
}

- (UIDynamicAnimator *)animator {
    
    if(!_animator) {
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
    
}

- (UICollisionBehavior *)collider {
    
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
        [_animator addBehavior:_collider];
        
    }
    return _collider;
}


- (UIGravityBehavior *)gravity {
    
    if (!_gravity) {
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
        [self.animator addBehavior:gravity];
        self.gravity = gravity;
    }
    return _gravity;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
