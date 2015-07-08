//
//  ViewController.m
//  MiniGolf
//
//  Created by Larry Feldman on 5/25/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.


#import "ViewController.h"
#define swipeIncrement .001
#define speedScale .20
#define speedDamping .98
#define maxShots 10
#define horTol .6
#define verTol .2

@interface ViewController ()

@end


int score;
int shots;
int totalShots;
int currentStreak;
int longestStreak;
float tiltScale;



static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}



@implementation ViewController

@synthesize ball;

float swipeTime;
bool miss;
float SpeedTol;


- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];

    int iAdHeight;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        iAdHeight = 66;

    }
    else {
        
        iAdHeight = 50;
    }

    float sWidth = [UIScreen mainScreen].bounds.size.width;
    float sHeight = [UIScreen mainScreen].bounds.size.height;
    float targetSize = .18*sWidth;
    
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
    self.ngLabel.center = CGPointMake(.5*sWidth, .5*sHeight);
    
    [self.tiltLabel setFrame:CGRectMake(0, 0, sWidth, 75)];
    self.tiltLabel.font = [UIFont fontWithName: @"Marker Felt" size: .05*sWidth];
    self.tiltLabel.center = CGPointMake(.5*sWidth, .5*sHeight);

    [self.settingsButton setFrame:CGRectMake(0, 0, .4*sWidth, .07*sHeight)];
    self.settingsButton.center = CGPointMake(.88*sWidth, 0.07*[UIScreen mainScreen].bounds.size.height);
    self.settingsButton.titleLabel.font = [UIFont fontWithName: @"Marker Felt" size: .04*sWidth];
    
    [self.iAdOutlet setFrame:CGRectMake(0, sHeight - iAdHeight, sWidth, iAdHeight)];
    
    [self.image3 setFrame:CGRectMake(0, 0, targetSize, targetSize)];
    self.image3.center = CGPointMake(.5*sWidth, .18*sHeight);
    self.image3.layer.cornerRadius = .5*self.image3.layer.frame.size.height;
    self.image3.layer.masksToBounds = YES;
    
    [self.leftTilt setFrame:CGRectMake(0, 0, .7*sWidth, .2*sHeight)];
    self.leftTilt.center = CGPointMake(.5*sWidth, .5*sHeight);
    
    [self.rightTilt setFrame:CGRectMake(0, 0, .7*sWidth, .2*sHeight)];
    self.rightTilt.center = CGPointMake(.5*sWidth, .5*sHeight);
   
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    shots = 0;
    totalShots = 0;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        SpeedTol = 36;
        tiltScale = 4.5;
    }
    
    else {
        
        SpeedTol = 18;
        tiltScale = 1.8;
    }
    
    self.leftTilt.hidden = YES;
    self.rightTilt.hidden = YES;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"wasGameLaunched"]) {
        
        NSString *infoString = @"It's a beautiful day on the links. Swipe the ball to get it moving. The length and direction of your swipe determine the speed and direction of the ball. The green can be slippery, so read the breaks carefully! Visit the Settings screen for complete instructions.";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bullz Eye" message:infoString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"wasGameLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        [self.ball setFrame:CGRectMake(0, 0, 80, 80)];
        
    }
    else {
        
        [self.ball setFrame:CGRectMake(0, 0, 40, 40)];
        
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
    
    self.ball.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(soundChanged:)
                                                 name:@"soundDidChange"
                                               object:nil];
    
    self.redSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"ohh"ofType:@"mp3"]] error:NULL];
    [self.redSound prepareToPlay];
    
    self.greenSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"cup"ofType:@"wav"]] error:NULL];
    [self.greenSound prepareToPlay];
    
     self.slideSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"applause"ofType:@"mp3"]] error:NULL];
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
        
        NSLog(@"sound changed");
        
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

-(void)addTilt {
    
    int minTilt = -9;
    int maxTilt = 9;
    NSString *tiltString;
    
    self.tiltSpeed = (arc4random() % (maxTilt - minTilt + 1)) + minTilt;
    
    self.leftTilt.hidden = YES;
    self.rightTilt.hidden = YES;
    
    if(self.tiltSpeed == 0) {
        tiltString = [NSString stringWithFormat:@"Flat"];
    }
    
    if(self.tiltSpeed == 1) {
        
        tiltString = [NSString stringWithFormat:@"%d inch", self.tiltSpeed];
        self.rightTilt.hidden = NO;
    }
    
    if(self.tiltSpeed > 1) {
        tiltString = [NSString stringWithFormat:@"%d inches", self.tiltSpeed];
        self.rightTilt.hidden = NO;
    }
    
    if(self.tiltSpeed ==  -1) {
        tiltString = [NSString stringWithFormat:@"%d inch", -self.tiltSpeed];
        self.leftTilt.hidden = NO;
    }
    
    if(self.tiltSpeed < -1) {
        tiltString = [NSString stringWithFormat:@"%d inches", -self.tiltSpeed];
        self.leftTilt.hidden = NO;
    }
    
    self.tiltLabel.text = tiltString;
}


- (IBAction)newGamePressed:(id)sender {
    
    if (shots > 0 && shots < totalShots) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game in Progress" message:@"Are you sure you want to start a new game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
        alertView.tag = 1;
        [alertView show];
        
    }
    
    if (shots == totalShots) {
        
        [self newGame];
    }

}

- (void)newGame {
    
    self.ngLabel.hidden = YES;
    self.ball.hidden = NO;
    score = 0;
    shots = 0;
    totalShots = maxShots;
    currentStreak = 0;
    longestStreak = 0;
    
    self.scoreLabel.text = @"Score: 0";
    self.shotLabel.text = @"Putt: 0/10";
    [self placeBall];
    
}

-(void)placeBall {
    
    miss = false;
    self.tiltLabel.hidden = NO;
    self.ball.hidden = NO;
    self.ball.alpha = 1.0;
    
    if (self.placeBallTimer.isValid) {
        [self.placeBallTimer invalidate];
    }
    
    [self addTilt];
    
    [self.view setUserInteractionEnabled:YES];
    
    int sWidthInt = [UIScreen mainScreen].bounds.size.width;
    int sHeightInt = [UIScreen mainScreen].bounds.size.height;

    self.ball.center = CGPointMake(.5*sWidthInt, .85*sHeightInt);
    
    if (shots >= totalShots) {
        
        [self endGame];
    }
        
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (shots < totalShots) {
        
        UITouch *touch = [touches anyObject];
        [self.view setUserInteractionEnabled:NO];
        self.firstPoint = [touch locationInView:self.view];
        swipeTime = 0;
        
    /*    self.overlapArray = [NSMutableArray arrayWithObjects:nil];
        
        for (int i = 0; i < numTargets; i++) {
            
            [self.overlapArray addObject:@"false"];
            
        }*/
    //    self.swipeTimer = [NSTimer scheduledTimerWithTimeInterval:swipeIncrement target:self selector:@selector(swipeDuration) userInfo:nil repeats:YES];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
  //  [self.swipeTimer invalidate];
    
  //  NSLog(@"the timer stops at %f seconds", swipeTime);

    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.view];
    
    CGPoint tapVector = rwSub(self.lastPoint, self.firstPoint); // (vector) last point - first point
    
  //  NSLog(@"tapVector = %f %f", tapVector.x, tapVector.y);
    
    self.ballVelocityX = speedScale*tapVector.x;
    self.ballVelocityY = speedScale*tapVector.y;
    
    if (shots < totalShots) {
    
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
        
    }

}

- (void)swipeDuration {
    
 //   swipeTime = swipeTime + swipeIncrement;
    
}


-(void)moveBall {
    
    self.ballVelocityX = speedDamping*(self.ballVelocityX);
    self.ballVelocityY = speedDamping*self.ballVelocityY;

  //  self.tiltSpeed = 0;

    self.ball.center = CGPointMake(self.ball.center.x + self.ballVelocityX + tiltScale*self.tiltSpeed, self.ball.center.y + self.ballVelocityY);
    
  //  if (CGRectIntersectsRect(self.ball.frame, self.image3.frame)) {
    if ((fabs(self.ball.center.x - self.image3.center.x) < horTol*self.image3.frame.size.width) && (fabs(self.ball.center.y - self.image3.center.y) < verTol*self.image3.frame.size.width)) {
        
        if(fabs(self.ballVelocityX) < SpeedTol && fabs(self.ballVelocityY) < SpeedTol && miss==false) {

            [self.gameTimer invalidate];
            shots++;
            totalShots++;
            NSString *shotString = [NSString stringWithFormat:@"Putt: %i/%i", shots, totalShots];
            self.shotLabel.text = shotString;
            
            [self.view setUserInteractionEnabled:YES];
            
            score++;
            currentStreak++;
            
            if (currentStreak > longestStreak) {
                
                longestStreak = currentStreak;
            }
            
            
            NSString *scoreString = [NSString stringWithFormat:@"Score: %i", score];
            self.scoreLabel.text = scoreString;
           
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
                
                [self.greenSound play];

            }
            
            self.ball.center = CGPointMake(self.image3.center.x, self.image3.center.y);
            self.ball.alpha = 0.2;
            
            self.placeBallTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(placeBall) userInfo:nil repeats:NO];
            
        } else {
            
            miss = true;
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
                
                [self.redSound play];
                currentStreak = 0;
                
            }
        }
        
    } else if(fabs(self.ballVelocityX) < 5 && fabs(self.ballVelocityY) < 5) {
            
        [self.gameTimer invalidate];
        shots++;
        currentStreak = 0;
        [self.gameTimer invalidate];
        NSString *shotString = [NSString stringWithFormat:@"Putt: %i/%i", shots, totalShots];
        self.shotLabel.text = shotString;
        
        [self.view setUserInteractionEnabled:YES];
        self.placeBallTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(placeBall) userInfo:nil repeats:NO];
    }
    
    if (fabs(self.ball.center.x) > 800 || self.ball.center.y < -100 || self.ball.center.y > 1000) {
        
        [self.gameTimer invalidate];
        shots++;
        currentStreak = 0;
        [self.gameTimer invalidate];
        NSString *shotString = [NSString stringWithFormat:@"Putt: %i/%i", shots, totalShots];
        self.shotLabel.text = shotString;
        
        [self.view setUserInteractionEnabled:YES];
        self.placeBallTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(placeBall) userInfo:nil repeats:NO];
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 1) {
    
        switch (buttonIndex) {
            case 0: {
                break;
            }
                
            case 1: {
               // shots = 0;
               // totalShots = 0;
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
              //  shots = 0;
              //  totalShots = 0;
                [self newGame];
                break;
            }
                
            default: {
                break;
            }
        }
    }
}

-(void)endGame {
    
   // shots = 0;
   // totalShots = 0;
    
    self.leftTilt.hidden = YES;
    self.rightTilt.hidden = YES;
    self.ngLabel.hidden = NO;
    self.tiltLabel.hidden = YES;
    
    NSLog(@"longest streak = %d", longestStreak);
    
    NSInteger best = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
    NSInteger streak = [[NSUserDefaults standardUserDefaults] integerForKey:@"longestStreak"];

    if (longestStreak > streak) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:longestStreak forKey:@"longestStreak"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[GameCenterManager sharedManager] saveAndReportScore:(int)longestStreak leaderboard:@"LongestStreak" sortOrder:GameCenterSortOrderHighToLow];
        
    }
    
    if (score > best) {
        
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"highScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[GameCenterManager sharedManager] saveAndReportScore:(int)score leaderboard:@"HighScore" sortOrder:GameCenterSortOrderHighToLow];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        
        [self.slideSound play];
        
    }

    
    if (score >= 10 && score < 20) {
        [[GameCenterManager sharedManager] saveAndReportAchievement:@"bullz1" percentComplete:100 shouldDisplayNotification:YES];
    }
    
    if (score >= 20) {
        [[GameCenterManager sharedManager] saveAndReportAchievement:@"bullz2" percentComplete:100 shouldDisplayNotification:YES];
    }
    
    if (longestStreak >= 5 && longestStreak < 10) {
        [[GameCenterManager sharedManager] saveAndReportAchievement:@"bullz3" percentComplete:100 shouldDisplayNotification:YES];
    }
    
    if (longestStreak >= 10) {
        [[GameCenterManager sharedManager] saveAndReportAchievement:@"bullz4" percentComplete:100 shouldDisplayNotification:YES];
    }
    
    
    self.ball.hidden = YES;
    /*  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message:nil delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
     alertView.tag = 2;
     [alertView show];*/
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

