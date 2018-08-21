//
//  ViewController.m
//  HIRO
//
//  Created by Gabe Jacobs on 6/15/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRMenuViewController.h"
#import "HRCameraSceneViewController.h"
#import "HRBookPageViewController.h"


@interface HRMenuViewController ()

@end

@implementation HRMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MenuBack"]];
    self.backgroundImageView.frame = self.view.frame;
    [self.view addSubview:self.backgroundImageView];
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:1.0];
    self.startButton.imageView.layer.cornerRadius = 7.0f;
    self.startButton.layer.shadowOffset = CGSizeMake(0, 7);
    self.startButton.layer.shadowRadius = 5;
    self.startButton.layer.shadowOpacity = 0.25;
    self.startButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.startButton.layer.masksToBounds = NO;
    self.startButton.frame = CGRectMake(self.view.frame.size.width/2 + 75, self.view.frame.size.height/2 + 100, 220, 90);
    [self.startButton addTarget:self action:@selector(tappedStart) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"Read" forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:23];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.startButton];
    
    self.viewVideosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.viewVideosButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:1.0];
    self.viewVideosButton.imageView.layer.cornerRadius = 7.0f;
    self.viewVideosButton.layer.shadowOffset = CGSizeMake(0, 7);
    self.viewVideosButton.layer.shadowRadius = 5;
    self.viewVideosButton.layer.shadowOpacity = 0.25;
    self.viewVideosButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewVideosButton.layer.masksToBounds = NO;
    self.viewVideosButton.frame = CGRectMake(self.view.frame.size.width/2 - 220 - 75, self.view.frame.size.height/2 + 100, 220, 90);
    [self.viewVideosButton addTarget:self action:@selector(tappedView) forControlEvents:UIControlEventTouchUpInside];
    [self.viewVideosButton setTitle:@"Saved Videos" forState:UIControlStateNormal];
    self.viewVideosButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:23];
    [self.viewVideosButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.viewVideosButton];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Loop" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    self.player.numberOfLoops = -1; //infinite
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startMusicRecieved:)
                                                 name:@"StopMusic"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopMusicRecieved:)
                                                 name:@"StartMusic"
                                               object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tappedStart {
        HRBookPageViewController *pageOne = [[HRBookPageViewController alloc] initWithPage:1];
        [self.navigationController pushViewController:pageOne animated:YES];

//    HRCameraSceneViewController *cameraPage = [[HRCameraSceneViewController alloc] init];
//    [self.navigationController pushViewController:cameraPage animated:YES];
//
    
}

- (void)startMusicRecieved:(NSNotification *)notification {
    [self.player stop];
}

- (void)stopMusicRecieved:(NSNotification *)notification {
    [self.player play];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
