//
//  HRConfirmVideoViewController
//  HIRO
//
//  Created by Gabe Jacobs on 8/8/18.
//  Copyright © 2018 Gabe Jacobs. All rights reserved.
//

#import "HRConfirmVideoViewController.h"

@interface HRConfirmVideoViewController ()

@end

@implementation HRConfirmVideoViewController


- (instancetype)initWithVideoURL:(NSURL *)video {
    self = [super init];
    if (self) {
        self.videoURL = video;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tryAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.tryAgainButton.backgroundColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:1.0];
    [self.tryAgainButton setImage:[UIImage imageNamed:@"Cancel"] forState:UIControlStateNormal];
    self.tryAgainButton.frame = CGRectMake((self.view.frame.size.width/2 - [UIImage imageNamed:@"Cancel"].size.width/2) - 150, self.view.frame.size.height - 130,  [UIImage imageNamed:@"Cancel"].size.width,[UIImage imageNamed:@"Cancel"].size.height);
    [self.tryAgainButton addTarget:self action:@selector(tappedTryAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tryAgainButton];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmButton setImage:[UIImage imageNamed:@"Confirm"] forState:UIControlStateNormal];
    self.confirmButton.frame = CGRectMake((self.view.frame.size.width/2 - [UIImage imageNamed:@"Confirm"].size.width/2) + 150, self.view.frame.size.height - 130, [UIImage imageNamed:@"Confirm"].size.width,[UIImage imageNamed:@"Confirm"].size.height);
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
    
    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:@"SCENE1" withExtension:@"gif"];
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
    
    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:@"SCENE1" withExtension:@"gif"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
