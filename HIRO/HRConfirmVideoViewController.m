//
//  HRConfirmVideoViewController
//  HIRO
//
//  Created by Gabe Jacobs on 8/8/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRConfirmVideoViewController.h"
#import "HRBookPageViewController.h"
#import "HRReadyToWatchViewController.h"
#import "HRFileManager.h"
#import "HRAnimationFileManager.h"

@interface HRConfirmVideoViewController ()

@end

@implementation HRConfirmVideoViewController


- (instancetype)initWithVideoURL:(NSURL *)video fileName:fileName andSceneNumber:(int)sceneNumber {
    self = [super init];
    if (self) {
        self.videoURL = video;
        self.fileName = fileName;
        self.sceneNumber = sceneNumber;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.avPlayer pause];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tryAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.tryAgainButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:1.0];
    [self.tryAgainButton setImage:[UIImage imageNamed:@"Cancel2"] forState:UIControlStateNormal];
    self.tryAgainButton.frame = CGRectMake((self.view.frame.size.width/2 - [UIImage imageNamed:@"Cancel2"].size.width/2) - 150, self.view.frame.size.height - 140,  [UIImage imageNamed:@"Cancel2"].size.width,[UIImage imageNamed:@"Cancel2"].size.height);
    [self.tryAgainButton addTarget:self action:@selector(tappedTryAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tryAgainButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setImage:[UIImage imageNamed:@"Confirm2"] forState:UIControlStateNormal];
    self.confirmButton.frame = CGRectMake((self.view.frame.size.width/2 - [UIImage imageNamed:@"Confirm2"].size.width/2) + 150, self.view.frame.size.height - 140, [UIImage imageNamed:@"Confirm2"].size.width,[UIImage imageNamed:@"Confirm2"].size.height);
    [self.confirmButton addTarget:self action:@selector(tappedConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmButton];
    
    
    NSURL *fileURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.fileName] URLByAppendingPathExtension:@"mov"];

    self.avPlayer = [AVPlayer playerWithURL:fileURL];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.videoLayer.frame = CGRectMake(self.view.frame.size.width/2 - (self.view.frame.size.width * .7)/2, 50, self.view.frame.size.width * .7, self.view.frame.size.height * .7);
    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.videoLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];

    [self.avPlayer play];

    self.animatedImageView = [[UIImageView alloc] init];
    self.animatedImageView.frame = self.videoLayer.frame;

    UIImage *preloadedImage = [UIImage imageNamed:@"Straw House 10FPS00"];
    if(self.sceneNumber == 2){
        preloadedImage = [UIImage imageNamed:@"Stick House 10 FPS00"];
    } else if(self.sceneNumber == 3){
        preloadedImage = [UIImage imageNamed:@"Brick House 10FPS00"];
    }  else if(self.sceneNumber == 4){
        preloadedImage = [UIImage imageNamed:@"The End 10 FPS00"];
    }
    [self.animatedImageView setImage:preloadedImage];
    
    
    float duration = 5.2f;
    if(self.sceneNumber == 4){
        duration = 3.6f;
    }
    self.animatedImageView.animationRepeatCount = 1;
    self.animatedImageView.animationImages = self.imageArray;
    self.animatedImageView.animationDuration = duration;
    [self loadImages];
    [self.animatedImageView startAnimating];
    [self.view addSubview:self.animatedImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    
    AVPlayerItem *player = [notification object];
    [player seekToTime:kCMTimeZero];
    
    [self.animatedImageView startAnimating];

}

- (void)tappedTryAgain {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tappedConfirm{
    
    if(self.sceneNumber == 1){
        [[HRFileManager sharedManager] setVideo1:self.fileName];
    } else if (self.sceneNumber == 2){
        [[HRFileManager sharedManager] setVideo2:self.fileName];
    } else if (self.sceneNumber == 3){
        [[HRFileManager sharedManager] setVideo3:self.fileName];
    } else{
        [[HRFileManager sharedManager] setVideo4:self.fileName];
    }
    
    [self.avPlayer pause];
    
    if(self.sceneNumber == 1){
        HRBookPageViewController *pageOne = [[HRBookPageViewController alloc] initWithPage:4];
        [self.navigationController pushViewController:pageOne animated:YES];

    } else if(self.sceneNumber == 2){
        HRBookPageViewController *pageOne = [[HRBookPageViewController alloc] initWithPage:7];
        [self.navigationController pushViewController:pageOne animated:YES];
    }
    else if(self.sceneNumber == 3){
        HRBookPageViewController *pageOne = [[HRBookPageViewController alloc] initWithPage:10];
        [self.navigationController pushViewController:pageOne animated:YES];
    }
    else if(self.sceneNumber == 4){
        
        HRReadyToWatchViewController *rVC = [[HRReadyToWatchViewController alloc] init];
        [self.navigationController pushViewController:rVC animated:YES];

    }
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)loadImages{
    if(self.sceneNumber == 1){
        self.animatedImageView.animationImages = [[HRAnimationFileManager sharedManager] getStrawFiles];
    } else if(self.sceneNumber == 2){
        self.animatedImageView.animationImages = [[HRAnimationFileManager sharedManager] getStickFiles];
    } else if(self.sceneNumber == 3){
        self.animatedImageView.animationImages = [[HRAnimationFileManager sharedManager] getBrickFiles];
    } else if(self.sceneNumber == 4){
        self.animatedImageView.animationImages = [[HRAnimationFileManager sharedManager] getEndFiles];
    }
}

@end
