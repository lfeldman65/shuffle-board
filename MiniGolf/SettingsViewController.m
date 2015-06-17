//
//  SettingsViewController.m
//  MiniGolf
//
//  Created by Larry Feldman on 6/15/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UIButton *gcButton;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;

- (IBAction)soundSwitched:(id)sender;
- (IBAction)gameCenterPressed:(id)sender;

@end

@implementation SettingsViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    int iAdHeight;
    
    float sWidth = [UIScreen mainScreen].bounds.size.width;
    float sHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self.backButton setFrame:CGRectMake(0, 0, .3*sWidth, .1*sHeight)];
    self.backButton.center = CGPointMake(.11*sWidth, .11*sHeight);
    self.backButton.titleLabel.font = [UIFont fontWithName: @"Marker Felt" size: .06*sWidth];
    
    [self.soundLabel setFrame:CGRectMake(.6*sWidth, .06*sHeight, .23*sWidth, .1*sHeight)];
    [[self soundLabel] setFont:[UIFont fontWithName:@"Marker Felt" size:.06*sWidth]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        [self.soundSwitch setFrame:CGRectMake(.79*sWidth, .1*sHeight, .23*sWidth, .1*sHeight)];
        
    }
    else {
        
        [self.soundSwitch setFrame:CGRectMake(.79*sWidth, .085*sHeight, .23*sWidth, .1*sHeight)];
        
    }
    
    [self.textView setFrame:CGRectMake(0, 0, .91*sWidth, .6*sHeight)];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        self.textView.font = [UIFont fontWithName: @"Marker Felt" size: .04*sWidth];
        self.textView.center = CGPointMake(.5*sWidth, .48*sHeight);
        
    }
    else {
        
        if(sHeight==480) {
            
            self.textView.font = [UIFont fontWithName: @"Marker Felt" size: .043*sWidth];
            self.textView.center = CGPointMake(.5*sWidth, .46*sHeight);
            
        } else {
            
            self.textView.font = [UIFont fontWithName: @"Marker Felt" size: .05*sWidth];
            self.textView.center = CGPointMake(.5*sWidth, .46*sHeight);
        }
    }
    
    [self.highScoreLabel setFrame:CGRectMake(0, 0, .9*sWidth, 75)];
    self.highScoreLabel.center = CGPointMake(.5*sWidth, .7*sHeight);
    [[self highScoreLabel] setFont:[UIFont fontWithName:@"Marker Felt" size:.06*sWidth]];
    
    [self.gcButton setFrame:CGRectMake(0, 0, sWidth/2, .1*sHeight)];
    self.gcButton.center = CGPointMake(sWidth/2, .83*sHeight);
    [self.gcButton.titleLabel setFont:[UIFont systemFontOfSize:.06*sWidth]];
    self.gcButton.layer.cornerRadius = .3*self.gcButton.layer.frame.size.height;
    self.gcButton.layer.masksToBounds = YES;
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]) {
        
        self.soundSwitch.on = true;
        
    } else {
        
        self.soundSwitch.on = false;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        iAdHeight = 66;
    }
    else {
        
        iAdHeight = 50;
    }
    
    [self.iAdOutlet setFrame:CGRectMake(0, sHeight - iAdHeight, sWidth, iAdHeight)];

}


- (IBAction)backPressed:(id)sender {
    
    [self.delegate settingsDidFinish:self];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSInteger best = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
    NSString *highScoreString = [NSString stringWithFormat:@"High Score: %ld", (long)best];
    self.highScoreLabel.text = highScoreString;
    
}


- (IBAction)soundSwitched:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isSoundOn"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isSoundOn"];
        
    }
    
    else {
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isSoundOn"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"soundDidChange"
     object:self];
    
}



- (IBAction)gameCenterPressed:(id)sender {
    
    
    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
