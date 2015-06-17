//
//  ViewController.m
//  MiniGolf
//
//  Created by Larry Feldman on 5/25/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.


#import "ViewController.h"
#define swipeIncrement .001
#define speedScale .2
#define speedDamping .95
#define centerScore 50
#define ring1Score 10
#define ring2Score -5
#define maxShots 10
#define numTargets 25

@interface ViewController ()

@end


int score;
int shots;
float sliderValue;


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
    
    int iAdHeight;
    
    [super viewWillLayoutSubviews];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        iAdHeight = 66;
    }
    else {
        
        iAdHeight = 50;
    }
    
    float sWidth = [UIScreen mainScreen].bounds.size.width;
    float sHeight = [UIScreen mainScreen].bounds.size.height;
    float sidePadding = .08*sWidth;                                  // space between sides and targets
    float padding = .11*sWidth;                                      // space between targets
    float targetSize = (sWidth - 2*sidePadding - 4*padding)/5;
    
    [self.bgImage setFrame:CGRectMake(0, 0, sWidth, sHeight)];
    self.bgImage.center = CGPointMake(.5*sWidth, .5*sHeight);
    
    [self.startButton setFrame:CGRectMake(0, 0, .3*sWidth,.07*sHeight)];
    self.startButton.center = CGPointMake(.12*sWidth, .07*sHeight);
    self.startButton.titleLabel.font = [UIFont fontWithName: @"Marker Felt" size: .04*sWidth];
    
    [self.scoreLabel setFrame:CGRectMake(0, 0, .3*sWidth, 50)];
    self.scoreLabel.font = [UIFont fontWithName: @"Marker Felt" size: .04*sWidth];
    self.scoreLabel.center = CGPointMake(.37*sWidth, .07*sHeight);
    
    [self.shotLabel setFrame:CGRectMake(0, 0, .3*sWidth, 50)];
    self.shotLabel.center = CGPointMake(.63*sWidth, .07*sHeight);
    self.shotLabel.font = [UIFont fontWithName: @"Marker Felt" size: .04*sWidth];
    
    [self.ngLabel setFrame:CGRectMake(0, 0, sWidth, 75)];
    self.ngLabel.font = [UIFont fontWithName: @"Marker Felt" size: .05*sWidth];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
         self.ngLabel.center = CGPointMake(.5*sWidth, .85*sHeight);
        
    }
    else {
        
         self.ngLabel.center = CGPointMake(.5*sWidth, .78*sHeight);
        
    }

    
    [self.settingsButton setFrame:CGRectMake(0, 0, .4*sWidth, .07*sHeight)];
    self.settingsButton.center = CGPointMake(.88*sWidth, 0.07*[UIScreen mainScreen].bounds.size.height);
    self.settingsButton.titleLabel.font = [UIFont fontWithName: @"Marker Felt" size: .04*sWidth];
    
    [self.iAdOutlet setFrame:CGRectMake(0, sHeight - iAdHeight, sWidth, iAdHeight)];
    

    float col1X = sidePadding;
    float col2X = col1X + padding + targetSize;
    float col3X = col2X + padding + targetSize;
    float col4X = col3X + padding + targetSize;
    float col5X = col4X + padding + targetSize;
    
    float row1Y = .12*sHeight;
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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"wasGameLaunched"]) {
        
        NSString *infoString = @"Swipe the puck to get it moving. The length and direction of your swipe determine the speed and direction of the puck. Land on the green square for big points! Go to the Settings screen for complete instructions.";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bullz Eye" message:infoString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"wasGameLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        [self.ball setFrame:CGRectMake(0, 0, 40, 40)];
        
    }
    else {
        
        [self.ball setFrame:CGRectMake(0, 0, 20, 20)];
        
    }
    
    // Game Center
    
    [[GameCenterManager sharedManager] setDelegate:self];
    BOOL available = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    if (available) {
        NSLog(@"available");
    } else {
        NSLog(@"not available");
    }
    
    [[GKLocalPlayer localPlayer] authenticateHandler];
  /*  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bullz Eye!" message:nil delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
    alertView.tag = 2;
    [alertView show];*/
    
    self.ball.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(soundChanged:)
                                                 name:@"soundDidChange"
                                               object:nil];
    
    self.redSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"ohh"ofType:@"mp3"]] error:NULL];
    [self.redSound prepareToPlay];
    
    self.greenSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"applause"ofType:@"mp3"]] error:NULL];
    [self.greenSound prepareToPlay];
    
     self.slideSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"slide"ofType:@"mp3"]] error:NULL];
    [self.slideSound prepareToPlay];
    
    self.backgroundSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"birds2"ofType:@"mp3"]] error:NULL];
    [self.backgroundSound prepareToPlay];
    self.backgroundSound.numberOfLoops = -1;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
        [self.backgroundSound play];
    }
}


-(void)settingsDidFinish:(SettingsViewController *)controller {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)soundChanged:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:@"soundDidChange"]) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
            
            [self.backgroundSound prepareToPlay];
            [self.backgroundSound play];
            
        } else {
            
            [self.backgroundSound stop];
        }
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"toSettings"]){
        SettingsViewController *svc = (SettingsViewController *)[segue destinationViewController];
        svc.delegate = self;
    }
    
}


- (IBAction)newGamePressed:(id)sender {
    
    if (shots == 0 || shots == maxShots){
        
        [self newGame];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game in Progress" message:@"Are you sure you want to start a new game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
        alertView.tag = 1;
        [alertView show];
    }

}

- (void)newGame {
    
    self.iAdOutlet.hidden = YES;
    self.ngLabel.hidden = YES;
    self.ball.hidden = NO;
    score = 0;
    shots = 0;
    
    self.scoreLabel.text = @"Score: 0";
    self.shotLabel.text = @"Shots: 0";
    [self placeBall];
    
}

-(void)placeBall {
    
    if (self.placeBallTimer.isValid) {
        [self.placeBallTimer invalidate];
    }
    
    [self.view setUserInteractionEnabled:YES];
    
    int sWidthInt = [UIScreen mainScreen].bounds.size.width - self.ball.frame.size.width;
    int xPosition = (arc4random() % sWidthInt) + self.ball.frame.size.width/2;
    
    int yMax = .97*[UIScreen mainScreen].bounds.size.height;
    int yMin = .78*[UIScreen mainScreen].bounds.size.height;
    int yPosition = (arc4random() % (yMax - yMin)) + yMin;

    self.ball.center = CGPointMake(xPosition, yPosition);
    
    if (shots >= maxShots) {
        
        self.ngLabel.hidden = NO;

        NSInteger best = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
        
        if (score > best) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"highScore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[GameCenterManager sharedManager] saveAndReportScore:(int)score leaderboard:@"HighScore" sortOrder:GameCenterSortOrderHighToLow];
            
        }
        
        if (score >= 300 && score < 400) {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"300points" percentComplete:100 shouldDisplayNotification:YES];
        }
        
        if (score >= 400 && score < 500) {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"400points" percentComplete:100 shouldDisplayNotification:YES];
        }
        
        if (score >= 500) {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"perfectGame" percentComplete:100 shouldDisplayNotification:YES];
        }
        

        self.iAdOutlet.hidden = NO;
        self.ball.hidden = YES;
      /*  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message:nil delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
        alertView.tag = 2;
        [alertView show];*/
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (shots < maxShots) {
        
        UITouch *touch = [touches anyObject];
        [self.view setUserInteractionEnabled:NO];
        self.firstPoint = [touch locationInView:self.view];
        swipeTime = 0;
        
        self.overlapArray = [NSMutableArray arrayWithObjects:nil];
        
        for (int i = 0; i < numTargets; i++) {
            
            [self.overlapArray addObject:@"false"];
            
        }
    //    self.swipeTimer = [NSTimer scheduledTimerWithTimeInterval:swipeIncrement target:self selector:@selector(swipeDuration) userInfo:nil repeats:YES];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
 //   NSInteger speed = [[NSUserDefaults standardUserDefaults] integerForKey:@"swipeSpeed"];
    
    [self.swipeTimer invalidate];
    
  //  NSLog(@"the timer stops at %f seconds", swipeTime);

    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.view];
    
    CGPoint tapVector = rwSub(self.lastPoint, self.firstPoint); // (vector) last point - first point
    
  //  NSLog(@"tapVector = %f %f", tapVector.x, tapVector.y);
    
    self.shotVectorUnit = rwNormalize(tapVector);       // unit length 1
    
    self.ballVelocityX = speedScale*tapVector.x;
    self.ballVelocityY = speedScale*tapVector.y;
    
    if (shots < maxShots) {
    
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
        
    }

}

- (void)swipeDuration {
    
    swipeTime = swipeTime + swipeIncrement;
    
}


-(void)moveBall {
    
    self.ballVelocityX = speedDamping*self.ballVelocityX;
    self.ballVelocityY = speedDamping*self.ballVelocityY;

    self.ball.center = CGPointMake(self.ball.center.x + self.ballVelocityX, self.ball.center.y + self.ballVelocityY);
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
        [self.slideSound play];
    }
    
    if(fabs(self.ballVelocityX) < 5 && fabs(self.ballVelocityY) < 5) {
        
        [self.slideSound stop];
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
    
   // NSLog(@"overlap = %@", self.overlapArray);

    [self getScore];
    
}

- (void)getScore {
    

    shots++;
    
    
    if ([self.overlapArray[0] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
    }
    
    if ([self.overlapArray[1] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[2] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[3] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[4] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[5] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
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
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[10] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[11] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[12] isEqualToString:@"true"]) {
        
        score = score + centerScore;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.greenSound play];
        }
        
    }
    
    if ([self.overlapArray[13] isEqualToString:@"true"]) {
        
        score = score + ring1Score;
        
    }
    
    if ([self.overlapArray[14] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[15] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
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
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[20] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[21] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[22] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[23] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }
    
    if ([self.overlapArray[24] isEqualToString:@"true"]) {
        
        score = score + ring2Score;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isSoundOn"]){
            [self.redSound play];
        }
        
    }

    NSString *scoreString = [NSString stringWithFormat:@"Score: %i", score];
    self.scoreLabel.text = scoreString;
    
    NSString *shotString = [NSString stringWithFormat:@"Shots: %i", shots];
    self.shotLabel.text = shotString;
    
    [self.view setUserInteractionEnabled:YES];
    
    self.placeBallTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(placeBall) userInfo:nil repeats:NO];


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 1) {
    
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
    
    if(alertView.tag == 2) {
        
        switch (buttonIndex) {
            case 0: {
                shots = 0;
                [self newGame];
                break;
            }
                
            default: {
                break;
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

# pragma mark - Game Center


- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {
    NSLog(@"GC Availabilty: %@", availabilityInformation);
    if ([[availabilityInformation objectForKey:@"status"] isEqualToString:@"GameCenter Available"]) {
        
        NSLog(@"Game Center is online, the current player is logged in, and this app is setup.");
        
    } else {
        
        //   NSLog(@"error here1");
    }
    
}

- (void)gameCenterManager:(GameCenterManager *)manager error:(NSError *)error {
    NSLog(@"GCM Error: %@", error);
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Achievement: %@", achievement);
    } else {
        NSLog(@"GCM Error while reporting achievement: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager reportedScore:(GKScore *)score withError:(NSError *)error {
    if (!error) {
        NSLog(@"GCM Reported Score: %@", score);
    } else {
        NSLog(@"GCM Error while reporting score: %@", error);
    }
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveScore:(GKScore *)score {
    NSLog(@"Saved GCM Score with value: %lld", score.value);
}

- (void)gameCenterManager:(GameCenterManager *)manager didSaveAchievement:(GKAchievement *)achievement {
    NSLog(@"Saved GCM Achievement: %@", achievement);
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (gameCenterViewController.viewState == GKGameCenterViewControllerStateAchievements) {
        NSLog(@"Displayed GameCenter achievements.");
    } else if (gameCenterViewController.viewState == GKGameCenterViewControllerStateLeaderboards) {
        NSLog(@"Displayed GameCenter leaderboard.");
    } else {
        NSLog(@"Displayed GameCenter controller.");
    }
}

-(void) showLeaderboard {
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
}

- (void) loadChallenges {
    // This feature is only supported in iOS 6 and higher (don't worry - GC Manager will check for you and return NIL if it isn't available)
    [[GameCenterManager sharedManager] getChallengesWithCompletion:^(NSArray *challenges, NSError *error) {
        NSLog(@"GC Challenges: %@ | Error: %@", challenges, error);
    }];
}

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        NSLog(@"Finished Presenting Authentication Controller");
    }];
}


#pragma mark - iAd

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];


}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
    
}


@end

