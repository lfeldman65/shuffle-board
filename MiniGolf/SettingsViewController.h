//
//  SettingsViewController.h
//  MiniGolf
//
//  Created by Larry Feldman on 6/15/15.
//  Copyright (c) 2015 Larry Feldman. All rights reserved.
//

//#import "ViewController.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <iAd/iAd.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"




@class SettingsViewController;

@protocol SettingsDelegate

- (void)settingsDidFinish:(SettingsViewController *) controller;

@end


@interface SettingsViewController : UIViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet ADBannerView *iAdOutlet;

@property (weak, nonatomic) id <SettingsDelegate> delegate;


@end
