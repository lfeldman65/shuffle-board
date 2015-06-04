//
//  ViewController.m
//  MiniGolf
//
//  Created by Larry Feldman on 5/25/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//
//      1   1   1   1   1
//      1   2   2   2   1
//      1   2  15   2   1
//      1   2   5   2   1
//      1   1   1   1   1


#import "ViewController.h"
#define swipeIncrement .001
#define speedScale 5
#define speedDamping .97
#define centerScore 15
#define ring1Score 2
#define ring2Score 1

@interface ViewController ()

@end


int score;
int shots;


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

@synthesize ball;

float swipeTime;

- (void)viewWillLayoutSubviews {
    
    // 5*targetSize + 2*sidePadding + 4*padding = sWidth
    
    [super viewWillLayoutSubviews];
    
    float sWidth = [UIScreen mainScreen].bounds.size.width;
    float sHeight = [UIScreen mainScreen].bounds.size.height;
    float sidePadding = .16*sWidth;                                  // space between sides and targets
    float padding = .06*sWidth;                                      // space between targets
    float targetSize = (sWidth - 2*sidePadding - 4*padding)/5;
    
    [self.bgImage setFrame:CGRectMake(0, 0, sWidth, sHeight)];
    self.bgImage.center = CGPointMake(.5*[UIScreen mainScreen].bounds.size.width, .5*[UIScreen mainScreen].bounds.size.height);
    
    [self.startButton setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 75)];
    self.startButton.center = CGPointMake(.1*[UIScreen mainScreen].bounds.size.width, .07*[UIScreen mainScreen].bounds.size.height);
    self.startButton.titleLabel.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    
    [self.scoreLabel setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 50)];
    self.scoreLabel.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    self.scoreLabel.center = CGPointMake(.35*[UIScreen mainScreen].bounds.size.width, .07*[UIScreen mainScreen].bounds.size.height);
    
    [self.shotLabel setFrame:CGRectMake(0, 0, .3*[UIScreen mainScreen].bounds.size.width, 50)];
    self.shotLabel.center = CGPointMake(.65*[UIScreen mainScreen].bounds.size.width, .07*[UIScreen mainScreen].bounds.size.height);
    self.shotLabel.font = [UIFont fontWithName: @"Papyrus" size: .03*[UIScreen mainScreen].bounds.size.width];
    
    [self.settingsButton setFrame:CGRectMake(0, 0, .07*[UIScreen mainScreen].bounds.size.width, .07*[UIScreen mainScreen].bounds.size.width)];
    self.settingsButton.center = CGPointMake(.9*[UIScreen mainScreen].bounds.size.width, 0.07*[UIScreen mainScreen].bounds.size.height);
    

    float col1X = sidePadding;
    float col2X = col1X + padding + targetSize;
    float col3X = col2X + padding + targetSize;
    float col4X = col3X + padding + targetSize;
    float col5X = col4X + padding + targetSize;
    
    float row1Y = .1*sHeight;
    float row2Y = row1Y + padding + targetSize;
    float row3Y = row2Y + padding + targetSize;
    float row4Y = row3Y + padding + targetSize;
    float row5Y = row4Y + padding + targetSize;
    
    [self.image1 setFrame:CGRectMake(col1X, row1Y, targetSize, targetSize)];
    [self.image2 setFrame:CGRectMake(col2X, row1Y, targetSize, targetSize)];
    [self.image3 setFrame:CGRectMake(col3X, row1Y, targetSize, targetSize)];
    [self.image4 setFrame:CGRectMake(col4X, row1Y, targetSize, targetSize)];
    [self.image5 setFrame:CGRectMake(col5X, row1Y, targetSize, targetSize)];
    
    [self.image6 setFrame:CGRectMake(col1X, row2Y, targetSize, targetSize)];
    [self.image7 setFrame:CGRectMake(col2X, row2Y, targetSize, targetSize)];
    [self.image8 setFrame:CGRectMake(col3X, row2Y, targetSize, targetSize)];
    [self.image9 setFrame:CGRectMake(col4X, row2Y, targetSize, targetSize)];
    [self.image10 setFrame:CGRectMake(col5X, row2Y, targetSize, targetSize)];
    
    [self.image11 setFrame:CGRectMake(col1X, row3Y, targetSize, targetSize)];
    [self.image12 setFrame:CGRectMake(col2X, row3Y, targetSize, targetSize)];
    [self.image13 setFrame:CGRectMake(col3X, row3Y, targetSize, targetSize)];
    [self.image14 setFrame:CGRectMake(col4X, row3Y, targetSize, targetSize)];
    [self.image15 setFrame:CGRectMake(col5X, row3Y, targetSize, targetSize)];
    
    [self.image16 setFrame:CGRectMake(col1X, row4Y, targetSize, targetSize)];
    [self.image17 setFrame:CGRectMake(col2X, row4Y, targetSize, targetSize)];
    [self.image18 setFrame:CGRectMake(col3X, row4Y, targetSize, targetSize)];
    [self.image19 setFrame:CGRectMake(col4X, row4Y, targetSize, targetSize)];
    [self.image20 setFrame:CGRectMake(col5X, row4Y, targetSize, targetSize)];
    
    [self.image21 setFrame:CGRectMake(col1X, row5Y, targetSize, targetSize)];
    [self.image22 setFrame:CGRectMake(col2X, row5Y, targetSize, targetSize)];
    [self.image23 setFrame:CGRectMake(col3X, row5Y, targetSize, targetSize)];
    [self.image24 setFrame:CGRectMake(col4X, row5Y, targetSize, targetSize)];
    [self.image25 setFrame:CGRectMake(col5X, row5Y, targetSize, targetSize)];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.ball.hidden = YES;
    shots = 0;
    score = 0;

}

- (IBAction)newGamePressed:(id)sender {
    
    [self newGame];
    
}

- (void)newGame {
    
    if(shots>0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game in Progress" message:@"Are you sure you want to start a new game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
        alertView.tag = 1;
        [alertView show];
        
    } else {
    
        self.ball.hidden = NO;
        score = 0;
        shots = 0;
        
        self.scoreLabel.text = @"Score: 0";
        self.shotLabel.text = @"Shots: 0";
        
        [self placeBall];
    }
}

-(void)placeBall {
    
    if (self.placeBallTimer.isValid) {
        [self.placeBallTimer invalidate];
    }
    
    [self.view setUserInteractionEnabled:YES];
    
    int sWidthInt = [UIScreen mainScreen].bounds.size.width;
    int xPosition = arc4random() % sWidthInt;
    
    self.ball.center = CGPointMake(xPosition, .95*[UIScreen mainScreen].bounds.size.height);
    
   // self.ball.center = CGPointMake(self.image24.frame.origin.x, self.image24.frame.origin.y);


}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self.view setUserInteractionEnabled:NO];
    self.firstPoint = [touch locationInView:self.view];
    swipeTime = 0;
    
    self.overlapArray = [NSMutableArray arrayWithObjects:nil];
    
    for (int i = 0; i < 25; i++) {
        
        [self.overlapArray addObject:@"false"];
        
    }
    
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
    
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];

}

- (void)swipeDuration {
    
    swipeTime = swipeTime + swipeIncrement;
    
}


-(void)moveBall {
    
    self.ballVelocityX = speedDamping*self.ballVelocityX;
    self.ballVelocityY = speedDamping*self.ballVelocityY;

    self.ball.center = CGPointMake(self.ball.center.x + self.ballVelocityX, self.ball.center.y + self.ballVelocityY);
    
    if(fabs(self.ballVelocityX) < 5 && fabs(self.ballVelocityY) < 5) {
        
        [self.gameTimer invalidate];
        
        [self checkOverlap];

    }
}


- (void)checkOverlap {
    
    if (CGRectIntersectsRect(self.ball.frame, self.image1.frame)) {
        
        self.overlapArray[0] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image2.frame)) {
        
        self.overlapArray[1] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image3.frame)) {
        
        self.overlapArray[2] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image4.frame)) {
        
        self.overlapArray[3] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image5.frame)) {
        
        self.overlapArray[4] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image6.frame)) {
        
        self.overlapArray[5] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image7.frame)) {
        
        self.overlapArray[6] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image8.frame)) {
        
        self.overlapArray[7] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image9.frame)) {
        
        self.overlapArray[8] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image10.frame)) {
        
        self.overlapArray[9] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image11.frame)) {
        
        self.overlapArray[10] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image12.frame)) {
        
        self.overlapArray[11] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image13.frame)) {
        
        self.overlapArray[12] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image14.frame)) {
        
        self.overlapArray[13] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image15.frame)) {
        
        self.overlapArray[14] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image16.frame)) {
        
        self.overlapArray[15] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image17.frame)) {
        
        self.overlapArray[16] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image18.frame)) {
        
        self.overlapArray[17] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image19.frame)) {
        
        self.overlapArray[18] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image20.frame)) {
        
        self.overlapArray[19] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image21.frame)) {
        
        self.overlapArray[20] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image22.frame)) {
        
        self.overlapArray[21] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image23.frame)) {
        
        self.overlapArray[22] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image24.frame)) {
        
        self.overlapArray[23] = @"true";
        
    }
    
    if (CGRectIntersectsRect(self.ball.frame, self.image25.frame)) {
        
        self.overlapArray[24] = @"true";
        
    }

    [self getScore];
    
}

- (void)getScore {
    

    shots++;
    
    
    if ([self.overlapArray[0] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[1] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[2] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[3] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[4] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[5] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[6] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[7] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[8] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[9] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[10] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[11] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[12] isEqualToString:@"true"]) {
        
        score = score + centerScore;
        
    }
    
    if ([self.overlapArray[13] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[14] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[15] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[16] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[17] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[18] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[19] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[20] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[21] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[22] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[23] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }
    
    if ([self.overlapArray[24] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
    }

    NSString *scoreString = [NSString stringWithFormat:@"Score: %i", score];
    self.scoreLabel.text = scoreString;
    
    NSString *shotString = [NSString stringWithFormat:@"Shots: %i", shots];
    self.shotLabel.text = shotString;
    
    if (shots >= 10) {
        
        [self.view setUserInteractionEnabled:YES];
        self.ball.hidden = YES;

    } else {
        
        self.placeBallTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(placeBall) userInfo:nil repeats:NO];

    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            break;
            
        }
            
        case 1: {
            shots = 0;
            [self newGame];
            break;
            
        }
            
        default: {
            break;
        }
    }
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
