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

@interface HRConfirmVideoViewController ()

@end

@implementation HRConfirmVideoViewController


- (instancetype)initWithVideoURL:(NSURL *)video andSceneNumber:(int)sceneNumber {
    self = [super init];
    if (self) {
        self.videoURL = video;
        self.sceneNumber = sceneNumber;
    }
    return self;
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
    
    
    
    self.avPlayer = [AVPlayer playerWithURL:self.videoURL];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.videoLayer.frame = CGRectMake(self.view.frame.size.width/2 - (self.view.frame.size.width * .7)/2, 50, self.view.frame.size.width * .7, self.view.frame.size.height * .7);
    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.videoLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];

    [self.avPlayer play];

    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"SCENE%d", self.sceneNumber] withExtension:@"gif"];
    NSString *path = [imgPath path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    self.animatedView = [[FLAnimatedImageView alloc] init];
    self.animatedView.animatedImage = image;
    self.animatedView.frame = self.videoLayer.frame;
    self.animatedView.runLoopMode = NSDefaultRunLoopMode;
    [self.view addSubview:self.animatedView];
    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    [self.animatedView removeFromSuperview];
    
    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"SCENE%d", self.sceneNumber] withExtension:@"gif"];
    NSString *path = [imgPath path];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];

    
    self.animatedView = [[FLAnimatedImageView alloc] init];
    self.animatedView.animatedImage = image;
    self.animatedView.frame = self.videoLayer.frame;
    self.animatedView.runLoopMode = NSDefaultRunLoopMode;
    [self.view addSubview:self.animatedView];
    
    AVPlayerItem *player = [notification object];
    [player seekToTime:kCMTimeZero];
}

- (void)tappedTryAgain {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tappedConfirm{
    
    if(self.sceneNumber == 1){
        [[HRFileManager sharedManager] setVideo1:self.videoURL];
    } else if (self.sceneNumber == 2){
        [[HRFileManager sharedManager] setVideo2:self.videoURL];
    } else if (self.sceneNumber == 3){
        [[HRFileManager sharedManager] setVideo3:self.videoURL];
    } else{
        [[HRFileManager sharedManager] setVideo4:self.videoURL];
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

//        HRBookPageViewController *pageOne = [[HRBookPageViewController alloc] initWithPage:10];
//        [self.navigationController pushViewController:pageOne animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
